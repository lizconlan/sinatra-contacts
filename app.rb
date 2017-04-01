require 'rubygems'
require 'bundler'

Bundler.require

set :database, {adapter: "sqlite3", database: "contacts.sqlite3"}
enable :sessions

class Contact < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :email
end

get '/' do
  @now = Time.now
  @contacts = Contact.all
  @message = session.delete :message
  # @message = session[:message]
  erb :index
end

get '/contact_new' do
  @contact = Contact.new
  erb :contact_form
end

post '/contacts' do
  puts "### これはPOSTされたデータです ###"
  p params
  name = params[:name]
  
  # ここでDBに保存する
  @contact = Contact.new({name: name, email: params[:email]})
  
  if @contact.save
    session[:message] = "#{name}さんを作成しました"
    redirect '/'
  else
    erb :contact_form
  end
  
end

# get '/hoge' do
#   'hoge world'
# end