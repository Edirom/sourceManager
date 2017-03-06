// Edirom Source Manager
// Copyright (C) 2014 Benjamin W. Bohl
// E-Mail: bohl(at)edirom.de
//
// http://www.github.com/edirom/ediromSourceManager
// 
// ## Description & License
// 
// This file implements javascript controllers and functions for Edirom Source Manager start page
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


// bind document ready function to
$(document).ready(function () {
  
  //get the list of resources in eXist db/edirom-data/
  getFileList();
  
  //bind cleck event to add+ button
  $('#newItem').bind("click", function() {
    $('#addItemDetails').toggle(true);
  });

  //bind click event to dropdown button in form
  $( document.body ).on( 'click', '.dropdown-menu li', function( event ) {
    
    //save currentTarget in variable
    var $target = $( event.currentTarget );
    
    //search for closest button label span to insert selected value from dropdown list (data-bind="label")
    $target.closest( '.input-group-btn' ).find( '[data-bind="label"]' ).text($.trim($target.text())).end().children( '.dropdown-toggle' ).dropdown( 'toggle' ); 
    //search for corersponding (hidden) input field to insert selected value from dropdown list (data-bind="label")
    //in order to provide the form submit with the value
    $target.closest( '.input-group-btn' ).find( '[data-bind="form"]' ).val($.trim($target.text())).end().children( '.dropdown-toggle' ).dropdown( 'toggle' );
    
    return false;
   
  });
});

//declare function to get file list content form eXist-db via ajax.get
function getFileList(){
  $.ajax({
    type: "GET",
    url: "modules/edirom_getFileList.xql",
    dataType: 'json',
    success: function(msg){
      $(function(){
        //check whether returned json contains resource items
        if(msg.resource){
          //process resource items
          $.each(msg.resource, function(i, item) {
            //create table row for each resource containing
            var $tr = $('<tr>').append(
                      //filename
                      $('<td>').text(item.name),
                      //creation-date
                      $('<td>').text(item.created),
                      //icons to call functions
                      $('<td class="file-controls">').append(
                        //info icon to call getFileDetails function
                        $('<span title="show details" class="info glyphicon glyphicon-info-sign">'),
                         //edit icon to open current source in editor
                         $('<span title="edit" class="edit glyphicon glyphicon-edit">'),
                         //trash icon for deleting the file from the database
                         $('<span title="delete" class="trash glyphicon glyphicon-trash">')
                     )
                  //append row to the file list
                  ).attr('id',item.name).appendTo('#ediromFileList');
          });
        }
        
        //bind click event to info icons
        $('span.info').bind("click", function() {
          //remove class 'active' from other rows
          $(this).closest('tr').siblings().toggleClass('active', false);
          //add class active to this row
          $(this).closest('tr').toggleClass('active', true);
          //call function getFileDetails
          getFileDetails($(this).closest('tr')[0].id);
        });
        
        //bind click event to trash icons
        $('span.trash').bind("click", function(event) {
          //calling deleteItem function
          deleteItem($(this).closest('tr')[0].id);
        });
        
        //bind click event to edit icons
        $('span.edit').bind("click", function() {
          //call function openEditor
          openEditor($(this).closest('tr')[0].id);
        });
      })
    },
    error: function() {
      //in case of error log to console
      console.log("getFileList failure");
    }
  });
}

//declare function to get file details by clicking on info icon in file list
function getFileDetails(file){
  //TODO: create function logic
  console.log('getFileDetails called for: ' + file);
}

//delcare function to refresh file list
function refreshFileList(){
  //delete existing table rows
  $.each($('#ediromFileList tbody tr'), function(i, item){
    $(item).remove();
  });
  //repopulate file list
  getFileList();
}

//declare function to delete file form database
function deleteItem(filename){
  //declare corresponding ajax.post submitting to edirom_deleteItem.xql
  $.ajax({
    type: "POST",
    url: "modules/edirom_deleteItem.xql",
    data: {'filename': filename},
    success: function(){
      //refresh file list
      refreshFileList();
    },
    error: function() {
      //in case of error log to console
      console.log("deleteItem failed for: " + filename);
    }
  });
}

//declare function to open submitted filename un eXide editor
function openEditor(filename){
  //TODO: parametrise host url
  var url = 'http://localhost:8080/exist/apps/eXide/index.html?open=/db/edirom_data/'+filename;
  window.open(url, '_blank');
}