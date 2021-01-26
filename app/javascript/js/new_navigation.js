document.addEventListener("turbolinks:load", function () {
  $("#menu-toggle").on('click', function (e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");
  });
})
