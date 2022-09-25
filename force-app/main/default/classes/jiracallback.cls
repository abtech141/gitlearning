@RestResource(urlMapping='/api/jira-Callback/*')
global without sharing class jiracallback {
    @HttpPost
    global static void syncjira() {
        RestRequest req = RestContext.request;
        //Map<string,String> params = RestContext.request.params;
        string reqbody = req.requestBody.toString();
        Map<String, object> valuesMap = (Map<String, object>)JSON.deserializeUntyped(reqbody);
        //for(string str:params.keyset()){
        // system.debug(str+'--'+params.get(str));
        //}
        for(string str:valuesMap.keyset()){
            system.debug(str+'--'+valuesMap.get(str));
        }
        Object strchange = valuesMap.get('changelog');
        Object issuedet = valuesMap.get('issue');
        system.debug('strchange');
        system.debug(strchange);
        Map<String, object> issuemap = (Map<String, object>)JSON.deserializeUntyped(JSON.serialize(issuedet).replace('from','x_from'));
        string issuekey = (string) issuemap.get('key');
        system.debug('issuekey--'+issuekey);
        updatestatus(issuekey);
        Object fieldsdet = issuemap.get('fields');
        system.debug('fieldsdet');
        system.debug(fieldsdet);
        Map<String, object> issuemap1 = (Map<String, object>)JSON.deserializeUntyped(JSON.serialize(fieldsdet));
        Object statusdet = issuemap1.get('status');
        Map<String, object> statusmap = (Map<String, object>)JSON.deserializeUntyped(JSON.serialize(statusdet));
        string statusname  = (string) statusmap.get('name');
        system.debug('statusname');
        system.debug(statusname);
        Case cs = [Select Id,Status,Jira_Id__c from Case Where Jira_Id__c =:issuekey];
        cs.Status = statusname;
        update cs;
    }
    
    public static void updatestatus(string jiraKey){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Jira/rest/api/3/issue/'+jiraKey+'?fields=status');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getStatusCode());
        System.debug(res.getBody());
        if(res.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Object fieldsdet = results.get('fields');
            system.debug('fieldsdet');
            system.debug(fieldsdet);
            Map<String, object> issuemap = (Map<String, object>)JSON.deserializeUntyped(JSON.serialize(fieldsdet));
            Object statusdet = issuemap.get('status');
            Map<String, object> statusmap = (Map<String, object>)JSON.deserializeUntyped(JSON.serialize(statusdet));
            string statusname  = (string) statusmap.get('name');
            system.debug('statusname');
            system.debug(statusname);
            Case cs = [Select Id,Status,Jira_Id__c from Case Where Jira_Id__c =:jiraKey];
            cs.Status = statusname;
            update cs;
        }
    }
}