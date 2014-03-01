require 'wombat'
require 'mail'

for @products.each do |product|

  class RubyGemsScraper
    include Wombat::Crawler

      # I have to put some code to divide the url string into base_url and path.
      # product_base_url = product.email just the domain
      # product_path = product.email just the file


      base_url product_base_url
      path product_path

      product "css=h1"
      price "css=#product-price-20749"
      # so depending on the URL I will need to know what the product and price are - this would have to be a separate table

    end

  end

  results = RubyGemsScraper.new.crawl
  price = results["price"]

  # to send out emails using SendGrid need to set up these defaults apparently
  # https://devcenter.heroku.com/articles/sendgrid#ruby-rails
  Mail.defaults do
    delivery_method :smtp, {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end

  def send_mail
    Mail.deliver do
      from   product.email
      to    product.email
      subject 'Price of #{product} has fallen!'
      body    'Go check out the price change on <a href="product.url">product</a>'
    end
  end

  if price != product.price
    send_mail
  end
end