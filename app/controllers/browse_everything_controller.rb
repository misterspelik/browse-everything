class BrowseEverythingController < ActionController::Base
  layout 'browse_everything'

  def index
    render :layout => !request.xhr?
  end

  def show
    render :layout => !request.xhr?
  end
  
  def auth
    code = params[:code]
    session["#{provider_name}_token"] = provider.connect(params,session["#{provider_name}_data"])
  end

  def resolve
    selected_files = params[:selected_files] || []
    links = selected_files.collect { |file| 
      p,f = file.split(/:/) 
      browser.providers[p].link_for(f)
    }
    render :json => links
  end

  private
  def auth_link
    @auth_link ||= if provider.present?
      link, data = provider.auth_link
      session["#{provider_name}_data"] = data
      "#{link}&state=#{provider.key}"
    else
      nil
    end
  end

  def browser
    if @browser.nil?
      @browser = BrowseEverything::Browser.new(url_options)
      @browser.providers.values.each do |p|
        p.token = session["#{p.key}_token"]
      end
    end
    @browser
  end

  def browse_path
    @path ||= params[:path] || ''
  end

  def provider
    @provider ||= browser.providers[provider_name]
  end

  def provider_name
    @provider_nane ||= params[:provider] || params[:state].to_s.split(/\|/).last
  end

  helper_method :auth_link
  helper_method :browser
  helper_method :browse_path
  helper_method :provider
  helper_method :provider_name
end