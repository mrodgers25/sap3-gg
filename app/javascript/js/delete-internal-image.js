document.addEventListener("turbolinks:load", function () {
  $(".story-form").on('click', '.delete-internal-image-btn', function (event) {
    event.preventDefault();
    let id = this.id;

    $.ajax({
      url: '/admin/custom_stories/' + id + '/destroy_internal_image',
      method: 'POST',
      contentType: 'application/json',
    })
      .done(function() {
        location.reload();
      })
  });
});
