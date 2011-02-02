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
require 'readability.rb'

post '/' do
   feedurl = params[:feedurl]
   # dname = params[:dname]
   # dpass = params[:dpass]
   # delicious = Rdelicious.new(dname, dpass)
   posts = []
   @chapters = []
   feed = FeedNormalizer::FeedNormalizer.parse open(feedurl)
  feed.entries.each do |post|
    puts post.urls.first.index(/[jpg|png|gif]/)
    puts post.urls.first
    if ((post.urls.first.include? 'jpg') || (post.urls.first.include? 'png') || (post.urls.first.include? 'gif'))
      @chapters.push("content"=>"<img src=\""+post.urls.first+"\">")
    else  
      url = '/readability.php?url='+post.urls.first
      text = open(url).read
      @chapters.push("title"=>post.title,"content"=>text)
    end
    # delicious.add(post.urls.first,post.title,'','madeintoabook') if delicious.is_connected?
  end
  
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
