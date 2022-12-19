@restResource(urlMapping = '/api/Webhooks/pushdetailsdemo/*')
global with sharing class WebhookSubscriptionDemo {
	@HttpPost
    global static void handleNotification() {
        try{
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
            
        }catch(Exception e ){
            System.debug('Exception Happened: ' + e.getMessage());
        }
        
    }
}