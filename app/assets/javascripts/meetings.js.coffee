participantMuteClick = (e) ->
  $(e.target).toggleClass('icon-volume-up').toggleClass('icon-volume-off')

participantAdded = (participant) =>
  $('#participant-list .participant-list-user.hide')
  .clone()
  .removeClass('hide')
  .find('span')
  .text(participant.whoami.name)
  .parent()
  .attr('id', 'userlist-entry-'+participant.whoami.identifier)
  .appendTo('#participant-list .accordion-inner')
  .find('i').click(participantMuteClick)

participantRemoved = (participant) =>
  $('#userlist-entry-'+participant.whoami.identifier).remove()
  
EventBroker.on 'rtc.user.join', participantAdded
EventBroker.on 'rtc.user.left', participantRemoved