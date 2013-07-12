# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.Chat = {}

class Chat.User
  constructor: (@user)->
    
  serialize:=> {
	  user_name: @user
	  
  }
    
class Chat.Controller
  messageTemplete: (message) ->
    html = 
      """
       <div class="message" style="display:none">
          <label class="label">
             #{message.user_name}
          </label>:&nbsp;#{message.msg_body}
        </div>
      """
    $(html)
  
  
  userListTemplate: (userList) ->
    userHtml = "<option>ALL</option>"
    for user in userList
      userHtml = userHtml + "<option> #{user.user} </option>" unless user.user_name == @user
    $(userHtml) 
      
  constructor: (@localUser) ->
    @messageQueue = []
    @dispatcher = new WebSocketRails(location.host+"/websocket", true)
    @dispatcher.on_open = @getUserList
    @bindEvents()
    @target_user = 'ALL'
      
  getUserList: =>
    # @user = new Chat.User(@localUser)
    username = ''
    $.each @localUser,(key,value) ->
      username = value.name
    @user = new Chat.User(username)
    @dispatcher.trigger 'new_user', @user
		  
  bindEvents:=>
    @dispatcher.bind 'user_list', @updateUserList
    $('#send').on 'click', @sendMessage
    $('#message').keypress (e) -> 
      if e.keyCode == 13
        e.preventDefault()
        $('#send').click()
    @dispatcher.bind 'new_message', @newMessage
    
   
  updateUserList: (userList) =>
    $('#user-list').html @userListTemplate(userList)
   
  newMessage: (message) =>
    @messageQueue.push message
    TARGET_USER  = message.target_user
    if message.target_user == 'ALL' or message.user_name == @user.user or TARGET_USER ==@user.user
      @appendMessage message
      
  appendMessage: (message) =>
    std_message = @messageTemplete(message)
    ($('#chatDiv').append(std_message))
    #$.when($('#chatDiv').append(std_message)).then
    #($('#chatDiv').scrollTop($('#chatDiv')[0].scrollHeight))
    std_message.slideDown 20

  sendMessage: (event) =>
    event.preventDefault()
    message = $('#message').val()
    this.target_user = $('.to-chat').val()
    @dispatcher.trigger 'new_message',{user_name:@user.user,msg_body:message,target_user:@target_user}
    $('#message').val('')

 EventBroker.on 'rtc.local.user.available', (user) =>
   @chatController = new Chat.Controller(user)
