require 'sinatra/base'
require 'rumoji'
require 'gemoji'

module EmojiHelper
  def emojify(content)
    content.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if Emoji.names.include?($1)
        '<img alt="' + $1 + '" height="20" src="' + "/emoji/#{$1}.png" + '" style="vertical-align:middle" width="20" />'
      else
        match
      end
    end
  end

  def emoji_path(name)
    @emoji_path ||= File.expand_path("../images/emoji", $LOAD_PATH.grep(/gemoji/).first)
    File.join(@emoji_path, "#{name}")
  end
end

class Emojinator < Sinatra::Base
  include EmojiHelper

  get '/' do
    "<form action='/decode' method='post'><input type='text' name='string'></form>"
  end

  get '/emoji/:name' do
    File.read(emoji_path(params[:name]))
  end

  post '/decode' do
    decoded = Rumoji.encode(params[:string])
    "<p>#{decoded}</p>" + "<p>#{emojify(decoded)}</p>"
  end
end
