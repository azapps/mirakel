require 'rqrcode'
class StaticPagesController < ApplicationController
  def home
    respond_to do |format|
      format.html do
        redirect_to list_path "all" if current_user && current_user.name==""
        redirect_to taskdconfig if current_user && current_user.name!=""
      end
      format.json { render json: 
        { api_version: APP_CONFIG['api_version'],
          hello_text: APP_CONFIG['hello_text'] }
      }
    end
  end
  def thanks
  end
  def taskdconfig
    @user=current_user
    @user=User.find_by_authentication_token(params[:key]) if params[:key]
    @path=url_for(controller: "staticPages", action:"taskdconfig", key: @user.authentication_token, dl: true)
    @qr = RQRCode::QRCode.new(@path, level: :l)

    if params[:dl]
      render(:text => File.read("data/#{@user.name}.#{@user.org}.taskdconfig"))
      return
    end

    respond_to do |format|
      format.html do
        render layout: "taskd"
      end
    end
  end
end
