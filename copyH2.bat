echo off
::DATA
set CUR_YYYY=%date:~10,2%
set CUR_MM=%date:~4,2%
set CUR_DD=%date:~7,2%
set SUBFILENAME=%CUR_YYYY%-%CUR_MM%-%CUR_DD%


::Caso tenham feito o upload do arquivo no FTP, o programa segue, caso contrario encerra
IF EXIST "C:\FTP_ATIVOS\H2\uracache1.h2.db" (
	ECHO file 'C:\FTP_ATIVOS\H2\uracache1.h2.db' exists
	
	
:: CVP B -----------------------------------------------------------------------------------
	::Pausa o servico VXML do CVP B
	echo Inicio: %DATE% %TIME% > LogB%SUBFILENAME%.txt
	SC \\atvvmcccvpvxm1b stop "VXMLServer"
	SC \\atvvmcccvpvxm1b query "VXMLServer" >> LogB%SUBFILENAME%.txt
	timeout /t 120
	SC \\atvvmcccvpvxm1b query "VXMLServer" >> LogB%SUBFILENAME%.txt

	::Renomeia o arquivo H2 da pasta do CVP B (H:\) e move para o diretorio OLD 
	echo Renomeia para OLD 
	ren H:\uracache1.h2.db uracache1OLD%SUBFILENAME%.h2.db
	echo Move Para pasta OLD
	move H:\uracache1OLD%SUBFILENAME%.h2.db H:\OLD
	echo Arquivo movido para pasta OLD
	
	::Copia o arquivo do FTP para o CVP
	echo INICIO Copia FTP para CVPA %DATE% %TIME% >> LogB%SUBFILENAME%.txt
	copy C:\FTP_ATIVOS\H2\uracache1.h2.db H:\
	echo FIM Copia FTP para CVPB %DATE% %TIME% >> LogB%SUBFILENAME%.txt
	timeout /t 5
	::Starta o Servico VXML do CVP
	SC \\atvvmcccvpvxm1b start "VXMLServer"
	SC \\atvvmcccvpvxm1b query "VXMLServer" >> LogB%SUBFILENAME%.txt
	
	echo Fim: %DATE% %TIME% >> LogB%SUBFILENAME%.txt



:: CVP A -----------------------------------------------------------------------------------
	::Pausa o servico VXML do CVP A
	echo Inicio: %DATE% %TIME% > LogA%SUBFILENAME%.txt
	SC \\atvvmcccvpvxm1a stop "VXMLServer"
	SC \\atvvmcccvpvxm1a query "VXMLServer" >> LogA%SUBFILENAME%.txt
	timeout /t 120
	SC \\atvvmcccvpvxm1a query "VXMLServer" >> LogA%SUBFILENAME%.txt

	::Renomeia o arquivo H2 da pasta do CVP B (G:\) e move para o diretorio OLD 
	echo Renomeia para OLD 
	ren G:\uracache1.h2.db uracache1OLD%SUBFILENAME%.h2.db
	echo Move Para pasta OLD
	move G:\uracache1OLD%SUBFILENAME%.h2.db G:\OLD
	echo Arquivo movido para pasta OLD
	
	::Copia o arquivo do FTP para o CVP
	echo INICIO Copia FTP para CVPA %DATE% %TIME% >> LogA%SUBFILENAME%.txt
	copy C:\FTP_ATIVOS\H2\uracache1.h2.db G:\
	echo FIM Copia FTP para CVPA %DATE% %TIME% >> LogA%SUBFILENAME%.txt
	timeout /t 5
	::Starta o Servico VXML do CVP
	SC \\atvvmcccvpvxm1a start "VXMLServer"
	SC \\atvvmcccvpvxm1a query "VXMLServer" >> LogA%SUBFILENAME%.txt
	echo Fim: %DATE% %TIME% >> LogA%SUBFILENAME%.txt

	
) ELSE (
  ECHO file 'C:\FTP_ATIVOS\H2\uracache1.h2.db' does NOT exist
  ECHO FIM DO PROGRAMA
  echo Arquivo nao existe na pasta as: %DATE% %TIME% >> LogErro%SUBFILENAME%.txt
)



