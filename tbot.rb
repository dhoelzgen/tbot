puts "Loading system"

require "rubygems"
require File.expand_path(File.join(File.dirname(__FILE__), 'config'))
require "bundler/setup"

require "twitter"
require "tweetstream"
require "yajl"

puts "System loaded, configuring tbot"

TweetStream.configure do |config|
  config.consumer_key = Config::TWITTER_CONSUMER_KEY
  config.consumer_secret = Config::TWITTER_CONSUMER_SECRET
  config.oauth_token = Config::TWITTER_OAUTH_TOKEN
  config.oauth_token_secret = Config::TWITTER_OAUTH_TOKEN_SECRET
  config.auth_method = :oauth
  config.parser   = :yajl
end

Twitter.configure do |config|
  config.consumer_key = Config::TWITTER_CONSUMER_KEY
  config.consumer_secret = Config::TWITTER_CONSUMER_SECRET
  config.oauth_token = Config::TWITTER_OAUTH_TOKEN
  config.oauth_token_secret = Config::TWITTER_OAUTH_TOKEN_SECRET
end

puts "And here we go"

TweetStream::Client.new.track(Config::BOT_TRACK_WORDS) do |status, client|
  begin
    puts "Replying to \"#{status.text}\" by @#{status.user.screen_name} (#{status.id})"
    Twitter.update(Config::BOT_REPLY_MSG.gsub("!USERNAME", "@#{status.user.screen_name}"), {:in_reply_to_status_id => status.id.to_i})
  rescue => ex
    puts "Error: #{ex}"
  end
end