document.addEventListener("turbolinks:load", function () {
  $("#menu-toggle").on('click', function (e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");
  });

  var grid = document.querySelector('.story-grid');
  var msnry = new Masonry(grid, {
    itemSelector: ".grid-item",
    columnWidth: ".grid-sizer",
    gutter: ".gutter-sizer",
    percentPosition: true,
    horizontalOrder: true,
    resize: true
  });
})
