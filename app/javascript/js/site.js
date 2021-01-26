//Create hover tips
document.addEventListener("turbolinks:load", function () {
  $('.has-tooltip').tooltip();
  $('.has-popover').popover({
    trigger: 'hover'
  });

  //    function refreshTimer(){
  //        $.ajax({
  //            url: '/visitors/refresh_timer',
  //            format: 'js'
  //        })
  //    }
});

function refreshTimer() {
  $.ajax({
    url: '/visitors/refresh_timer',
    format: 'js'
  })
}
setInterval(refreshTimer, 30000); // # 1000 ticks/sec

var Utils = function () {
  return {
    flashMessage: function (msg, status) {
      var myHtml = '<div class="alert alert-' + status + '">' + msg + '</div>';
      return myHtml;
    }
  }
}();
