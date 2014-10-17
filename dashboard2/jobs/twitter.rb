require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'w0IIPDfKtymlLHYoZqyen7Jac'
  config.consumer_secret = 'a0RaGFbfOwOwzajS6erWBxgYU1Ihdz9vQXWAEslD0BhzjUqu0Q'
  config.access_token = '38254654-Lo9SkIL9uUYicq7dDuCKrRX2v9aP2a65UyBb74Mis'
  config.access_token_secret = 'uz0Xp6oJu92Q1ljcq96lACR6ihlupDG3U54YAdClsYxlD'
end

search_term = URI::encode('#caratSF')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end