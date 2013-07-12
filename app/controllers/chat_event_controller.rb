class ChatEventController < WebsocketRails::BaseController

  def initialize_session
    puts "Session Initialized.\n"
  end
  
  def new_message
    broadcast_message :new_message, message
    puts "New msg:#{message}"
    # puts message
  end

  def add_user
    connection_store[:user] = message
    puts "=======\n User is #{message}"
    broadcast_user_list
  end

  def delete_user
    connection_store[:user] = nil
    broadcast_user_list
  end

  def broadcast_user_list
    users = connection_store.collect_all(:user)
    # puts users
    broadcast_message :user_list, users
  end


end

