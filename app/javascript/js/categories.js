document.addEventListener("turbolinks:load", function () {

  var levelTwo = $('#second-level-categories');
  $(levelTwo).hide();

  var levelThree = $('#third-level-categories');
  $(levelThree).hide();

  $('#category-roots').on('change', function() {
    var selName = $('#category-roots :selected').text();
    var selId = $('#category-roots :selected').val();
    $('#selected-name').text(selName)
    $("#selected-id").get(0).value = selId;
    
    $.ajax({
      url: '/admin/categories/get_subcategories?category_id=' + $(this).val(),
      dataType: 'json',
      success: function(data) {
        if (data.length !== 0) {
          $(levelTwo).show();
          data.forEach(function(v) {
            var id = v.id;
            var name = v.name;
            levelTwo.append(`<option value='${id}'>${name}</option>`);
          });
        }
      }
    });

  });

  $('#second-level-categories').on('change', function() {
    var selName = $('#second-level-categories :selected').text();
    var selId = $('#second-level-categories :selected').val();
    $('#selected-name').text(selName)
    $("#selected-id").get(0).value = selId;

    $.ajax({
      url: '/admin/categories/get_subcategories?category_id=' + $(this).val(),
      dataType: 'json',
      success: function(data) {
        if (data.length !== 0) {
          $(levelThree).show();
          data.forEach(function(v) {
            var id = v.id;
            var name = v.name;
            levelThree.append(`<option value='${id}'>${name}</option>`);
          });
        }
      }
    });
  });

  $('#third-level-categories').on('change', function() {
    var selName = $('#third-level-categories :selected').text();
    var selId = $('#third-level-categories :selected').val();
    $('#selected-name').text(selName)
    $("#selected-id").get(0).value = selId;
  });
});