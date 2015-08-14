require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'] || :development )

Dotenv.load unless ENV['RACK_ENV'] == "production"

set :force_ssl, (ENV['RACK_ENV'] == 'production')
before do
  ssl_whitelist = []
  if settings.force_ssl && !request.secure? && !ssl_whitelist.include?(request.path_info)
    halt 400, {'Content-Type' => 'text/plain'}, "Please use SSL."
  end
end

post "/#{ENV['SECRET_PATH']}" do
  recaptcha_response = Unirest.post(
    "https://www.google.com/recaptcha/api/siteverify",
    # headers:{ "Accept" => "application/json" },
    parameters: { :secret => ENV["RECAPTCHA_SECRET"], :response => params['g-recaptcha-response'] }
  )
  if recaptcha_response.body['success']
    Pony.mail({
      :to => ENV['MAIL_TO'],
      :from => ENV['MAIL_TO'],
      :"reply_to" => "#{params['name']} <#{params["email"]}>",
      :subject => ENV['MAIL_SUBJECT'],
      :body => "#{params['name']} <#{params['email']}> wrote: \n\n#{params['message']}",
      :via => :smtp,
      :via_options => {
        :address              => ENV['SMTP_HOST'],
        :port                 => ENV["SMTP_PORT"],
        :enable_starttls_auto => true,
        :user_name            => ENV['SMTP_USER'],
        :password             => ENV['SMTP_PASSWORD'],
        :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain               => ENV['SMTP_HELO_DOMAIN'] # the HELO domain provided by the client to the server
      }
    })
    redirect "#{ENV['SITE_URL']}#{ENV['SITE_THANK_YOU_PATH']}"
  else
    redirect "#{ENV['SITE_URL']}#{ENV['SITE_ROBOT_PATH']}"
  end
end
