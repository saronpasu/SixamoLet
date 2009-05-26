#!ruby -Ku
#-*- coding: utf-8 -*-
require 'sixamo'

class SixamoLet
  VERSION = [0,0,1]

  def self.version
    VERSION.join('.')
  end

  def initialize(dict = @@dict)
    @@dict = dict
    @@core = Sixamo.new(dict)
  end

  class RequestFailt < StandardError; end

  class Usage
    def call(env)
      res = Rack::Response.new
      usage = <<EOS
SixamoLet version-#{SixamoLet::version}.

Usage:
	GET /help
		show this help.

	GET /version
		show SixamoLet version.

	GET /talk [text]
		talk to SixamoLet.
		input query "text" your message.

	POST /memorize [text]
		memorize for SixamoLet.
		must input query "text" your message.

	PUT /init [dict]
		Initialize for SixamoLet.
		input quary "dict" for DictionaryPath.

EOS
      res.write usage.gsub(/\n/m, '<br/>')
      res.finish
    end
  end

  class Talker < SixamoLet
    def call(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new
      raise RequestFailt.new unless req.get?
      input = Rack::Util::escape(req.GET[:text]) if req.GET[:text]
      res.write @@core.talk(input)
      res.finish
    rescue
      Usage.new.call(env)
    end
  end

  class Memorizer < SixamoLet
    def call(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new
      raise RequestFailt.new unless req.post?
      input = Rack::Util::escape(req.POST[:text])
      @@core.memorize(input)
      res.write input+' is memorized.'
      res.finish
    rescue
      Usage.new.call(env)
    end
  end

  class Initializer < SixamoLet
    def call(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new
      raise RequestFailt.new unless req.put?
      input = Rack::Util::escape(req[:dict]) if req[:dict]
      dict = input ||= @@dict
      @@core = Sixamo.new(dict)
      res.write 'sixamo initialized.'
      res.finish
    rescue
      Usage.new.call(env)
    end
  end

  class Version
    def call(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new
      raise RequestFailt.new unless req.get?
      res.write 'SixamoLet version-'+SixamoLet::version+'.'
      res.finish
    rescue
      res.redirect '/usage'
    end
  end
end

