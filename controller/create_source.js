// Edirom Source Manager
// Copyright (C) 2014 Benjamin W. Bohl
// E-Mail: bohl(at)edirom.de
//
// http://www.github.com/edirom/ediromSourceManager
// 
// ## Description & License
// 
// This file implements javascript controllers and functions for Edirom Source Manager form on start page
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

  //create event handler for button#submit
  $("button#submit").click(function(event){
    
    //set event.preventDefault() as otherwise ajax.post fails in firefox
    event.preventDefault();

    //ajax request action to post form data to edirom_createSource.xql that creates corresponding file in eXist-db
    $.ajax({
      type: "POST",
      url: "modules/edirom_createSource.xql",
      data: $('#form_createSource').serialize(),
      dataType: 'text',
      success: function(){
        refreshFileList(QueryString.uri);
      },
      //on complete
      complete: function(){
        // hide form
        $('#addItemDetails').toggle(false);
        //reset form
        formReset();
      },
      error: function(){
        //on error log message to console
        console.log("create source reports failure");
      }
    });
  });
  
  // bind click event for button#reset to
  $('button#reset').click(function(event){
    //call formReset()
    formReset();
  });
});

//define function to reset form and button labels
function formReset(){
  
  //iterating through form-control elements and call reset
  $.each(('#form_createSource .form-control'),
    function(item, i){
      item.reset;
    }
  );
  
  //reset all button label span elements to 'select...'
  $('#form_createSource').find( '[data-bind="label"]' ).text('select...');
  
  //hide form
  $('#addItemDetails').toggle(false);
};