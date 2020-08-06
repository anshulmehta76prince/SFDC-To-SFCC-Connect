public class SFCC_ProductAdd_API {
    public static List<Product2> products = new List<Product2>();
    public static String access_token;
    
    @future(callout=true)
    public static void getSFCC_ClientToken(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://account.demandware.com/dwsso/oauth2/access_token');
        request.setMethod('POST');

        String username = 'd9a8adca-4290-47f3-8e9b-74eecd8d1e18';
String password = 'S485WLifw6!!!!!';
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        //System.debug(authorizationHeader);
        String payload = 'grant_type=client_credentials';
        //System.debug(payload);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody(payload);
        
        HttpResponse response = http.send(request);
        System.debug(response);
        //System.debug(response.getBody());
        Map<String, Object> res = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        System.debug(res.get('access_token'));
        access_token = res.get('access_token').toString();    
    }
    @future(callout=true)
    public static void addProduct_in_SFCC(String token){
        String host_server = 'dev08-na-conair.demandware.net';
        String api_version = 'v20_4';
        String catalogId = 'US-WaringCatalog';
        
        for(Product2 p: products){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://'+host_server+'/s/Sites-Site/dw/data/'+api_version+'/products/'+p.Id);
            request.setMethod('PUT');
            String authorizationHeader = 'Bearer ' + token;
            //System.debug(authorizationHeader);
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('Content-Type', 'application/json');
            String body = '{"owning_catalog_id" : "'+catalogId+'", "id" : "'+p.Id+'","name" : "'+p.Name+'"}';
            request.setBody(body);
            
            HttpResponse response = http.send(request);
            System.debug(response);
            System.debug(response.getStatusCode());
        }
    }
    public static void addProduct_To_SFCC(List<Product2> prod){
        for(Product2 p: prod){
            products.add(p);
        }
        getSFCC_ClientToken();
        addProduct_in_SFCC(access_token);  
    }
}