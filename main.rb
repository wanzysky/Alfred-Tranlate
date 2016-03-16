#!/usr/bin/env ruby
# encoding: utf-8

require 'net/http'
require 'json'
require './workflow'

def translate string
  return if string.nil? || string == ''
  puts WorkFlow.new(YoudaoTranslator.translate!(string)).to_xml
end

class YoudaoTranslator
  URL = "http://fanyi.youdao.com/openapi.do?keyfrom=Alfred-Trans&key=397924145&type=data&doctype=json&version=1.1&q=%s"

  def self.translate query
    uri  = URI(URI.escape(URL % query))
    json = Net::HTTP.get(uri)

    result = JSON.parse(json)

    translations = result["translation"]
    explains = []

    explains += result["basic"]["explains"] if result["basic"]
    explains += result["web"]

    translations + explains
  end

  def self.translate! query
    array = self.translate query
    self.to_items array
  end

  def self.to_items array
    items = array.map do |line|
      Item.new do |item|
        item.uid = ""
        item.valid = "yes"
        item.icon = "translate.png"
        case line
        when String
          item.arg   = "http://dict.youdao.com/search?q=%s" % line
          item.title = line
        when Hash
          item.arg      = "http://dict.youdao.com/search?q=%s" % line["key"]
          item.title    = line["value"].join(", ")
          item.subtitle = line["key"]
        else
        end
      end
    end
  end

end
translate $*.join
