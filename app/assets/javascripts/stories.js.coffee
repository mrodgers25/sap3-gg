# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  preview = $("#preview-url")
  $('#stories_source_url').keyup ->
    current_value = $.trim @value
    if current_value is ''
      preview.hide().attr 'src', ''
    else
      preview.show().attr 'src', current_value

$(document).on "page:change", ->
  alert "page has loaded!"
