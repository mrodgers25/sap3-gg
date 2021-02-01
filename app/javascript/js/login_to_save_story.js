
document.addEventListener("turbolinks:load", function () {
  $("body").on('click', '.login-to-save-story-link', function (event) {
    event.preventDefault();
    alert("Please login to save this story");
  })
});
