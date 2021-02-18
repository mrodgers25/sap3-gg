document.addEventListener("turbolinks:load", function () {
  $("#menu-toggle").on('click', function (e) {
    e.preventDefault();
    $("#wrapper").toggleClass("sb-closed");
  });

  $('body').on('click', function (e) {
    let didNotClickNavbar = $(e.target).closest('.navbar').length === 0;
    let didNotClickSidebar = $(e.target).closest('#sidebar-wrapper').length === 0;
    let screenWidthIsCorrect = $(window).width() < 999;
    let sidebarIsOpen = !$("#wrapper").hasClass("sb-closed");

    if (didNotClickNavbar && didNotClickSidebar && screenWidthIsCorrect && sidebarIsOpen) {
      // close the menu
      $("#wrapper").addClass("sb-closed");
    }
  });
})
