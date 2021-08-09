// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
// require("@rails/ujs").start()
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import 'bootstrap/dist/js/bootstrap'
import 'bootstrap/dist/css/bootstrap'
require("stylesheets/application.scss")

import "@fortawesome/fontawesome-free/css/all"
require("trix")
require("@rails/actiontext")

// // has issue with rich_text_area
import "chartkick/chart.js"
// require("chartkick/chart.js")
// require("chartkick")
// require("chart.js")
import "../trix_overrides"


require("jquery")
require("jquery-ui-dist/jquery-ui");
// require("../trix_overrides.js")



// // 引数は指定しなくてよい
// // import Masonry from 'masonry-layout';
// import 'masonry-layout';

// $( function() {
//   $( ".lesson-sortable" ).sortable();
//   $( ".lesson-sortable" ).disableSelection();
// } );

$(document).on('turbolinks:load', function(){
  $('.lesson-sortable').sortable({
    // カーソルの形
    cursor: "grabbing",
    // ドラッグ中にどの位置にカーソルが固定されるか
    cursorAt: { left: 10 },
    placeholder: "ui-state-highlight",
    // update時に呼ばれる
    update: function(e, ui){
      console.log("\\\\ui")
      console.log(ui)
      let item = ui.item;
      let item_data = item.data();
      console.log("____item_data")
      console.log(item_data)
      console.log("item.index()\\\\")
      console.log(item.index())
      console.log("\\\\\item_data.updateUrl")
      console.log(item_data.updateUrl)
      let params = {_method: 'put'};
      // .index() domのindexを取得
      params[item_data.modelName] = { row_order_position: item.index() }
      console.log("\\\\\params")
      console.log(params)
      $.ajax({
        type: 'POST',
        url: item_data.updateUrl,
        dataType: 'json',
        data: params
      });
    },
    stop: function(e, ui){
      console.log("stop called when finishing sort of cards");
    }
  });
});
