require 'sinatra'
require 'CSV'
require 'pry'

def news_method
  news = []
  CSV.foreach("articles.csv", headers: true, header_converters: :symbol) do |row|
    news << row.to_hash
  end
  news
end

########## Test Methods ############

def test_title(title)
  if title == ""
    false
  end
end

def test_url(url)
  if !url.include?("http://") && !url.include?("https://") && !url.include?("www.")
    false
  end
end

def test_description(description)
  if description.length < 20
    false
  end
end

####################################

get '/' do
  @news_method = news_method
  erb :index
end


get '/comment' do
  @errors
  erb :comment
end


post '/comment' do
  title = params["title"]
  url = params["url"]
  description = params["description"]

  @errors = []

  if test_title(title) == false
    @errors << "No title."
  end

  if test_url(url) == false
    @errors << "Invalid URL."
  end

  if test_description(description) == false
    @errors << "Description must be more than 20 characters."
  end


  if @errors.count >= 1
    erb :comment
  else
    File.open('articles.csv', 'a') do |file|
      file.puts ("#{title},#{url},#{description}")
    end
    redirect '/'
  end
end






