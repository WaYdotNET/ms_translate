require "httparty"
module MsTranslate    
  class MicroOauth
     include HTTParty
     base_uri "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"

     SCOPE = 'http://api.microsofttranslator.com'  
     GRANDTYPE = 'client_credentials'      

     # Microsoft Translate works with Oauth
     # http://msdn.microsoft.com/en-us/library/hh454950.aspx
     class << self
       attr_accessor :client_id 
       attr_accessor :client_secret 
       attr_accessor :scope 
       attr_accessor :grant_type       
     
       MicroOauth.scope ||= SCOPE  
       MicroOauth.grant_type ||= GRANDTYPE  
     end

     class InvalidClientId < StandardError; end   
     class InvalidClientSecret < StandardError; end         

     ##
     # reset attributes to default value
     #
     def self.reset!
       @client_id = nil
       @client_secret = nil
     end

     ##
     # GetToken Method
     #
     # Breaks a piece of text into sentences and returns an array
     # containing the lengths in each sentence.
     #
     # @param [client_id] client_id
     #  The client_id to work with Microsoft Translator
     # 
     # @param [client_secret] client_secret
     #  The client_secret to work with Microsoft Translator
     #
     # @return [String]
     #  Bearer + Token String 
     #                   
     def self.get_token(credentials = {})     
      raise InvalidClientId if credentials[:client_id].nil?
      raise InvalidClientSecret if credentials[:client_secret].nil?     
      query = {
       :scope => MicroOauth.scope,       
       :grant_type => MicroOauth.grant_type,
       :client_id => credentials[:client_id],
       :client_secret => credentials[:client_secret]         
      }        
      response = post("/",:body => query)  

      case response.code

      when 200
        "Bearer #{response["access_token"]}"
      when 404
        raise ServiceNotFound
      when 405
        raise HTTPMethodNotAllowed
      when 500...600
        raise ServiceError, "ERROR GETTING Access_token #{response.code}"
      end            
    end   
  end
end  
