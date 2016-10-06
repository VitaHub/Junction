ready = () ->
	$('.form-control').keypress (e) ->
	  if (e.which == 13) 
	    $('form#search-form').submit()
	    return false

	$('body').keypress (e) ->
	  if (e.which == 13) 
	    $('form#search-form').submit()
	    return false

	$('#additional-menu').click ->
		if $('#additional-menu').text() == "Show additional options"
			$('#additional-menu').text("Hide additional options")
		else 
			$('#additional-menu').text("Show additional options")
		$('.additional-options').slideToggle();

	cities = $('#city_id').html()
	states = $('#state_id').html()

	selected_country = $('#country_id :selected').text()
	selected_state = $('#state_id :selected').text()
	selected_city = $('#city_id :selected').text()

	$('#state_id').parent().fadeOut()
	$('#city_id').parent().fadeOut()

	if selected_country
		$('#state_id').parent().fadeIn()
		c_options = $(states).filter("optgroup[label='#{selected_country}']").html()
		$('#state_id').html('<option value=""></option>'+c_options)

	if selected_state
		$('#city_id').parent().fadeIn()
		options = $(cities).filter("optgroup[label='#{selected_state}']").html()
		$('#city_id').html('<option value=""></option>'+options)		

	$('#country_id').change ->
		country = $('#country_id :selected').text()
		c_options = $(states).filter("optgroup[label='#{country}']").html()
		if c_options
			$('#state_id').html('<option value=""></option>'+c_options)
			$('#state_id').parent().fadeIn()
			$('#city_id').html('<option value=""></option>')
			$('#city_id').parent().fadeOut()
		else
			$('#state_id').empty()
			$('#state_id').parent().fadeOut()
			$('#city_id').html('<option value=""></option>')
			$('#city_id').parent().fadeOut()

	$('#state_id').change ->
		state = $('#state_id :selected').text()
		options = $(cities).filter("optgroup[label='#{state}']").html()
		if options 
			$('#city_id').html('<option value=""></option>'+options)
			$('#city_id').parent().fadeIn()
		else
			$('#city_id').empty()
			$('#city_id').parent().fadeOut()


$(document).ready(ready)
$(document).on('page:load', ready)