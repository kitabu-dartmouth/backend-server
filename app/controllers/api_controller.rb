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

  def add_link
  end

  def update_link
  end

  def delete_link
  end
end
