module SpreeRedirects
  class RedirectMiddleware
    
    def initialize(app)
      @app = app
    end
   
    def call(env)
      # execute the request using our Rails app
      status, headers, body = @app.call(env)
      if status == 404 && url = find_redirect(env['REQUEST_URI'])
        # Issue a "Moved permanently" response with the redirect location
        [ 301, { "Location" => url }, 'Redirecting you to the new location...' ]
      else
        # Not a 404 or no redirect found, just send the response as is
        [ status, headers, body ]
      end
    end
   
    def find_redirect(path)
      redirect = Redirect.find_by_old_url(path) rescue nil
      return if redirect.nil?
      redirect.new_url
    end
    
  end
end 