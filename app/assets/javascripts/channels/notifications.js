$(document).ready(function() {
	App.notifications = App.cable.subscriptions.create({channel: 'NotificationsChannel'}, {  
	  received: function(data) {
	  	if (data.type == 'new_message') {
  			var conversation = $('#messages-list').data('conversation');
  			if (conversation != data.conversation_id ) {
  				var messages = $('#messages-notification').text();
  				if (messages == '') {
  					$('#messages-notification').removeClass('hidden').text('1');
  				} else {
  					$('#messages-notification').text(parseInt(messages) + 1);
  				};
  			};
	  	} else if (data.type == 'update') {
	  		if (parseInt(data.messages) == 0 ) {
	  			$('#messages-notification').removeClass('hidden').addClass('hidden').text('');
	  		} else {
	  			$('#messages-notification').removeClass('hidden').text(data.messages);
	  		};
	  	};
	  },

	  renderConversation: function(data) {
			return '<tr id='+ data.conversation_id +' class='+ data.conversation_status +'>' + 
				'<td class="photo">' + 
					'<a href=' + data.interlocutor_path + '>' +
						'<img height="70" src=' + data.interlocutor_avatar + ' alt="avatar">' +
					'</a>' +
				'</td>' +
				'<td class="body">' +
					'<a href='+ data.conversation_path +'>' +
						'<div class="list-group-item">' +
							'<span class="name">' + data.interlocutor_name + '</span>' +
							'<span class="time pull-right">' + data.message_time + '</span>' + 
							'<p class='+ data.message_status +'>' + data.sender_name + ': ' + data.message_body + '</p>' +
						'</div>' + 
					'</a>' + 
				'</td>' + 
			'</tr>'   
	  }
	});
});
