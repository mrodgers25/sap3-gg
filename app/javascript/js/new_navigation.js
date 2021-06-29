document.addEventListener("turbolinks:load", function () {
  $("#menu-toggle").on('click', function (e) {
    e.preventDefault();
    // POST to the sessions controller to toggle session for session[:sb_closed]
    $.ajax({
      type: "POST",
      contentType: "application/json",
      url: "/sessions/toggle_sidebar_state",
      success: function (result) {
        if (result.sb_closed) {
          $("#wrapper").addClass("sb-closed");
        } else {
          $("#wrapper").removeClass("sb-closed");
        }
      }
    });
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
