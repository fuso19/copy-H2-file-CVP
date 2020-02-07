echo off
::DATA
set CUR_YYYY=%date:~10,2%
set CUR_MM=%date:~4,2%
set CUR_DD=%date:~7,2%
set SUBFILENAME=%CUR_YYYY%-%CUR_MM%-%CUR_DD%


::Caso tenham feito o upload do arquivo no FTP, o programa segue, caso contrario encerra
IF EXIST "FILE MONITORED PATH" (
	ECHO file 'FILE MONITORED PATH' exists
	
	
:: CVP B -----------------------------------------------------------------------------------
	::Pausa o servico VXML do CVP B
	echo Inicio: %DATE% %TIME% > LogB%SUBFILENAME%.txt
	SC \\SERVERNAME stop "VXMLServer"
	SC \\SERVERNAME query "VXMLServer" >> LogB%SUBFILENAME%.txt
	timeout /t 120
	SC \\SERVERNAME query "VXMLServer" >> LogB%SUBFILENAME%.txt

	::Renomeia o arquivo H2 da pasta do CVP B (H:\) e move para o diretorio OLD 
	echo Renomeia para OLD 
	ren 'FILE PATH + FILE NAME' 'FILE PATH + FILE NAME'OLD%SUBFILENAME%
	echo Move Para pasta OLD
	move 'FILE PATH + FILE NAME'OLD%SUBFILENAME% 'PATH'
	echo Arquivo movido para pasta OLD
	
	::Copia o arquivo do FTP para o CVP
	echo INICIO Copia FTP para CVPA %DATE% %TIME% >> LogB%SUBFILENAME%.txt
	copy FILE MONITORED PATH_FROM PATH_TO
	echo FIM Copia FTP para CVPA %DATE% %TIME% >> LogB%SUBFILENAME%.txt
	timeout /t 5
	::Starta o Servico VXML do CVP
	SC \\SERVERNAME start "VXMLServer"
	SC \\SERVERNAME query "VXMLServer" >> LogB%SUBFILENAME%.txt
	
	echo Fim: %DATE% %TIME% >> LogB%SUBFILENAME%.txt
	
) ELSE (
  ECHO file 'FILE MONITORED PATH' does NOT exist
  ECHO FIM DO PROGRAMA
  echo Arquivo nao existe na pasta as: %DATE% %TIME% >> LogErro%SUBFILENAME%.txt
)



