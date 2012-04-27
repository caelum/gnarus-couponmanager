require 'net/http'
require 'uri'

class AmazonKeysController < ApplicationController
  
  skip_before_filter :authenticate_user!,  :only => :get_code
  
  # GET /amazon_keys
  # GET /amazon_keys.json
  def index
    @amazon_keys = AmazonKey.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @amazon_keys }
    end
  end

  # GET /amazon_keys/1
  # GET /amazon_keys/1.json
  def show
    @amazon_key = AmazonKey.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @amazon_key }
    end
  end

  # GET /amazon_keys/new
  # GET /amazon_keys/new.json
  def new
    @amazon_key = AmazonKey.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @amazon_key }
    end
  end

  # GET /amazon_keys/1/edit
  def edit
    @amazon_key = AmazonKey.find(params[:id])
  end

  # POST /amazon_keys
  # POST /amazon_keys.json
  def create
    key_codes = params[:key_codes].split("\n")
    
    puts key_codes
    
    key_codes.each do |key_code|
      AmazonKey.create({:key_code => key_code.strip}) unless key_code.empty?
    end
    
    respond_to do |format|
          format.html { redirect_to :action => :index, notice: 'Amazon key was successfully created.' }
    end
  end

  # PUT /amazon_keys/1
  # PUT /amazon_keys/1.json
  def update
    @amazon_key = AmazonKey.find(params[:id])

    respond_to do |format|
      if @amazon_key.update_attributes(params[:amazon_key])
        format.html { redirect_to @amazon_key, notice: 'Amazon key was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @amazon_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /amazon_keys/1
  # DELETE /amazon_keys/1.json
  def destroy
    @amazon_key = AmazonKey.find(params[:id])
    @amazon_key.destroy

    respond_to do |format|
      format.html { redirect_to amazon_keys_url }
      format.json { head :no_content }
    end
  end


  def get_code
    user_id = params[:attempt][:author_id]
    token_manager = TokenManager.new(user_id, params[:check])
    
    return_uri = params[:attempt][:return_uri]

    begin
      if token_manager.valid?
        @amazon_key = AmazonKey.find_by_user_id_or_assign_to_user(user_id)
        
        puts "FAZENDO O POST! Key#{@amazon_key}  #{URI.parse(return_uri)}"

        Net::HTTP.post_form(URI.parse(return_uri), 'key' => @amazon_key)
        #Net::HTTP.post_form(URI.parse(return_uri), @amazon_key.to_hash)
      else
        render 'amazon_keys/invalid_token' 
      end
    rescue Exception => e
      puts e
      render 'amazon_keys/unexpected_error' 
    ensure
      envia_email_acabando_chaves
    end
  end


  private
  def envia_email_acabando_chaves
    avaliable_keys = AmazonKey.avaliable
        
    if avaliable_keys.under_minimal? 
      Notifier.envia_email_acabando_chaves(avaliable_keys.current).deliver
    end
  end
end
