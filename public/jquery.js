$( document ).ready(function(){
  $('.login_box').hide().fadeIn(900);
  $('h3').hide().slideDown();
  var $li = $('li');
  $('.left_wrapper').masonry();
  $li.hide().each(function(index) {
    $(this).delay(700 * index).fadeIn(700);
  });
});
