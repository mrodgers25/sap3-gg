$(function(){
  Stories.init();
});

var Stories = function(){

  var saveStory = function(){
    var myLink = $(this);
    var storyDiv = myLink.closest('.story_div');
    var storyId = myLink.attr('data-story-id');
    var failMsg = '<div class="alert alert-danger">There was a problem saving your story</div>';
    var successMsg = '<div class="alert alert-success">Story has been saved</div>';
    $.ajax({
      method: 'POST',
      url: '/visitors/save_story/' + storyId + '.json'
    })
    .done(function(data){
      if(data.success == true){
        storyDiv.append(successMsg)
        myLink.replaceWith('<span class="story_saved_message">Saved</span>');
      }
      else {
        storyDiv.append(failMsg)
      }
    })
    .fail(function(data){
      storyDiv.append(failMsg)
    })
    .always(function(){
      var alertDiv = storyDiv.find('.alert')
      alertDiv.delay(5000).fadeOut(1000);
    });

  }

  return {
    init: function(){
      $('.save_story_link').on('click', saveStory);
    }
  }

}();
