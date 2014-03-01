# So I have all my scraper things and rake tasks, I want to use that scraper thing to loop through all the emails.

#how do I empty my database

# How do I see what is in my database? e.g. is there a console like in rails?


require 'sinatra'
require 'data_mapper'
require 'builder'
require 'sinatra/flash'

enable :sessions
# Not sure what this line means

SITE_TITLE = "Maybe Later"
SITE_DESCRIPTION = "Treat Yourself If It Goes On Sale"

get '/' do
  @products = Product.all
  erb :home
end

post '/' do
  p = Product.new
  p.email = params[:email]
  p.created_at = Time.now
  p.updated_at = Time.now
  if p.save
    redirect '/', :notice => "We'll email you if your item goes on sale."
  else
    redirect '/', :error => "Something went wrong, please try again."
  end
end


####### Re-instate these later when/if I have a login area ################

# get '/:id' do
#   @note = Note.get params[:id]
#   @title = "Edit note ##{params[:id]}"
#   if @note
#     erb :Edit
#   else
#     redirect '/', :error => "Can't find that note"
#   end
# end

# put '/:id' do
#   n = Note.get params[:id]
#   n.content = params[:content]
#   n.complete = params[:complete] ? 1:0
#   n.updated_at = Time.now
#   if n.save
#     redirect '/', :notice => 'Note updated successfully'
#   else
#     redirect '/', :error => "Error updating note"
#   end
# end

# get '/:id/delete' do
#   @note = Note.get params[:id]
#   @title = "Confirm deletion of Note ##{params[:id]}"
#   if @note
#     erb :edit
#   else
#     redirect '/', :error => "Can't find that note"
#   end
# end

# delete '/:id' do
#   n = Note.get params[:id]
#   if n.destroy
#     redirect '/', :notice => "Note deleted successfully"
#   else
#     redirect '/', :error => "Error Deleting Note"
#   end
# end


not_found do
  status 404
  erb :error_page
end


DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")

class Product
  include DataMapper::Resource
  property :id, Serial
  property :email, Text, :required => true
  property :url, Text, :required => true
  property :price, Integer
  property :reduced, Boolean, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
