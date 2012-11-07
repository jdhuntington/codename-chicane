require 'sinatra'

module Chicane
  class Frontend < Sinatra::Base
    set :public_folder, File.expand_path('../../../static', __FILE__)
  end
end
