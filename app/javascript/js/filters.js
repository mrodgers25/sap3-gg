document.addEventListener("turbolinks:load", function () {
  $("#reset-filters-btn").on("click", function () {
    $('#location-select option[selected="selected"]').each(function () { $(this).removeAttr('selected') });
    $('#place-select option[selected="selected"]').each(function () { $(this).removeAttr('selected') });
    $('#category-select option[selected="selected"]').each(function () { $(this).removeAttr('selected') });
  });
});
