require 'rubygems' unless defined?(Gem)
require 'httparty'
require 'nokogiri'

require "ms_translate/version"

# Module contain wrapper api
#
module MsTranslate

  # class API contain the wrapper API from MS translator to Ruby
  #
  class Api
    include HTTParty

    # Runtime error
    #
    class Error < RuntimeError; end

    # Invalid AppId
    #
    class InvalidAppId < StandardError;  end

    # Microsoft API error hanlder !
    #
    class ArgumentException < StandardError; end

    # Invalid language
    #
    class InvalidLanguage < StandardError; end

    # self class contains the common setting
    #
    class << self
      # Sets the appId [Required]
      attr_accessor :appId
      attr_accessor :from
      attr_accessor  :to
      MsTranslate::Api.from ||= :en
      MsTranslate::Api.to ||= :it
      # url with MS HTTP REST
      MsTranslate::Api.base_uri 'http://api.microsofttranslator.com/V2/Http.svc//'
    end


    # Translate the input text with microsofttranslator api
    #
    # @param [String] text
    #    the text The text to be translated
    # @param [Hash] options
    #    The settings associated with this text
    #
    def self.translate(text, options = {})
      normalize_input(options)
      # @lang =  language_available(query) if @lang.nil? && !@lang.kind_of?(Array)
      query = language_available(options)
      query[:text] = text
      wrapper('Translate', query)['string']
    end

    # Obtains a list of the language codes supported by the Translator
    # Service
    #
    # @api private
    def self.language_available(options = {})
      query = normalize_input(options)
      lang = wrapper('GetLanguagesForTranslate', query)['ArrayOfstring']['string'] if @lang.nil? && !@lang.kind_of?(Array)
      raise InvalidLanguage unless lang.include?(query[:from]) || lang.include?(query[:to])
      lang
    end

    # Normalize parameters before to send to MS'api
    # @param [Hash] query
    #   the parameters to send MS api
    # @return [Hash] Hash with params
    # @api private
    def self.normalize_input(query)
      if query[:replace]
        @appId = query[:appId].to_s unless query[:appId].nil?
        @from  = query[:from].to_s  unless query[:from].nil?
        @to    = query[:to].to_s    unless query[:to].nil?
        query.delete(:replace)
      end
      query[:appId] = @appId.to_s if query[:appId].nil?
      query[:from]  = query[:from].nil? ?  @from.to_s : query[:from].to_s
      query[:to]    = query[:to].nil?   ?  @to.to_s   : query[:to].to_s
      raise InvalidAppId if query[:appId].nil? || query[:appId].length < 16
      query
    end

    # The 'real' call to MS api....
    # @param [String] method
    #   The name of the REST api name
    # @param [Hash] query
    #  The list of param to send api
    #
    # @api private
    def self.wrapper(method, query = {})
      response = get(method, :query => query)
      case response.code
      when 200
        response
      when 404
        puts "O noes not found!"
      when 500...600
        puts "ZOMG ERROR #{response.code}"
      when 400
        raise ArgumentException, ::Nokogiri::HTML.fragment(response).text.strip
      end
    end

    private_class_method :normalize_input
    private_class_method :wrapper

  end  # Api
end # MsTranslate
