document.addEventListener("turbolinks:load", function () {
  // Sizing once images are loaded
  var grid = document.querySelector('.story-grid');
  if (grid) {
    imagesLoaded(grid, { background: true }, function () {
      console.log('#container background image loaded');
      var msnry = new Masonry(grid, {
        itemSelector: ".grid-item",
        columnWidth: ".grid-sizer",
        gutter: ".gutter-sizer",
        percentPosition: true,
        horizontalOrder: true,
        resize: true
      });
    });
  }

  // var grid = document.querySelector('.story-grid');
  // if (grid) {
  //   var msnry = new Masonry(grid, {
  //     itemSelector: ".grid-item",
  //     columnWidth: ".grid-sizer",
  //     gutter: ".gutter-sizer",
  //     percentPosition: true,
  //     horizontalOrder: true,
  //     resize: true
  //   });
  // }
})
