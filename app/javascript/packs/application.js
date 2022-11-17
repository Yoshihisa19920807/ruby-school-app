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
require("stylesheets/application")
// import '../stylesheets/application'
// require.context('../images', true)

import "@fortawesome/fontawesome-free/css/all"
require("trix")
require("@rails/actiontext")


// // has issue with rich_text_area
import "chartkick/chart.js"
// require("chartkick/chart.js")
// require("chartkick")
// require("chart.js")

// require("../trix_overrides.js")
import "../trix_overrides"


require("jquery")
require("jquery-ui-dist/jquery-ui");

require("@nathanvda/cocoon")
window.jQuery = $;
window.$ = $;

// import "video.js"
// require("video.js")
import videojs from 'video.js'
import 'video.js/dist/video-js.css'
// City
import '@videojs/themes/dist/city/index.css';
// Fantasy
import '@videojs/themes/dist/fantasy/index.css';
// Forest
import '@videojs/themes/dist/forest/index.css';
// Sea
import '@videojs/themes/dist/sea/index.css';

require("selectize")

import './course'


// // 引数は指定しなくてよい
// // import Masonry from 'masonry-layout';
// import 'masonry-layout';

// $( function() {
//   $( ".lesson-sortable" ).sortable();
//   $( ".lesson-sortable" ).disableSelection();
// } );

$(document).on('turbolinks:load', function(){

  // drag and drop for lessons on course show
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

  let videoPlayerInstance = document.getElementById('my-video')
  console.log("videoPlayerInstance")
  console.log(videoPlayerInstance)
  if (videoPlayerInstance) {
    let videoPlayer = videojs(document.getElementById('my-video'), {
      controls: true,
      playbackRates: [0.5, 1, 1.5],
      autoplay: false,
      fluid: true,
      preload: false,
      liveui: true,
      responsive: true,
      loop: false,
      // poster: "https://i.imgur.com/EihmtGG.jpg"
    })
    videoPlayer.addClass('video-js')
    videoPlayer.addClass('vjs-big-play-centered')
    videoPlayer.addClass('vjs-theme-sea')
  }

  $("video").on("contextmenu",function(){
    return false;
  });

  // tag form using selectize
  if ($(".selectize")) {
    console.log("if_selectize")
    $(".selectize").selectize({
      create: function(input, callback) {
        console.log("_____input")
        console.log(input)
        console.log("___callback")
        console.log(callback)
        // calling create method on tags_controller
        $.ajax({
          type: "POST",
          url: "/tags",
          data: { tag: { name: input } },
        })
          .done(function(response){
            console.log(response)
            callback({value: response.id, text: response.name });
          })
        // // shorthand
        // $.post('/tags.json', { tag: { name: input } })
        //   .done(function(response){
        //     console.log(response)
        //     callback({value: response.id, text: response.name });
        //   })
      }
    });
  }

});
