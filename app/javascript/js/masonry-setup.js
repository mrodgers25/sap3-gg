document.addEventListener("turbolinks:load", function () {
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

  // after load set the height of page content to match grid height
  // We match the height here so that we can close the menu
  // from jquery on click after scrolling down the grid.
  // The grid system loads in outside of the page initial load
  // the grid system is much further down the 'page' which causes issues when scrolling
  let gridHeight = $(".story-grid").height();
  $("#page-content-wrapper").css("height", gridHeight+"px");
})
