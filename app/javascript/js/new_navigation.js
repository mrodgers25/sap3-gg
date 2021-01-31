document.addEventListener("turbolinks:load", function () {
  $("#menu-toggle").on('click', function (e) {
    e.preventDefault();
    $("#wrapper").toggleClass("sb-closed");
  });

  $("body").on('click', '#page-content-wrapper', function(e) {
    let screenWidth = $(window).width();
    let sidebarClosed = $("#wrapper").hasClass("sb-closed");

    if (screenWidth < 999 && !sidebarClosed) {
      // close the menu
      $("#wrapper").addClass("sb-closed");
    }
  })
})
