(: Edirom Source Manager
 : Copyright Benjamin W. Bohl 2014.
 : bohl(at)edirom.de
 :
 : http://www.github.com/edirom/ediromSourceManager
 : 
 : ## Description & License
 : 
 : This file deletes/moves to trash a file with the submitted filenmae in eXis-sb
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

(: import eXist-db modules :)
import module namespace request="http://exist-db.org/xquery/request";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace system="http://exist-db.org/xquery/system";

(: declare namespaces :)
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace local = "htp://www.edirom.de/ns";
declare namespace mei = "http://www.music-encoding.org/ns/mei";

(:declare variables :)
declare variable $collection := "xmldb:exist:///db/edirom_data";
declare variable $ressource := request:get-parameter('filename','');
declare variable $role := sm:get-user-groups(xmldb:get-current-user());

(: TODO: get clear why not working with file:delete(concat($collection,'/',$ressource) :)

if($role = 'dbaedirom')
then(xmldb:remove($collection,$ressource),false)
else(
	if(xmldb:collection-available(concat($collection,'/trash')))
	then(xmldb:move($collection,concat($collection,'/trash'),$ressource))
	else(
	(:TODO: create collection trash, then move
	 :)
	)
)
