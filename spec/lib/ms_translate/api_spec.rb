# require_relative '../../spec_helper'
# For Ruby < 1.9.3, use this instead of require_relative
require (File.expand_path('./../../../spec_helper', __FILE__))

describe MsTranslate::Api do

  describe "default attributes" do
    before do
      MsTranslate::Api.appId = nil
      @client_secret_real =  ''
      @client_id_real = ''
      @appId_real = ''
    end
    it "must include httparty methods" do
      MsTranslate::Api.must_include HTTParty
    end   

    it "must have the base url set to MS Translator API endpoint" do
      MsTranslate::Api.base_uri.must_equal 'http://api.microsofttranslator.com/V2/Http.svc/'
    end   

    it "must get/set appId attribute" do
      MsTranslate::Api.appId.must_be_nil
      MsTranslate::Api.appId = @appId_real
      MsTranslate::Api.appId.must_equal  ""
    end
    
  end

  describe "GET MS translator" do
    before do
      VCR.insert_cassette __name__ , :record => :new_episodes
      @appId_real =  ''
      @client_secret_real =  ''
      @client_id_real = ''
      MsTranslate::Api.appId = @appId_real                         
      MsTranslate::Api.client_secret = @client_secret_real                         
      MsTranslate::Api.client_id = @client_id_real                         
      # make HTTP request in before
    end
  
    after do
      # make HTTP request in after
      MsTranslate::Api.reset!
      VCR.eject_cassette
    end  
    it 'translate Hello World! with default language' do
      translate = MsTranslate::Api.translate('Ciao Mondo!')
      translate.must_equal 'Ciao Mondo!'
    end
  
    it 'translate Hello World! without client_id or secret_id' do
      MsTranslate::Api.appId = "invalid_appId"
      lambda { MsTranslate::Api.translate('Hello World') }.must_raise MsTranslate::Api::ArgumentException
    end
    it 'translate Ciao Mondo! from en to it' do
      translate = MsTranslate::Api.translate('Hello World!', {:from => :en, :to => :it })
      translate.must_equal 'Salve, mondo!'  
    end
  
    it 'translate Ciao Mondo! from it to fr' do
      translate = MsTranslate::Api.translate('Ciao Mondo!',{:from => :it, :to => :fr})
      translate.must_equal 'Salut tout le monde!'
    end
      
      
    it 'must have a list language available' do
      MsTranslate::Api.get_languages_for_translate
      MsTranslate::Api.get_languages_for_translate.must_be_instance_of Array
      MsTranslate::Api.get_languages_for_translate.must_equal  ["ar", "bg", "ca", "zh-CHS", "zh-CHT", "cs", "da", "nl", "en", "et", "fi", "fr", "de", "el", "ht", "he", "hi", "mww", "hu", "id", "it", "ja", "ko", "lv", "lt", "no", "pl", "pt", "ro", "ru", "sk", "sl", "es", "sv", "th", "tr", "uk", "vi"]
    end  
  
    it 'translate Hello World! with invalid language' do
      MsTranslate::Api.from = :ge
      MsTranslate::Api.to = :xu
      lambda { MsTranslate::Api.translate('Hello World') }.must_raise MsTranslate::Api::InvalidLanguage
    end
    
    it 'translate Hello World! with invalid appId' do
      MsTranslate::Api.appId = "invalid_appId_very_long_but_wrong"
      lambda { MsTranslate::Api.translate('Hello World') }.must_raise MsTranslate::Api::ArgumentException
    end
  
    it 'DETECT the language of selection of text' do
      MsTranslate::Api.detect('Hello World!').must_equal 'en'
      MsTranslate::Api.detect('Ciao Mondo!').must_equal 'it'
      MsTranslate::Api.detect('Salut tout le monde!').must_equal 'fr'
    end
  
    it 'Detects the language of an array of strings' do
      lambda { MsTranslate::Api.detect_array(['Hello', 'World!"'] ) }.must_raise MsTranslate::Api::HTTPMethodNotAllowed
     end
  
    it 'Get  a list of the languages supported by the Translator Service *' do
      lambda { MsTranslate::Api.get_language_names(:it ) }.must_raise MsTranslate::Api::HTTPMethodNotAllowed
      MsTranslate::Api.get_language_names(:it, true).must_include 'Italiano'
    end
  
    it 'Get a list of the language codes supported by the Translator Service for speech synthesis.' do
      MsTranslate::Api.get_languages_for_speak.must_be_instance_of Array
      MsTranslate::Api.get_languages_for_speak.include?('it').must_equal true
    end
  
    it 'Get a list of the language codes supported by the Translator Service.' do
      MsTranslate::Api.get_languages_for_translate.must_be_instance_of Array
      MsTranslate::Api.get_languages_for_translate.include?('it').must_equal true
    end
  
    it 'Get an array of alternative translations of the given text. ' do
      lambda { MsTranslate::Api.get_translations("Hello World!", 10 ) }.must_raise MsTranslate::Api::HTTPMethodNotAllowed
    end
  
    it 'Get am array of alternative translations of the passed array of text' do
      lambda { MsTranslate::Api.get_translations_array(['Hello','world!'], 10) }.must_raise MsTranslate::Api::HTTPMethodNotAllowed
    end
  
    it 'Get a string with a URL to a wave stream of the passed in text in desired language. ' do
      MsTranslate::Api.speak('Hello World!', 'it').bytesize.must_equal 14006
      MsTranslate::Api.speak('Hello World!', 'it').size.must_equal 14006
    end
  
    it 'Translates an array of texts into another language.' do
      lambda{ MsTranslate::Api.translate_array(['Hello','World!']) }.must_raise MsTranslate::Api::HTTPMethodNotAllowed
    end
  
    it 'Get an array of sentence lengths for each sentence of the given text' do
      MsTranslate::Api.break_sentences('Hello World!', 'en').must_equal '12'
      MsTranslate::Api.break_sentences('Ciao Mondo! Visto che bella giornata?', 'it').must_equal ['12', '25']
    end
  end     
end
