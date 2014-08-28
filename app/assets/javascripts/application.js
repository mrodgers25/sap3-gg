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



//copy title
var ready;
ready = function() {
    $('#copy-title').click(function (event) {
        story_url_url_title.value = meta_title_scrape.value;
        event.preventDefault(); // Prevent link from following its href
    });
};
$(document).ready(ready);
$(document).on('page:load', ready);

//copy description
var ready;
ready = function() {
    $('#copy-desc').click(function (event) {
        story_url_url_desc.value = meta_desc_scrape.value;
        event.preventDefault(); // Prevent link from following its href
    });
};
$(document).ready(ready);
$(document).on('page:load', ready);

//copy keywords
var ready;
ready = function() {
    $('#copy-keyw').click(function (event) {
        story_url_url_keywords.value = meta_keyword_scrape.value;
        event.preventDefault(); // Prevent link from following its href
    });
};
$(document).ready(ready);
$(document).on('page:load', ready);

//copy author
var ready;
ready = function() {
    $('#copy-author').click(function (event) {
        story_author.value = meta_author_scrape.value;
        event.preventDefault(); // Prevent link from following its href
    });
};
$(document).ready(ready);
$(document).on('page:load', ready);

//copy author
var ready;
ready = function() {
    $('#copy-dates').click(function (event) {
        story_story_year.value = year.value;
        story_story_month.value = month.value;
        story_story_date.value = date.value;
        event.preventDefault(); // Prevent link from following its href
    });
};
$(document).ready(ready);
$(document).on('page:load', ready)