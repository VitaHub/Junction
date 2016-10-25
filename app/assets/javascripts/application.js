// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require 'bootstrap-sass-official'
//= require_tree .

/* require turbolinks require sync */


  // For pagination
$(document).ready(function() {
  if ($('.user_search .pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').text("Please Wait...");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});

$(document).ready(function() {
  if ($('#messages-list .pagination').length) {
    $('#messages-list').scroll(function() {
      var url = $('.pagination .previous_page').attr('href');
      if (url && $('#messages-list').scrollTop() < 50) {
        $('.pagination').text("Please Wait...");
        return $.getScript(url);
      };
    });
    return $('#messages-list').scroll();
  }
});

  // Clears user-list after search start
$(document).on('submit','form#search-form',function(){
	$('#user-list').empty();
});