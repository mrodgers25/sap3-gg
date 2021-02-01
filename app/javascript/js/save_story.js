
document.addEventListener("turbolinks:load", function () {
  $("body").on('click', '.save-story-link', function (event) {
    event.preventDefault();
    let id = this.id;
    let linksDiv = $(this).parent();
    let saveStoryWrapper = $(".save-story-link-" + id);
    let statusText = $(".status-text-" + id);

    $.ajax({
      url: '/stories/' + id + '/save_story',
      method: 'post',
    })
      .done(function (data) {
        if (data['success']) {
          // remove link
          saveStoryWrapper.remove();
          // remove status text
          statusText.remove();
          // append text and forget btn
          linksDiv.append("<p class='forget-story-link forget-story-link-" + id + "' id="+ id +"><a href='javascript: void(0)' id=" + id + " class='btn btn-sm btn-outline-dark grid-item-forget-story-"+ id +"'><i class='fas fa-times mr-1'></i> Forget Story</a></p>");
          linksDiv.append("<p class='status-text-" + id + " success-" + data['success'] + "'>" + data['message'] + "</p>");
        } else {
          linksDiv.append("<p class='status-text-" + id + " success-" + data['success'] + "'>" + data['message'] + "</p>");
        };
      })
  })
});
