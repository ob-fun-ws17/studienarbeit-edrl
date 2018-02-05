#Event-Driven-Relation-Language Interpreter

Zum bauen des Projektes:

cd /path/to/folder

stack build

zum ausfuehren :

stack exec EDRL-exe

Danach koennen folgende befehle eingegeben werden:

befehle                                                     Beispiel
["add_relation","path/to/relation"]                         ["add_relation","d:\\Uni\\Functional\\git\\studienarbeit-edrl\\resource\\rel3.yml"]
["start_execution","path/to/application"]                   ["start_execution","d:\\Uni\\Functional\\git\\studienarbeit-edrl\\resource\\app1.yml"]
["read","path/to/application"]                              ["read","d:\\Uni\\Functional\\git\\studienarbeit-edrl\\resource\\app1.yml"]
["change",variablenName,zahlAlsString]                      ["change","const1","360"]

weitere Befehle befinden sich in der Datei commands.

unter Resource liegen einige Beispiel Relationen und Applikationen
