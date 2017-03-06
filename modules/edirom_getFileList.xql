(: Edirom Source Manager
 : Copyright Benjamin W. Bohl 2014.
 : bohl(at)edirom.de
 :
 : http://www.github.com/edirom/ediromSourceManager
 : 
 : ## Description & License
 : 
 : This file returns the defined collection as JSON
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

(: import needed eXist-db modules :)
import module namespace request="http://exist-db.org/xquery/request";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace system="http://exist-db.org/xquery/system";

(: declare namespaces :)
declare namespace json="http://www.json.org";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace local = "htp://www.edirom.de/ns";
declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace functx = "http://www.functx.com";

declare variable $uri := request:get-parameter('uri','xmldb:exist:///apps/bazga/works');

(: Switch to JSON serialization :)
declare option output:method "json";
declare option output:media-type "text/javascript";

(: functx library function for padding strings to a defined length :)
declare function functx:pad-string-to-length( $stringToPad as xs:string? ,
                                              $padChar as xs:string ,
                                              $length as xs:integer )  as xs:string {

  substring(
    string-join (
      ($stringToPad, for $i in (1 to $length) return $padChar),''),1,$length)
};

declare function functx:pad-integer-to-length( $integerToPad as xs:anyAtomicType? ,
    $length as xs:integer )  as xs:string {

   if ($length < string-length(string($integerToPad)))
   then error(xs:QName('functx:Integer_Longer_Than_Length'))
   else concat
         (functx:repeat-string(
            '0',$length - string-length(string($integerToPad))),
          string($integerToPad))
} ;

declare function functx:repeat-string
  ( $stringToRepeat as xs:string? ,
    $count as xs:integer )  as xs:string {

   string-join((for $i in 1 to $count return $stringToRepeat),
                        '')
 } ;


(: function for returning a prettified version of file creation date :)
declare function local:datePrettyPrint($dateTime){

let $year := fn:year-from-dateTime($dateTime),
		$month := functx:pad-integer-to-length(fn:number(fn:month-from-dateTime($dateTime)),2),
		$day := functx:pad-integer-to-length(fn:number(fn:day-from-dateTime($dateTime)),2),
		$hours := functx:pad-integer-to-length(fn:number(fn:hours-from-dateTime($dateTime)),2),
		$minutes := functx:pad-integer-to-length(fn:minutes-from-dateTime($dateTime),2)
return
	concat($year,'-',$month,'-',$day,' ',$hours,':',$minutes)

};

(: index function for given collection to be returned as XML :)
declare function local:ls($collection as xs:string) as element()* {
  if (xmldb:collection-available($collection)) then
    (         
      for $child in xmldb:get-child-collections($collection)
      let $path := concat($collection, '/', $child)
      order by $child 
      return
        <collection name="{$child}" path="{$path}">
          {
            if (xmldb:collection-available($path)) then (  
              attribute {'files'} {count(xmldb:get-child-resources($path))},
              attribute {'cols'} {count(xmldb:get-child-collections($path))},
              sm:get-permissions(xs:anyURI($path))/*/@*
            )
            else 'no permissions'
          }
          {local:ls($path)}
        </collection>,

        for $child in xmldb:get-child-resources($collection)
        let $path := concat($collection, '/', $child)
        order by $child 
        return
          <resource json:array="true" name="{$child}" path="{$path}" mime="{xmldb:get-mime-type(xs:anyURI($path))}" size="{fn:ceiling(xmldb:size($collection, $child) div 1024)}" created="{local:datePrettyPrint(xmldb:created($collection,$child))}">
            {sm:get-permissions(xs:anyURI($path))/*/@*}
          </resource>
    )
  else ()    
};

(: return collection index :)
<collection>{
local:ls($uri)
}</collection>