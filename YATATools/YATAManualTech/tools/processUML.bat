: Genera los diagramas de los ficheros UML
echo on
set BASE=P:\R\YATA2\YATAManualTech

SET oldwd=%CD%

cd %BASE%\UML

for %%u in (*.uml) do java -jar %PLANTUML% -tpng -o ..\images %%u
:for %%u in (*.uml) do echo  %%u

cd %oldwd%