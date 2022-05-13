@ Direção-Geral do Território @

Disponibilizamos um exemplo tipo de ficheiro de projeto QGIS com uma forma de visualização possível dos dados adquiridos 
ao abrigo das especificações técnicas do modelo CartTop.
Este ficheiro está otimizado para a versão QGIS 3.16.11 Long term Release e para a base de dados (CartTop) versão 1.1.2.

Para adaptar este ficheiro de projeto QGIS (nomedaBD_BDv1.1.2_QGISv3.16.11LTR_192.168.0.0_5432_schema_carttop_20220318.qgs) ao que pretende, deve:
1) Editar o ficheiro (por exemplo com find/replace no seu bloco de notas) substituindo os seguintes parâmetros: 
	- nomedaBD -> deve substituir pelo nome da sua base de dados;
	- 192.168.0.0 -> deve substituir este IP pelo IP do seu computador onde estiver a sua base de dados; 
	- 5432 -> deve substituir para o número da sua porta se a sua base de dados estiver com outra porta configurada. 
2) Executar o script sql (schema_carttop_20220318.sql) já que o projeto QGIS está preparado para as relações estabelecidas neste ficheiro SQL.

Nota: Pode executar o script, de várias formas. 
Uma forma possível é ativar (Set as default) a base de dados onde vai ser criado um novo schema carttop, por exemplo, no software opensource dBeaver e colar o código disponibilizado neste script. 
Depois deve executar o script (Execute SQL Script [Alt+X]) no SQL Editor:

![image](https://user-images.githubusercontent.com/46351849/168269963-c6351375-e0dc-44e5-b1d0-875fc66dd9ec.png)
