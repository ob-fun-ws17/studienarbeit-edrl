# Event-Driven-Relation-Language Interpreter

## Bauen und ausführen

```
cd /path/to/folder
stack build
stack exec EDRL-exe
```

## Befehle

weitere Beispiel befinden sich in der Datei commands.

### Relation hinzufügen
["add_relation","path/to/relation"]
```
["add_relation","d:\\Functional\\git\\studienarbeit-edrl\\resource\\rel3.yml"]
```

### Applikation hinzufügen
["start_execution","path/to/application"]
```
["start_execution","d:\\Functional\\git\\studienarbeit-edrl\\resource\\app1.yml"]
```
### Ergebniss auslesen
["read","path/to/application"]
```
["read","d:\\Functional\\git\\studienarbeit-edrl\\resource\\app1.yml"]
```

### Wert ändern
["change","variablenName","zahlAlsString"]
```
["change","const1","360"]
```
## EDRL
unter Resource liegen einige Beispiel Relationen und Applikationen
