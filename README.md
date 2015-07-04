Edirom Source Manager (edirom-SoMa)
======

eXist-db application-package for managing MEI files for Edirom Online. Supports template-based creation, deletion, and edition via eXide.

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
- `edirom_deleteItem.xql` Line 38 `eclare variable $collection := "xmldb:exist:///db/edirom_data";`


License
-------

This package is available under the terms of [GNU GPL-3 License](https://www.gnu.org/licenses/gpl.html) a copy of the license can be found in the repository [gpl-3.0.txt](gpl-3.0.txt).
