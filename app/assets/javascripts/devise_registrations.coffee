ready = () ->
	cities = $('#user_city_id').html()
	states = $('#user_state_id').html()

	selected_country = $('#user_country_id :selected').text()
	selected_state = $('#user_state_id :selected').text()
	selected_city = $('#user_city_id :selected').text()

	$('#user_state_id').parent().hide()
	$('#user_city_id').parent().hide()

	if selected_country
		$('#user_state_id').parent().show()
		c_options = $(states).filter("optgroup[label='#{selected_country}']").html()
		$('#user_state_id').html('<option value=""></option>'+c_options)

	if selected_state
		$('#user_city_id').parent().show()
		options = $(cities).filter("optgroup[label='#{selected_state}']").html()
		$('#user_city_id').html('<option value=""></option>'+options)		

	$('#user_country_id').change ->
		country = $('#user_country_id :selected').text()
		c_options = $(states).filter("optgroup[label='#{country}']").html()
		if c_options
			$('#user_state_id').html('<option value=""></option>'+c_options)
			$('#user_state_id').parent().show()
			$('#user_city_id').html('<option value=""></option>')
			$('#user_city_id').parent().hide()
		else
			$('#user_state_id').empty()
			$('#user_state_id').parent().hide()
			$('#user_city_id').html('<option value=""></option>')
			$('#user_city_id').parent().hide()

	$('#user_state_id').change ->
		state = $('#user_state_id :selected').text()
		options = $(cities).filter("optgroup[label='#{state}']").html()
		if options 
			$('#user_city_id').html('<option value=""></option>'+options)
			$('#user_city_id').parent().show()
		else
			$('#user_city_id').empty()
			$('#user_city_id').parent().hide()

	# Devise error messages
	$('#error_explanation').addClass('alert alert-warning')
	$('#error_explanation h2').addClass('h4')


$(document).ready(ready)
$(document).on('page:load', ready)