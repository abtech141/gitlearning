public class DocusignUtility {
    
    private static Map<String, RESTDocusignSettings__mdt> settingsMap { 
        get {
            if (settingsMap == null) {
                settingsMap = new Map<String, RESTDocusignSettings__mdt>();
                for (RESTDocusignSettings__mdt setting : [Select DeveloperName,MasterLabel, Value__c from RESTDocusignSettings__mdt]) {
                    settingsMap.put(setting.MasterLabel, setting);
                } 
            }
            return settingsMap;
        }
        set {
        }
    }
    
    public static String getAccessToken() {
        String access_token = null;
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        String authendpoint = settingsMap.get('RequestAuthEndpoint').Value__c;
        req.setEndPoint(authendpoint);
        String authRequestContentType = settingsMap.get('RequestAuthContentType').Value__c;
        req.setHeader('Content-type', authRequestContentType);
        String authRequestDomain = settingsMap.get('RequestAuthDomain').Value__c;
        req.setHeader('Host', authRequestDomain);
        String alg = 'RS256';
        String iss = settingsMap.get('RequestIntegratorKey').Value__c;
        String pkey = settingsMap.get('RequestPrivateKey').Value__c;
        String scope = settingsMap.get('RequestScope').Value__c;
        DocusignJWT jwtObject = new DocusignJWT(alg, settingsMap.get('DSUserName').Value__c, iss, pkey, scope, authRequestDomain);
        String requestBody = settingsMap.get('RequestAuthBody').Value__c + jwtObject.issue();
        req.setBody(requestBody);
        HTTPResponse res;
        Http http = new Http();
        try{
            res = http.send(req);
            if (res.getStatusCode() == 200) {
                System.JSONParser parser = System.JSON.createParser(res.getBody());
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                        parser.nextToken();
                        access_token = parser.getText();
                        break;
                    }
                }
            }else {
                //DCP_cls_ExceptionHandler.logApexCalloutError('DCP_cls_ApiDocusignUtility','getAccessToken',0, res.getStatusCode()+':Access Token not Found');
            }        
        }catch(Exception e){
            //DCP_cls_ExceptionHandler.logApexCalloutError('DCP_cls_ApiDocusignUtility','getAccessToken',e.getLineNumber(), e.getStackTraceString());
            throw e;       
        }
        return access_token;
    }
    
      @future(callout=true)
    public static void createEnvelope() {
        //Get the access token
        String accessToken = getAccessToken();
        System.Debug(LoggingLevel.INFO, '***accessToken ' + accessToken);

        //Call envelope Creation service if a non-empty access token is returned
        if (!String.isEmpty(accessToken)) {
            //instantiate an Http instance  
            Http httpProtocol = new Http();

            //instantiate an HttpRequest instance  
            HttpRequest request = new HttpRequest();

            //Set the request parameters 
            // Request endpoint for createEnvelope call
            String endpoint = settingsMap.get('RequestEnvelopeEndpoint').Value__c + settingsMap.get('DSAccountID').Value__c + '/envelopes';
            System.Debug(LoggingLevel.INFO, '***endpoint ' + endpoint);
            request.setEndPoint(endpoint);

            //set the POST method
            request.setMethod('POST');

            //set Authentication Header
            request.setHeader('grant_type', 'Bearer');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            //set Accept Header
            request.setHeader('Accept', 'application/json');

            //set Content Type Header
            request.setHeader('Content-type', 'application/json');

            //create the request Body

            //create instance of the EnvelopeCreationRequest class
            DocusignUtility.EnvelopeCreationRequest requestObject = new DocusignUtility.EnvelopeCreationRequest();
            requestObject.status = settingsMap.get('RequestEnvelopeStatus').Value__c;
            requestObject.emailSubject = settingsMap.get('RequestEnvelopeSubject').Value__c;
            //requestObject.templateId = settingsMap.get('RequestEnvelopeTemplateID').Value__c;
            requestObject.templateId = 'be5d7ac4-5f6d-4f88-a7fe-61a613ea3ac8';
            requestObject.envelopeIdStamping = false;
            List<cls_textCustomField> lstfld = new List<cls_textCustomField>();
            cls_textCustomField namefld = new cls_textCustomField();
            namefld.name ='txtname';
            namefld.required = 'false';
            namefld.show = 'true' ;
            namefld.value = 'Ab sign 1';
            lstfld.add(namefld);
            cls_customFields flds =new cls_customFields();
            flds.textCustomFields = lstfld;
            requestObject.customFields = flds;
            List<cls_textTab> lsttxtab = new List<cls_textTab>();
            cls_textTab txtab = new cls_textTab();
            txtab.tabLabel = 'txtname' ;
            txtab.value  = 'ab signinged';
            lsttxtab.add(txtab);
            cls_tabs tsbpar = new cls_tabs();
            tsbpar.textTabs = lsttxtab;
            requestObject.tabs = tsbpar;
            System.Debug(LoggingLevel.INFO, '***requestObject() ' + requestObject);
            String jsonBody = json.serialize(requestObject);
            System.Debug(LoggingLevel.INFO, '***jsonBody() ' + jsonBody);
            //string jsb = '{"emailSubject":"Test Pre-fill Tabs","emailBlurb":"This is a test.","compositeTemplates":[{"serverTemplates":[{"sequence":"1","templateId":"be5d7ac4-5f6d-4f88-a7fe-61a613ea3ac8"}],"inlineTemplates":[{"sequence":"1","recipients":{"signers":[{"roleName":"CEO","recipientId":"1","name":"Abdul Basit","email":"viral.dhingra01@nagarro.com","clientUserId":"1234","tabs":{"textTabs":[{"tabLabel":"txtname","value":"TEST-123"}]}}]}}]}],"status":"sent"}';
            request.setBody(jsonBody);
            //request.setBody(jsb);

            //Make the request and capture the response
            HttpResponse response = httpProtocol.send(request);
            System.Debug(LoggingLevel.INFO, '***response.getBody() ' + response.getBody());
            System.debug(LoggingLevel.INFO, '***response.getStatus() ' + response.getStatus());
			
	    //Parse the response
            String responseStatus = response.getStatus();
            if (responseStatus.equals('Created')) {
                DocusignUtility.EnvelopeCreationResponse responseObject = new DocusignUtility.EnvelopeCreationResponse();
                responseObject = (DocusignUtility.EnvelopeCreationResponse)System.JSON.deserialize(response.getBody(), DocusignUtility.EnvelopeCreationResponse.class);
                System.Debug(LoggingLevel.INFO, '***responseObject ' + responseObject);
            }
        }
    }

          @future(callout=true)
    public static void sendDraftEnvelope() {
               //Get the access token
        String accessToken = getAccessToken();
        System.Debug(LoggingLevel.INFO, '***accessToken ' + accessToken);

        //Call envelope Creation service if a non-empty access token is returned
        if (!String.isEmpty(accessToken)) {
            //instantiate an Http instance  
            Http httpProtocol = new Http();

            //instantiate an HttpRequest instance  
            HttpRequest request = new HttpRequest();

            //Set the request parameters 
            // Request endpoint for createEnvelope call
            String endpoint = settingsMap.get('RequestEnvelopeEndpoint').Value__c + settingsMap.get('DSAccountID').Value__c + '/envelopes/ec8c0a82-0921-4f8b-a046-03f307df9d51';
            System.Debug(LoggingLevel.INFO, '***endpoint ' + endpoint);
            request.setEndPoint(endpoint);

            //set the POST method
            request.setMethod('PUT');

            //set Authentication Header
            request.setHeader('grant_type', 'Bearer');
            request.setHeader('Authorization', 'Bearer ' + accessToken);

            //set Accept Header
            request.setHeader('Accept', 'application/json');

            //set Content Type Header
            request.setHeader('Content-type', 'application/json');

            //create the request Body

            //create instance of the EnvelopeCreationRequest class
           
            string jsb = '{ "status": "sent","emailSubject": "Adding documents after first signer has signed outlook","recipients": {"signers": [{"roleName":"CEO","recipientId":"1","name":"Abdul Basit","email":"basit_abdul@outlook.com"}]}}';
            //request.setBody(jsonBody);
            request.setBody(jsb);

            //Make the request and capture the response
            HttpResponse response = httpProtocol.send(request);
            System.Debug(LoggingLevel.INFO, '***response.getBody() ' + response.getBody());
            System.debug(LoggingLevel.INFO, '***response.getStatus() ' + response.getStatus());
			
	    //Parse the response
            String responseStatus = response.getStatus();
            if (responseStatus.equals('Created')) {
                DocusignUtility.EnvelopeCreationResponse responseObject = new DocusignUtility.EnvelopeCreationResponse();
                responseObject = (DocusignUtility.EnvelopeCreationResponse)System.JSON.deserialize(response.getBody(), DocusignUtility.EnvelopeCreationResponse.class);
                System.Debug(LoggingLevel.INFO, '***responseObject ' + responseObject);
            }
        }
  
    }
    //wrapper class for Envelope Creation Request
    //This class can be further re-vamped to create complex Envelopes to be passed to the createEnvelope Service
    //For more information refer https://developers.docusign.com/esign-rest-api/reference/Envelopes/Envelopes/create
    public class EnvelopeCreationRequest {
        public String emailSubject { get; set; }
        public String status { get; set; }
        public String templateId { get; set; }
        public Boolean envelopeIdStamping { get; set; }
        public cls_customFields customFields { get; set; }
         public cls_tabs tabs { get; set; }
    }

    //wrapper class for Envelope Creation Response
    public class EnvelopeCreationResponse {
        public String envelopeId { get; set; }
        public String uri { get; set; }
        public String status { get; set; }
        public String statusDateTime { get; set; }

    }
    class cls_customFields {
		public cls_textCustomField[] textCustomFields;
	}
	class cls_textCustomField {
		public String name;	//salary
		public String required;	//false
		public String show;	//true
		public String value;	//123000
	}
    
   
	class cls_tabs {
		public cls_textTab[] textTabs;
	}
	class cls_textTab {
		public String tabLabel;	//text
		public String value;	//Jabberywocky!
	}
    
}