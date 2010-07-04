# wordcloud.rb
require 'rubygems'
require 'sinatra'
require 'haml'
require 'feed-normalizer'
require 'prince-ruby'
require 'json'
require 'open-uri'
require 'digest/md5'
require 'rdelicious'
require 'readability_old.rb'

post '/' do
   feedurl = params[:feedurl]
   dname = params[:dname]
   dpass = params[:dpass]
   delicious = Rdelicious.new(dname, dpass)
   posts = []
   @chapters = []
   feed = FeedNormalizer::FeedNormalizer.parse open(feedurl)
  feed.entries.each do |post|
  url = 'http://felixcohen.co.uk/readability.php?url='+post.urls.first
  text = open(url).read
  @chapters.push("title"=>post.title,"content"=>text)
  delicious.add(post.urls.first,post.title,'','madeintoabook') if delicious.is_connected?
  end
  template = File.read('views/book.haml')
  haml_engine = Haml::Engine.new(template)
  output = haml_engine.render(Object.new, :@chapters => @chapters)
  #puts output
  file = "/tmp/book.pdf"
    prince = Prince.new
    prince.add_style_sheets("views/print.css")
    prince.html_to_file(output, file)
   send_file(
     file,
     :filename => '/tmp/book.pdf',
     :type => 'application/pdf'
   )
   haml :book
end

get '/' do
  haml :index
end


get '/print.css' do
  send_file(
    'views/print.css',
    :type => 'text/css'
  )end