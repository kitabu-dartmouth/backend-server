require 'rpush'
class ApiController < ApplicationController
  
  # /api/sign_in
  def sign_in
    phoneno = params[:phoneno]
    password = params[:password]
    user = User.find_by_phoneno(phoneno)
    if user == nil
      render json: false
    else
      if user.valid_password? password
        render json: user
      else
        render json: false
      end
    end
  end

  # /api/gcm
  def gcm
    phoneno = params[:phoneno]
    regid = params[:regId]
    user = User.find_by_phoneno(phoneno)
    if user == nil
      render json: false
    else
      user.regid = regid
      user.save
      render json: true
    end
  end

  # /api/message
  def message
    app = Rpush::Gcm::App.new
    app.name = "android_app"
    app.auth_key = "AIzaSyCIg1eu_mSBZcjKy2g6CPbkjjZ6-5yPQsM"
    app.connections = 1
    app.save!
    users = User.all
    reg = []
    users.each do |user|
      if user.regid!= nil or user.regid.length > 0
        reg.append(user.regid)
      end
    end
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name("android_app")
    n.registration_ids = reg
    n.data = { message: "hi mom!" }
    n.priority = 'high'        # Optional, can be either 'normal' or 'high'
    n.content_available = true # Optional
    # Optional notification payload. See the reference below for more keys you can use!
    n.notification = { body: 'great match!',
      title: 'Portugal vs. Denmark',
      icon: 'myicon'
    }
    n.save!
  end
  
  # /api/contacts
  def contacts
    contacts = params[:contacts_str]
    true
  end

  # Helper method
  private def validate_each(value)
    if value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      true
    else
      false
    end
  end

  # /api/register
  def register
    phoneno = params[:phoneno]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    email = params[:email]
    name = params[:name]
    if !validate_each(email) or User.find_by_phoneno(phoneno)!=nil
      render json: false
    else
      user = User.new({:phoneno => phoneno, :password => password, :password_confirmation => password_confirmation, :email => email, :name => name})
      user.save
      user = User.find_by_phoneno(phoneno)
      if user == nil
        render json: false
      else
        if user.valid_password? password
          render json: true
        else
          render json: false
        end
      end
    end
  end

  # /api/add_link
  def add_link
      url = params[:url]
      phoneno = params[:phoneno]
      tags = params[:tags]
      typep = params[:typep]
      @user = User.find_by_phoneno(phoneno)
      @link = Link.create!({:url => url, :user_id => @user.id, :typep => typep, :tag_list => tags})
      if @link == nil
          render json: false
      else
          render json: @link
      end
  end

  def update_link
  end

  def delete_link
    id = params[:id]
    phoneno = params[:phoneno]
    @link = Link.find(id)
    puts @link
    puts User.find_by_phoneno(phoneno)
    begin
      if @link.user_id == User.find_by_phoneno(phoneno)
        @link.destroy
        render json: true
      else
        render json: false
      end
    rescue
      render json: false
    end
  end

  def getlinks
  end

end
