require 'rubygems' unless defined?(Gem)
require 'httparty'
require 'ms_translate/version'

##
# Wrapper for Microsoft Translator V2
#
# @author Carlo Bertini
#
module MsTranslate
  ##
  # monkey patch to covert method name to camelize
  #
  # @author Yehuda Katz
  #
  # see
  # http://yehudakatz.com/2010/11/30/ruby-2-0-refinements-in-practice/
  #
  class ::String
    ##
    # camlize method
    #
    def camelize()
      self.dup.split(/_/).map{ |word| word.capitalize }.join('')
    end
  end

  ##
  #  Wrapper for Microsoft Translator V2
  #
  # The library is a simple API in Ruby for Microsoft Translator V2
  #
  # The Microsoft Translator services can be used in web or client
  # applications to perform language translation operations. The
  # services  support users who are not familiar with the default
  # language of a page  or application, or those desiring to
  # communicate with people of a  different language group.
  #
  #
  # @author Carlo Bertini
  #
  class Api
    include HTTParty
    base_uri 'http://api.microsofttranslator.com/V2/Http.svc//'
    FROM, TO = :en, :it

    class << self
      # The AppId to work with Microsoft Translator
      attr_accessor :appId

      # The language code to translate the text from
      attr_accessor :from

      # The language code to translate the text into.
      attr_accessor :to

      # init val
      MsTranslate::Api.from ||= FROM
      MsTranslate::Api.to   ||= TO
      available_langauge    ||= nil
    end

    # Invalid language
    #
    class InvalidLanguage < StandardError; end

    # Invalid AppId
    #
    class InvalidAppId < StandardError; end

    # Generic ArgumentException
    #
    class ArgumentException < StandardError; end

    # Generic ArgumentException
    #
    class HTTPMethodNotAllowed < StandardError; end

    ##
    # Translate Method
    #
    # Translates a text string from one language to another
    #
    # @param [.appId] appId
    #   The AppID to work with Microsoft Translator
    #
    # @param [.from] from
    #   The language code to translate the text from
    #
    # @param [.to] to
    #   The language code to translate the text to
    #
    # @param [String] text
    #   the text to translate
    #
    # @return [String]
    #  the translated text
    #
    def self.translate(text, query = {})
      query[:from]   = @from  if query[:from].nil?
      query[:to]     = @to    if query[:to].nil?
      query[:text]   = text

      wrapper( __method__.to_s.camelize,  query)['string']
    end

    ##
    # Detect Method
    #
    # Use the Detect Method to identify the language of a selected
    # piece of text
    #
    # @param [.appId] appId
    #   The AppID to work with Microsoft Translator
    #
    # @param [String] text
    #  some text whose language is to be identified
    #
    # @return  [String]
    #  two-character Language code for the given text
    #
    def self.detect(text)
      wrapper( __method__.to_s.camelize, { :text => text })['string']
    end

    ##
    # DetectArray Method
    #
    # Use the DetectArray Method to identify the language of an array
    # of string at once. Performs independent detection of each
    # individual array element and returns a result for each row of
    # the array
    #
    # @param [.appId] appId
    #   The AppID to work with Microsoft Translator
    #
    # @param [Array] texts
    #  the text from an unknown language
    #
    # @return [String]
    #  two-character Language codes for each row of the input array
    #
    def self.detect_array(texts)
      wrapper( __method__.to_s.camelize, { :text => texts })
    end

    ##
    # GetLanguageNames Method
    #
    # Retrieves friendly names for the languages passed in as the
    # parameter languageCodes, and localized using the passed locale
    # language
    #
    # @param [.appId] appId
    #   The AppID to work with Microsoft Translator
    #
    # @param [String] locale
    #  ISO 639 two-letter lowercase culture code
    #
    # @return [Array]
    #   languages names supported by the Translator Service, localized
    #   into the requested language
    #
    def self.get_language_names(locale, v1 = false)
      wrapper( __method__.to_s.camelize, { :locale => locale.to_s, :v1 => v1 })
    end

    ##
    # GetLanguagesForSpeak Method
    #
    # Retrieves the languages available for speech synthesis
    #
    # @param [.appId] appId
    #   The AppID to work with Microsoft Translator
    #
    # return [Array]
    # Tthe language codes supported for speech synthesis by the
    # Translator Service
    #
    def self.get_languages_for_speak
      wrapper( __method__.to_s.camelize )['ArrayOfstring']['string']
    end

    ##
    # GetLanguagesForTranslate Method
    #
    # Obtain a list of language codes representing languages that are
    # supported by the Translation Service. Translate() and
    # TranslateArray() can translate between any two of these
    # languages
    #
    # @param [.appId] appId
    #   The AppID to work with Microsoft Translator
    #
    # @return [Array]
    #  The language codes supported by the Translator Services
    #
    def self.get_languages_for_translate
      @available_language ||=  wrapper( __method__.to_s.camelize )['ArrayOfstring']['string']
    end

    ##
    # GetTranslations Method
    #
    # Retrieves an array of translations for a given language pair
    # from the store and the MT engine. GetTranslations differs from
    # Translate as it returns all available translations.
    #
    # @param [.appId] appId
    #   The AppID to work with Microsoft Translator
    #
    # @param [.from] from
    #   The language code to translate the text from
    #
    # @param [.to] to
    #   The language code to translate the text to
    #
    # @param [String] text
    #   The text to translate.
    #
    # @param [Integer] maxTranslations
    #  the maximum number of translations to return
    #
    #
    def self.get_translations(text, max_translations)
      wrapper( __method__.to_s.camelize, {:max_translations => max_translations, :text => text})
    end

    ##
    # GetTranslationsArray Method
    #
    # Use the GetTranslationsArray method to retrieve multiple
    # translation candidates for multiple source texts.
    #
    # @param [.appId] appId
    #   The AppID to work with Microsoft Translator
    #
    # @param [.from] from
    #   The language code to translate the text from
    #
    # @param [.to] to
    #   The language code to translate the text to
    #
    # @param [Array] texts
    #  An array containing the texts for translation. All strings
    #  should be of the same language.
    #
    # @param [Integer] maxTranslations
    #  the maximum number of translations to return
    #
    # @return [Array]
    # Returns a GetTranslationsResponse array
    #
    def self.get_translations_array(texts, max_translations)
      wrapper( __method__.to_s.camelize, {:max_translations => max_translations, :texts => texts})
    end

    ##
    # Speak Method
    #
    # Returns a wave or mp3 stream of the passed-in text being spoken in the desired language
    #
    # @param [.appId] appId
    #  The AppID to work with Microsoft Translator
    #
    # @param [String] text
    #   A sentence or sentences of the specified language to be spoken for the wave stream
    #
    # @param [String] language
    #  The supported language code to speak the text in. (see get_languages_for_speak)
    #
    def self.speak(text, language)
      wrapper( __method__.to_s.camelize, {:text => text, :language => language})
    end

    ##
    # TranslateArray Method
    #
    # Use the TranslateArray method to retrieve translations for
    # multiple source texts.
    #
    # @param [.appId] appId
    #   The AppID to work with Microsoft Translator
    #
    # @param [.from] from
    #   The language code to translate the text from
    #
    # @param [.to] to
    #   The language code to translate the text to
    #
    # @param [Array] texts
    #  An array containing the texts for translation. All strings
    #  should be of the same language.
    #
    # @return [Array]
    #   Returns a TranslateArrayResponse array
    def self.translate_array(texts)
      wrapper( __method__.to_s.camelize, {:texts => texts})
    end

    ##
    # BreakSentences Method
    #
    # Breaks a piece of text into sentences and returns an array
    # containing the lengths in each sentence.
    #
    # @param [.appId] appId
    #  The AppID to work with Microsoft Translator
    #
    # @param [String] text
    #   The text to split into sentences.
    #
    # @param [String] language
    #  The language code of input text.
    #
    # @return [Array]
    #  An array of integers representing the lengths of the
    #  sentences. The length of the array is the number of sentences,
    #  and the values are the length of each sentence.
    #
    def self.break_sentences(text, language)
      wrapper( __method__.to_s.camelize, {:text => text, :language => language})['ArrayOfint']['int']
    end

    ##
    # reset attributes to default value
    #
    def self.reset!
      @from  = FROM
      @to    = TO
      @appId = nil
      @available_language = nil
    end

    ##
    # The Wrapper !!!
    #
    # The real method to invoce call function from HTTParty
    #
    # @param [String] method
    #  The method name to call
    #
    # @param [Hash] query
    # the params to send
    #
    #
    # @api private
    def self.wrapper(method, query = {})

      query[:appId]  = @appId if query[:appId].nil?
      raise InvalidAppId      if query[:appId].nil? || query[:appId].length < 16
      # check if you wan V1
      base_uri.gsub!('V2', 'V1') if query.delete(:v1)
      valid_language?( query[:from], query[:to] ) unless query[:from].nil? || query[:to].nil?

      response = get(method, :query => query)
      base_uri.gsub!('V1', 'V2')
      case response.code
      when 200
        response
      when 404
        raise ServiceNotFound
      when 405
        raise HTTPMethodNotAllowed
      when 500...600
        raise ServiceError, "ZOMG ERROR #{response.code}"
      when 400
        raise ArgumentException
      end
    end

    ##
    # ValidLanguage? Method
    #
    # Check if the language is supported from  Microsoft Translator
    #
    # @param [Array] langs
    #  the language to check
    #
    # @return [Boolean]
    #   check resutl :D
    #
    # @api private
    def self.valid_language?(*langs)
      langs.each { |arg_item| raise InvalidLanguage unless get_languages_for_translate.include?(arg_item.to_s) } if langs
    end


    private_class_method :valid_language?
    private_class_method :wrapper

  end

end
