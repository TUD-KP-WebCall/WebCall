class ChatEventController < WebsocketRails::BaseController


  def initialize_session
    puts "Session Initialized.\n"
  end

  def new_message
    broadcast_message :new_message, message
    puts "Message arte:#{message}"
  end

  def add_user
    #puts "request: #{request.inspect}"
    puts "storing user in data store\n"
    data_store[:user] = message

    broadcast_user_list
  end

  def delete_user
    data_store.remove_client
    broadcast_user_list
  end
  
  def broadcast_user_list
    users = data_store.each_user
    puts "broadcasting user list: #{users}\n"
    broadcast_message :user_list, users
  end

end

