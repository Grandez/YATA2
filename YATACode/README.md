# YATACode

Codigo no R y no asociado a Quants.

Estructura

YATACode
  |
  +- bin
  +- scripts
  +- project1
  +- project2
  +- ...
  
### bin

No esta gestionado por CVS, se actualiza/genera a partir de scripts

### scripts 

Contiene los procedimientos para generar cada proyecto.
Los scripts que comienzan con _underscore_ son traspasados de manera automatica al directorio bin como ejecutables eliminado el _underscore_ inicial.

### projectx

Cada proyecto vive en su propio directorio, que puede ser un proyecto Eclipse, VS, o de cualquier otro tipo
En el directorio `scripts` debe existir un fichero `_make_projectx.sh` que sera el responsable de contruir el ejecutable desde el directorio `bin`
