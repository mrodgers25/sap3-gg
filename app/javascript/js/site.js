//Create hover tips
document.addEventListener("turbolinks:load", function () {
  $('.has-tooltip').tooltip();
  $('.has-popover').popover({
    trigger: 'hover'
  });

  var grid = document.querySelector('.grid');
  grid.addEventListener('click', function (event) {
    // don't proceed if item was not clicked on
    if (!matchesSelector(event.target, '.grid-item')) {
      return;
    }
    // change size of item via class
    event.target.classList.toggle('grid-item--gigante');
    // trigger layout
    msnry.layout();
  });

});

// function refreshTimer() {
//   $.ajax({
//     url: '/visitors/refresh_timer',
//     format: 'js'
//   })
// }
// setInterval(refreshTimer, 30000); // # 1000 ticks/sec

var Utils = function () {
  return {
    flashMessage: function (msg, status) {
      var myHtml = '<div class="alert alert-' + status + '">' + msg + '</div>';
      return myHtml;
    }
  }
}();
