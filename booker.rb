# wordcloud.rb
require 'rubygems'
require 'sinatra'
require 'haml'
require 'feed-normalizer'
require 'prince-ruby'
require 'json'
require 'RedCloth'
require 'open-uri'
require 'htmlentities'
require 'digest/md5'
''

post '/' do
   feedurl = params[:feedurl]
   coder = HTMLEntities.new
   posts = []
   @chapters = []
   feed = FeedNormalizer::FeedNormalizer.parse open(feedurl)
  feed.entries.each do |post|
  puts post.urls.first
  sleep 1
  url = 'http://extractomatic.tomtaylor.co.uk/extract?mode=article&url='+post.urls.first
  buffer = open(url, "UserAgent" => "Ruby-Wget").read
  result = JSON.parse(buffer)
   article = result['response']
   if article['title']
   @chapters.push(article)
   end
  end
  template = File.read('views/book.haml')
  haml_engine = Haml::Engine.new(template)
  output = haml_engine.render(Object.new, :@chapters => @chapters)
  puts output
  file = "/tmp/file.pdf"
    prince = Prince.new
    prince.html_to_file(output, file)
    puts @exe_path
   send_file(
     file,
     :filename => 'book.pdf',
     :type => 'application/pdf'
   )
end

get '/' do
  haml :index
end


get '/print.css' do
  send_file(
    'views/print.css',
    :type => 'text/css'
  )end