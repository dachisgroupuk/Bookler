require 'rubygems'
require 'sinatra'
require 'haml'
require 'feed-normalizer'
require 'prince-ruby'
require 'json'
require 'open-uri'
require 'digest/md5'
require 'rdelicious'
require 'active_record'
require 'delayed_job'


ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "localhost",
  :username => "root",
  :password => "root",
  :database => "bookler"
)

Delayed::Worker.max_run_time = 900
Delayed::Worker.backend = :active_record


class Book < ActiveRecord::Base
  after_create :queue
  
  def queue
    Delayed::Job.enqueue self
  end
  
  def perform
    posts = []
    @chapters = []
    title = self.title
    feed = FeedNormalizer::FeedNormalizer.parse open(self.url)
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
    output = haml_engine.render(Object.new, :@chapters => @chapters, :self_title => self.title)
    #puts output
    self.content = output
    self.save
  end
  
  
end
