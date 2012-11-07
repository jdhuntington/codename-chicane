%w{ database frontend track }.each do |f|
  require File.expand_path("../chicane/#{f}", __FILE__)
end
