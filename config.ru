require 'sixamolet'

SixamoDir = 'dict'

use Rack::Reloader, 10
SixamoLet.new SixamoDir

map '/' do
  run SixamoLet::Usage.new
end

map '/help' do
  run SixamoLet::Usage.new
end

map '/usage' do
  run SixamoLet::Usage.new
end

map '/version' do
  run SixamoLet::Version.new
end

map '/talk' do
  run SixamoLet::Talker.new
end

map '/memorize' do
  run SixamoLet::Memorizer.new
end

map '/init' do
  run SixamoLet::Initializer.new
end

