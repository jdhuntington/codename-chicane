require 'sinatra'

module Chicane
  class Frontend < Sinatra::Base
    set :public_folder, File.expand_path('../../../static', __FILE__)

    get '/' do
      send_file File.join(settings.public_folder, 'index.html')
    end
  end
end
