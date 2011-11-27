# wordcloud.rb
require 'rubygems'
require 'sinatra'
require 'haml'
require 'feed-normalizer'
require 'data_mapper'
require 'dm-migrations'
require 'prince-ruby'
require 'json'
require 'open-uri'
require 'digest/md5'
require 'rdelicious'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/bookler_dev") 

class Book 
  include DataMapper::Resource
  property :id, Serial
  property :title, Text
  property :content, Text
  property :url, Text
end

DataMapper.auto_upgrade!

get '/book/:id' do
  @book = Book.get(params[:id])
  haml :book
end

get '/' do
  haml :index
end

get '/about' do
  haml :about
end

get '/books' do
  @books = Book.all :limit => 10
  haml :books
end

post '/book' do
  book = Book.new
  book.title = params[:title].to_s
  book.url = params[:feedurl].to_s
  book.save
  posts = []
  @chapters = []
  feed = FeedNormalizer::FeedNormalizer.parse open(book.url)
  feed.entries.each do |post|
    puts post.urls.first.index(/[jpg|png|gif]/)
    puts post.urls.first
    if ((post.urls.first.include? 'jpg') || (post.urls.first.include? 'png') || (post.urls.first.include? 'gif'))
      @chapters.push("content"=>"<img src=\""+post.urls.first+"\">")
    else  
      url = 'http://felixcohen.co.uk/readability.php?url='+post.urls.first
      text = open(url).read
      @chapters.push("title"=>post.title,"content"=>text)
    end
  end
  template = File.read('views/chapters.haml')
  haml_engine = Haml::Engine.new(template)
  output = haml_engine.render(Object.new, :@chapters => @chapters, :book_title => book.title)
  #puts output
  book.content = output
  book.save
  pp book
  redirect '/book/'+book.id.to_s
end
