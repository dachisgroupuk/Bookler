require 'initialiser'

get '/book/:id' do
  @book = Book.find(params[:id])
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
  book = Book.create(:title => params[:title], :url => params[:feedurl])
  book.save
  redirect '/book/'+book.id.to_s
end