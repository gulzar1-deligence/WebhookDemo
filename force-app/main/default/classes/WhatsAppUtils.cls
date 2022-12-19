public class WhatsAppUtils {
    
    public static void sendTextMessage(String messageContent, String toPhone) {
        HttpRequest  httpReq = new HttpRequest();
        httpReq.setEndpoint('https://graph.facebook.com/v15.0/103614205939823/messages');
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Authorization', 'Bearer ' +System.Label.WHATSAPPACCESSTOKEN);
        // from json to apex conversion
        String messageBody = '{'+
            '    "messaging_product": "whatsapp",    '+
            '    "recipient_type": "individual",'+
            '    "to": "' +toPhone+ '",'+
            '    "type": "text",'+
            '    "text": {'+
            '        "preview_url": false,'+
            '        "body": "' +messageContent+ '"'+
            '    }'+
            '}';
        
        httpReq.setBody(messageBody);
        
        Http http = new Http();
        
        
        try{
             HttpResponse response = http.send(httpReq);
            if(response.getStatusCode() == 200) {
                //parse & create message record
                System.debug('Successful !');
                WhatsAppUtils responseFromWA = (WhatsAppUtils)json.deserialize(response.getBody(), WhatsAppUtils.class);
                
                WAMessage__c salesforceMessage = new WAMessage__c();
                salesforceMessage.MessageContent__c = messageContent;
                salesforceMessage.CustomerPhone__c = toPhone;
                salesforceMessage.MessageID__c = responseFromWA.messages.get(0).id;
                salesforceMessage.MessageType__c = 'text';
                
                upsert salesforceMessage MessageID__C; //upsert with external id
            }
        }catch(System.CalloutException ex){
            system.debug(' System.CalloutException Executed '+ex.getStackTraceString());
        }catch(System.Exception ex){
            system.debug(' System.Exception Executed '+ex.getStackTraceString());
        }
    }
    
    // from json to apex conversion
     public String messaging_product;	//whatsapp
	public contacts[] contacts;
	public messages[] messages;
	public class contacts {
		public String input;	//
		public String wa_id;	//
	}
	public class messages {
		public String id;	//wamid.HBgMOTE2MzkyMzAyMDkwFQIAERgSODVBRDAxNDIzRkJCNkRDMTc3AA==
	}
}