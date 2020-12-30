document.addEventListener("turbolinks:load", function () {
  $("#menu-toggle").on('click', function (e) {
    e.preventDefault();
    console.log('clicked');
    $("#wrapper").toggleClass("toggled");
  });
})
