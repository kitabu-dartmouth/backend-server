require 'open-uri'
class LinksController < ApplicationController
    before_action :set_link, only: [:show, :edit, :update, :destroy]

    # GET /links
    # GET /links.json
    def index
        @links = Link.all
    end

    # GET /links/1
    # GET /links/1.json
    def show
        @link = Link.find(params[:id])
        respond_to do |format|
            format.html
            format.json {render json: @link}
        end
    end

    # GET /links/new
    def new
        @link = Link.new
    end

    # GET /links/1/edit
    def edit
    end

    # Should wget the url and parse over here.
    private def get_title url
    begin
        doc = Nokogiri::HTML(open(url))
        return doc.css('title').content
    rescue
        return "No title"
    end
end 
# POST /links
# POST /links.json
def create
    @link = Link.new(link_params)
    @link.title = get_title @link.url
    if !@link.title
        @link.title = "No title"
    end
    @link.user_id = current_user.id
arr = [].append(@link.user.regid)
respond_to do |format|
        if @link.save
        puts `curl -X POST \
        -H \"Authorization: key=AIzaSyCIg1eu_mSBZcjKy2g6CPbkjjZ6-5yPQsM\" \
        -H \"Content-Type: application/json\" \
        -d '{ 
        "registration_ids": #{arr.inspect}, 
        "data": {"save": #{@link.to_json}},
        "priority": "high"
        }' \
        https://android.googleapis.com/gcm/send`
            format.html { redirect_to @link, notice: 'Link was successfully created.' }
            format.json { render :show, status: :created, location: @link }
        else
            logger.debug @link.errors.messages
            format.html { render :new }
            format.json { render json: @link.errors, status: :unprocessable_entity }
        end
    end
end

# PATCH/PUT /links/1
# PATCH/PUT /links/1.json
def update
    respond_to do |format|
        if @link.update(link_params)
            format.html { redirect_to @link, notice: 'Link was successfully updated.' }
            format.json { render :show, status: :ok, location: @link }
        else
            format.html { render :edit }
            format.json { render json: @link.errors, status: :unprocessable_entity }
        end
    end
end

# DELETE /links/1
# DELETE /links/1.json
def destroy
    arr = [].append(@link.user.regid)
    logger.debug `curl -X POST \
        -H \"Authorization: key=AIzaSyCIg1eu_mSBZcjKy2g6CPbkjjZ6-5yPQsM\" \
        -H \"Content-Type: application/json\" \
        -d '{ 
        "registration_ids": #{arr.inspect}, 
        "data": {"del":"#{@link.id}"},
        "priority": "high"
        }' \
        https://android.googleapis.com/gcm/send`
    @link.destroy
    respond_to do |format|
        format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
        format.json { head :no_content }
    end
end

# Use callbacks to share common setup or constraints between actions.
private
def set_link
    @link = Link.find(params[:id])
end

# Never trust parameters from the scary internet, only allow the white list through.
def link_params
    params.require(:link).permit(:url, :typep, :tag_list, :title)
end
end
