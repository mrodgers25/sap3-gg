
document.addEventListener("turbolinks:load", function () {
  $('#story_location_ids').chosen({width: '400px', placeholder_text_multiple: 'Choose Locations'});
  $('#story_place_category_ids').chosen({width: '400px', placeholder_text_multiple: 'Choose Place Categories'});
  $('#story_story_category_ids').chosen({width: '400px', placeholder_text_multiple: 'Choose Story Categories'});

  // $(function(){
  //   Stories.init();
  // });

  // var Stories = function(){

  //   var saveStory = function(){
  //     var myLink = $(this);
  //     var storyDiv = myLink.closest('.story_div')
  //     var storyId = myLink.attr('data-story-id');
  //     var failMsg = Utils.flashMessage('There was a problem saving your story', 'danger');
  //     var successMsg = Utils.flashMessage('Story has been saved', 'success');
  //     $.ajax({
  //       method: 'POST',
  //       url: '/visitors/save_story/' + storyId + '.json'
  //     })
  //     .done(function(data){
  //       if(data.success == true){
  //         myLink.after(successMsg);
  //         myLink.replaceWith('<a href="javascript:void(0)" class="forget_story_link" data-story-id=' + storyId + '>FORGET THIS STORY</a>');
  //         $('.forget_story_link').on('click', forgetStory);
  //       }
  //       else {
  //         myLink.after(failMsg);
  //       }
  //     })
  //     .fail(function(data){
  //       myLink.after(failMsg);
  //     })
  //     .always(function(){
  //       var alertDiv = storyDiv.find('.alert');
  //       alertDiv.delay(3000).fadeOut(1000);
  //     });
  //   }

  //   var cannotSaveStory = function(){
  //     var myLink = $(this);
  //     myLink.after(Utils.flashMessage('Sign In to save Story', 'danger'));
  //     var alertDiv = myLink.siblings('.alert')
  //     alertDiv.delay(3000).fadeOut(1000);
  //   }

  //   var forgetStory = function(){
  //     var myLink = $(this);
  //     var storyDiv = myLink.closest('.story_div')
  //     var storyId = myLink.attr('data-story-id');
  //     var successMsg = Utils.flashMessage('Story has been forgotten', 'success');
  //     var failMsg = Utils.flashMessage('There was an error forgetting your Story', 'danger');
  //     $.ajax({
  //       method: 'POST',
  //       url: '/visitors/forget_story/' + storyId + '.json'
  //     })
  //     .done(function(data){
  //       if(data.success == true){
  //         myLink.after(successMsg);
  //         myLink.replaceWith('<a href="javascript:void(0)" class="save_story_link" data-story-id=' + storyId + '>SAVE STORY</a>');
  //         $('.save_story_link').on('click', saveStory);
  //       }
  //       else{
  //         myLink.after(failMsg);
  //       }
  //     })
  //     .fail(function(){
  //       myLink.after(failMsg);
  //     })
  //     .always(function(){
  //       var alertDiv = storyDiv.find('.alert')
  //       alertDiv.delay(3000).fadeOut(1000);
  //     });
  //   }

  //   return {
  //     init: function(){
  //       $('.save_story_link').on('click', saveStory);
  //       $('.cannot_save_story_link').on('click', cannotSaveStory);
  //       $('.forget_story_link').on('click', forgetStory);
  //       $('#story_location_ids').chosen({width: '400px', placeholder_text_multiple: 'Choose Locations'});
  //       $('#story_place_category_ids').chosen({width: '400px', placeholder_text_multiple: 'Choose Place Categories'});
  //       $('#story_story_category_ids').chosen({width: '400px', placeholder_text_multiple: 'Choose Story Categories'});
  //     }
  //   }

  // }();
});
