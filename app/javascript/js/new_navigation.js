document.addEventListener("turbolinks:load", function () {
  $("#menu-toggle").on('click', function (e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");
  });

  // Sizing once images are loaded
  // var grid = document.querySelector('.story-grid');
  // imagesLoaded(grid, { background: true }, function () {
  //   console.log('#container background image loaded');
  //   var msnry = new Masonry(grid, {
  //     itemSelector: ".grid-item",
  //     columnWidth: ".grid-sizer",
  //     gutter: ".gutter-sizer",
  //     percentPosition: true,
  //     horizontalOrder: true,
  //     resize: true
  //   });
  // });

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
