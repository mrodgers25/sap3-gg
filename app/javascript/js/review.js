document.addEventListener("turbolinks:load", function () {
  // UPDATING THE COUNT FROM PASTING IN DESCRIPTION BOX
  $('.counter-div').on('change keyup paste', '#count-text-area', function(){
    newCount = $(this).val().length;
    $('#count-value').text(newCount);
  });
});
