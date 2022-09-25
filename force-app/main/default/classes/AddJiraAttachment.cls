public class AddJiraAttachment {
    public String executeCallout(string recordId, string userId) {
        
        // Instantiate a new http object
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (POST) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://testapi.herokuapp.com');
        req.setHeader('Content-Type', HttpFormBuilder.GetContentType());
        req.setMethod('POST');
        
        // Generate form body
        String body = '';
        body += HttpFormBuilder.WriteBoundary();
        body += HttpFormBuilder.WriteBodyParameter('id', recordId);
        body += HttpFormBuilder.WriteBoundary();
        body += HttpFormBuilder.WriteBodyParameter('userId', userId);
        body += HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);
        
        Blob formBlob = EncodingUtil.base64Decode(body);
        
        req.setHeader('Content-Length', String.valueOf(formBlob.size()));
        req.setBodyAsBlob(formBlob);
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        return res.getBody();
    }
    
    @future(callout=true)
    public static void fileUploadCallout(string csid,string ContdocId) 
    {
        List<Case> cslist =[SELECT Id, Jira_Id__c FROM Case where Id =:csid];
        if(cslist.size() > 0 && cslist[0].Jira_Id__c != null){
        
        List<contentversion> cvList = new List<contentversion>();
        cvList = [select id, title, ContentDocumentId, FileExtension, versionData from contentversion where ContentDocumentId  = :ContdocId];
        System.debug('Callout Log 1:' + cvList);
        if(!cvList.isEmpty())     
        {
            //form fileName with cv ID
            string fileName = cvList[0].title;
            if(cvList[0].FileExtension!=null && cvList[0].FileExtension!='')
            {
                fileName = fileName + '.' + cvList[0].FileExtension;  
            }         
            System.debug('Callout Log 2:' + fileName);
            
            //callout ePOR service
            string contentType = EinsteinVision_HttpBodyPart.GetContentType();
            
            //  Compose the form
            string form64 = '';
            //******This was the boundary I was missing****
            form64 += EinsteinVision_HttpBodyPart.WriteBoundary();
            form64 += EinsteinVision_HttpBodyPart.WriteBlobBodyParameter('file', EncodingUtil.base64Encode(cvList[0].versionData), fileName);
            
            blob formBlob = EncodingUtil.base64Decode(form64);
            string contentLength = string.valueOf(formBlob.size());
            
            System.debug('Callout Log 3:' + formBlob.size());
            
            if(formBlob.size()>12000000)
            {
                //this a "public class CustomException extends Exception{}"
                //throw new CustomException('File size limit is 12 MBytes');
            }
            else
            {
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint('callout:Jira/rest/api/3/issue/SI-7/attachments');
                req.setBodyAsBlob(formBlob);
                req.setHeader('X-Atlassian-Token', 'no-check');
                //req.setHeader('vertid', verticalId);
                //req.setHeader('callback', callbackURL);
                //req.setHeader('Connection', 'keep-alive');
                req.setHeader('Content-Length', contentLength);
                req.setHeader('Content-Type', contentType);
                req.setTimeout(120000);
                Http http =new Http();
                HTTPResponse res = http.send(req);
                System.debug('Callout Log 4:' + res.getStatusCode());
                System.debug('Callout Log 5:' + String.valueof(res.getbody()));
                
                string responseStatusCode = String.valueof(res.getStatusCode()); 
                string responseBody = String.valueof(res.getbody()); 
                
            
        }
        }
    }
    }
}