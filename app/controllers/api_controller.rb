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
        mycontact = params[:phoneno]
        phonenos = params[:contacts_str].delete('[').delete(']').split(',')
        sendnos = []
        phonenos.each do |ph|
            ph = ph.delete("-")
            ph = ph.delete(" ")
            ph = ph.delete("+")
            ph = ph.delete("(")
            ph = ph.delete(")")
            sendnos.push(ph.reverse[0,10].reverse)
        end
        logger.debug sendnos
        users = User.all
        reg = []
        users.each do |user|
            if sendnos.include? user.phoneno
                if user.regid
                    reg.append(user.regid)
                end
            end
        end
        @link = Link.find(params[:id])
        l = {:url => @link.url, 
             :title => @link.title,
             :id => @link.id,
             :phoneno => mycontact
        }
        logger.debug reg.inspect
        logger.debug l.to_json
        puts `curl -X POST \
        -H \"Authorization: key=AIzaSyCIg1eu_mSBZcjKy2g6CPbkjjZ6-5yPQsM\" \
        -H \"Content-Type: application/json\" \
        -d '{ 
        "registration_ids": #{reg.inspect}, 
        "data": #{l.to_json},
        "priority": "high"
        }' \
        https://android.googleapis.com/gcm/send`
        #"notification": {"body": "#{@link.url}", 
        #"title": "#{@link.title} from #{mycontact}"
        #"icon": "myicon"}
        

        render json:true
    end

    # /api/contacts
    def contacts
        contacts = params[:contacts_str]
        true
    end

    # Helper method
    def validate_each(value)
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
        if typep == 1
            typenew = true
        elsif typep == 0
            typenew = false
        end
        title = get_title url
        @user = User.find_by_phoneno(phoneno)
        @link = Link.create!({:url => url, :user_id => @user.id, :typep => typep, :tag_list => tags, :phoneno => phoneno, :title => title})
        if @link == nil
            render json: false
        else
            render json: @link
        end
    end

    # helper method
    private def get_title url
    begin
        doc = Nokogiri::HTML(open(url))
        return doc.css('title').content
    rescue
        return "No title"
    end
end 

    def update_link
    end

    # /api/delete_link
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

    # /api/getlinks/:id/:phoneno
    def getlinks
        @alllinks = {"public" => [], "private" => []}
        if params[:id] and params[:phoneno]
            user = User.find_by_phoneno(params[:phoneno])
            @alllinks["public"] = Link.select {|link| link.id > params[:id].to_i and link.typep == true}
            @alllinks["private"] = Link.select { |link| link.user_id == user.id and link.typep == false}
        else
            render json: false
        end
        render json: @alllinks
    end
end
