public class SFCC_ProductAdd_API {
    @future(callout=true)
    public static void addProduct_in_SFCC(Set<Id> prodId){
        
        // Steps to get the Client Access Token
        String access_token;
        Http http1 = new Http();
        HttpRequest request1 = new HttpRequest();
        request1.setEndpoint('https://account.demandware.com/dwsso/oauth2/access_token');
        request1.setMethod('POST');

        String username = 'd9a8adca-4290-47f3-8e9b-74eecd8d1e18';
		String password = 'S485WLifw6!!!!!';
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader1 = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        String payload = 'grant_type=client_credentials';
        request1.setHeader('Authorization', authorizationHeader1);
        request1.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request1.setBody(payload);
        HttpResponse response1 = http1.send(request1);
        Map<String, Object> res = (Map<String, Object>)JSON.deserializeUntyped(response1.getBody());
        access_token = res.get('access_token').toString();
        
        // Steps to Add the Product in SFCC
        String host_server = 'dev08-na-conair.demandware.net';
        String api_version = 'v20_4';
        String catalogId = 'US-WaringCatalog';
       
        for(Product2 p: [Select Id, Name from Product2 where Id In :prodId]){
            Http http2 = new Http();
            HttpRequest request2 = new HttpRequest();
            request2.setEndpoint('https://'+host_server+'/s/Sites-Site/dw/data/'+api_version+'/products/'+p.Id);
            request2.setMethod('PUT');
            String authorizationHeader2 = 'Bearer ' + access_token;
            request2.setHeader('Authorization', authorizationHeader2);
            request2.setHeader('Content-Type', 'application/json');
            String body = '{"owning_catalog_id" : "'+catalogId+'", "id" : "'+p.Id+'","name" : "'+p.Name+'"}';
            request2.setBody(body);
            
            HttpResponse response2 = http2.send(request2);
        }
    }
    public static void addProduct_To_SFCC(List<Product2> prod){ // Method call by Product trigger after product insert
        Set<Id> prodId = new Set<Id>();
        for(Product2 p: prod){
            prodId.add(p.Id);
        }
        addProduct_in_SFCC(prodId);  // Calling Callout Method
    }    
}
