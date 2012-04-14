# require_relative '../../spec_helper'
# For Ruby < 1.9.3, use this instead of require_relative
require (File.expand_path('./../../../spec_helper', __FILE__))

describe MsTranslate::MicroOauth do
  describe "default attributes" do
    before do
      @client_secret_real =  ''
      @client_id_real = ''
      @appId_real = ''
    end
    it "must include httparty methods" do
      MsTranslate::MicroOauth.must_include HTTParty
    end   

    it "must have the base url set to MS Translator Oauth endpoint" do
      MsTranslate::MicroOauth.base_uri.must_equal "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
    end   

    it "must have the scope set to http://api.microsofttranslator.com" do
      MsTranslate::MicroOauth.scope.must_equal 'http://api.microsofttranslator.com'
    end   
    
    it "must have the grant_type set to client_credentials" do
      MsTranslate::MicroOauth.grant_type.must_equal 'client_credentials'
    end   

    it "must get/set client_id attribute" do
      MsTranslate::MicroOauth.client_id.must_be_nil
      MsTranslate::MicroOauth.client_id = @client_id_real
      MsTranslate::MicroOauth.client_id.must_equal  @client_id_real 
    end
    it "must get/set client_secret attribute" do
      MsTranslate::MicroOauth.client_secret.must_be_nil
      MsTranslate::MicroOauth.client_secret = @client_secret_real
      MsTranslate::MicroOauth.client_secret.must_equal  @client_secret_real
    end
    
  end

  describe "GET TOKEN" do
    before do
      VCR.insert_cassette __name__ , :record => :new_episodes
      @client_secret_real =  ''
      @client_id_real = ''
      MsTranslate::MicroOauth.client_secret = @client_secret_real                         
      MsTranslate::MicroOauth.client_id = @client_id_real                         
      # make HTTP request in before
    end
  
    after do
      # make HTTP request in after
      MsTranslate::MicroOauth.reset!
      VCR.eject_cassette
    end  
    it 'get token without client_secret' do       
      MsTranslate::MicroOauth.client_secret = nil
      lambda { MsTranslate::MicroOauth.get_token(:client_id =>  @client_id_real) }.must_raise MsTranslate::MicroOauth::InvalidClientSecret      
    end
    it 'get token without client_id' do       
      MsTranslate::MicroOauth.client_id = nil
      lambda { MsTranslate::MicroOauth.get_token(:client_secret => @client_secret_real) }.must_raise MsTranslate::MicroOauth::InvalidClientId      
    end
    it 'get token with client_id and client_secret' do       
      MsTranslate::MicroOauth.get_token(:client_id =>  @client_id_real,:client_secret => @client_secret_real).must_match /^Bearer\s{1}\w*/i
    end
  end     
end
