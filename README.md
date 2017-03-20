Edirom Source Manager (edirom-SoMa)
======

>Der Zellkörper oder das Soma ist der formgebende Rumpf einer Zelle ohne ihre Zellfortsätze […].
<br/>– [Zellkörper](http://flexikon.doccheck.com/de/Zellk%C3%B6rper), DocCheck Flexikon ([List of Authors](http://flexikon.doccheck.com/Spezial:Artikel_Autoren/Zellkörper), licensed under [CC BY-NC-SA 3.0 Unported](http://creativecommons.org/licenses/by-nc-sa/3.0/deed.de), accessed 2017-03-20)

eXist-db application-package for managing MEI files for Edirom Online. Supports template-based creation, deletion, and editing via eXide.

Version 0.1 alpha
-----------------

* add files
* delete files
* open files in eXide for editing

Setup / Miscellaneous
---------------------

* expects collection for generated and listed MEI files in eXist-db at:
`/db/edirom_data`

this may be changed in the following files
- for file creation:
- `modules/edirom_createSource.xql` Line 50 `declare variable $sourceCollectionPath := 'xmldb:exist:///db/edirom_data/';`

- for file list:
- `modules/edirom_getFileList.xql` Line 98 `local:ls('xmldb:exist:///db/edirom_data')`
 
- for file deltion in:
- `edirom_deleteItem.xql` Line 38 `declare variable $collection := "xmldb:exist:///db/edirom_data";`


License
-------

This package is available under the terms of [GNU GPL-3 License](https://www.gnu.org/licenses/gpl.html) a copy of the license can be found in the repository [gpl-3.0.txt](gpl-3.0.txt).
