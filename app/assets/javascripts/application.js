// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree .


// no operation
//var ready;
//ready = function() {
//    $('#noop').click(function (event) {
//        meta_type_scrape_og.value = meta_type_scrape_og.value;
//        event.preventDefault(); // Prevent link from following its href
//    });
//};
//$(document).ready(ready);
//$(document).on('page:load', ready);

//Create hover tips
$(document).ready(function() {
    $('.has-tooltip').tooltip();
    $('.has-popover').popover({
        trigger: 'hover'
    });
});