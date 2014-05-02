(: Edirom Source Manager
 : Copyright Benjamin W. Bohl 2014.
 : bohl(at)edirom.de
 :
 : http://www.github.com/edirom/ediromSourceManager
 : 
 : ## Description & License
 : 
 : This file creates a MEI file in eXist-db according to submitted parameters
 :
 : This program is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.
 :
 : This program is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 : GNU General Public License for more details.
 :
 : You should have received a copy of the GNU General Public License
 : along with this program.  If not, see <http://www.gnu.org/licenses/>.
 :)

xquery version "3.0";

(: import relevant eXist-db modules :)
import module namespace request="http://exist-db.org/xquery/request";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace system="http://exist-db.org/xquery/system";
import module namespace config="http://www.edirom.de/sourceManager/config" at "config.xqm";

(: declare namespaces :)
declare namespace local = "htp://www.edirom.de/ns";
declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";

(: file information - submitted parameters :)
declare variable $filename := concat(request:get-parameter('filename',''),'.xml');
declare variable $fileResp := request:get-parameter('fileResp', 'creator');
declare variable $fileResp_v := request:get-parameter('fileResp_v', 'file_resp_name');

(: source information -submitted parameters :)
declare variable $sourceTitle := request:get-parameter('sourceTitle','source title');
declare variable $sourceResp := request:get-parameter('sourceResp', 'composer');
declare variable $sourceResp_v := request:get-parameter('sourceResp_v', 'source_resp_name');

(: functional variables :)
declare variable $sourceCollectionPath := 'xmldb:exist:///db/edirom_data/';
declare variable $id := request:get-parameter('filename', 'id');
declare variable $expath-descriptor := config:expath-descriptor();

(: load MEI template file :)
(: TODO: make variable a cache of the doc not a reference :)
declare variable $meiTemplate := fn:doc('xmldb:exist:///db/apps/ediromSourceManager/templates/newSource.xml');

(: declare the appInfo element for inserting into the created MEI file :)
declare variable $appInfo := element {fn:QName('http://www.music-encoding.org/ns/mei','appInfo')} {
  element application {
    attribute xml:id {$expath-descriptor//@abbrev},
    attribute version {$expath-descriptor//@version},
    element name {$expath-descriptor//expath:title/text()},
    element ptr {
      attribute target {config:repo-descriptor()//repo:website/text()}
    }
  }
};

(: declare change element for Edirom Source MAnager for insertion in created file :)
declare variable $change := element {fn:QName('http://www.music-encoding.org/ns/mei','change')} {
  attribute n {count($meiTemplate//mei:revisionDesc/mei:change)+1},
  element respStmt {
    element name {
      attribute nymref {'#' || $expath-descriptor//@abbrev}
    }
  },
  element changeDesc {
    element p {'Copied template file and updated it with the submitted parameters: filename (also went to  mei/@xml:id), file responsibility, source title, source responsibility, appInfo, and this change'}
  },
  element date {
    attribute isodate {fn:current-dateTime()}
  }
};

(: declare function for updating supplied values in the created MEI file :)
declare function local:updateValues($meiTemplate, $filename, $fileResp, $fileResp_v, $sourceTitle, $sourceResp, $sourceResp_v){
(: TODO: mei/@xml:id
 : cleanup template file
 : insert appinfo
 : insert change :)

  update replace $meiTemplate//mei:fileDesc/mei:titleStmt/mei:title[1] with element {QName('http://www.music-encoding.org/ns/mei','title')} {$filename},
  update insert attribute xml:id {$id} into $meiTemplate/mei:mei,
  update replace $meiTemplate//mei:encodingDesc/mei:appInfo[@xml:id='dummy'] with $appInfo,
  update insert $change into $meiTemplate//mei:revisionDesc,
  if($fileResp != '') then(update insert element {QName('http://www.music-encoding.org/ns/mei',$fileResp)} {$fileResp_v} into $meiTemplate//mei:fileDesc/mei:titleStmt)else(),
  if($sourceTitle != '')then(update replace $meiTemplate//mei:sourceDesc//mei:title[1] with element {QName('http://www.music-encoding.org/ns/mei','title')} {$sourceTitle})else(),
  if($sourceResp != '')then(update insert element {QName('http://www.music-encoding.org/ns/mei',$sourceResp)} {$sourceResp_v} into $meiTemplate//mei:sourceDesc//mei:titleStmt)else()
};

(: declare function for storing file in eXist-db :)
declare function local:store($collection-uri,$resource-name,$contents){
  if(xmldb:collection-available($collection-uri))
  then(xmldb:store($collection-uri, $resource-name, $contents)
    (:  'open ressource in eXide':)
  )
  else()
};

declare function local:generateID(){
  fn:generate-id()
};

declare function local:return(){
	local:store($sourceCollectionPath, $filename, $meiTemplate),
	local:updateValues(fn:doc(fn:concat($sourceCollectionPath,$filename)), $filename, $fileResp, $fileResp_v, $sourceTitle, $sourceResp, $sourceResp_v)
};

(:if(fn:doc-available(concat($sourceCollectionPath,$filename)))
then(fn:error(fileExists,concat('a file with the spcified filename (',$filename,') already exists ')))
else( :)
  local:return()
(:):)
