document.addEventListener("turbolinks:load", function () {
  $(".story-form").on('click', '.destroy-image-btn', function (event) {
    event.preventDefault();
    let id = this.id;
    let imageType = $(this).attr('data-image-type');

    if (confirm('Delete this image?')) {
      $.ajax({
        url: '/admin/custom_stories/' + id + '/destroy_image?image_type=' + imageType,
        method: 'POST',
        contentType: 'application/json',
      })
        .done(function() {
          location.reload();
        })
    }
  });
});
