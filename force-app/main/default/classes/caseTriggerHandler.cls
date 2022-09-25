public class caseTriggerHandler {

    @future(callout=true)
    public static void afterInsert(List<ID> lstcsIds){
        List<Case> lstcs = [select Id,Subject, description,Jira_Id__c from Case where ID IN : lstcsIds];
        jiraCreateIssueReq reqcls = new jiraCreateIssueReq();
        //jiraCreateIssueReq.cls_fields fld = new jiraCreateIssueReq.cls_fields();
        reqcls.fields.summary = lstcs[0].Subject;
        reqcls.fields.description.type ='doc';
        reqcls.fields.description.version = 1;
        List<jiraCreateIssueReq.cls_desc_content> lstcon = new List<jiraCreateIssueReq.cls_desc_content>();
        jiraCreateIssueReq.cls_desc_content cont = new jiraCreateIssueReq.cls_desc_content();
        cont.type ='paragraph';
        //cont.text = lstcs[0].Description;
        List<jiraCreateIssueReq.cls_content> lstconmain = new List<jiraCreateIssueReq.cls_content>();
        jiraCreateIssueReq.cls_content maincon = new jiraCreateIssueReq.cls_content();
        maincon.type ='text';
        maincon.text = lstcs[0].Description;
        lstconmain.add(maincon);
        cont.content = lstconmain;
        lstcon.add(cont);
        reqcls.fields.description.content = lstcon;
        reqcls.fields.issuetype.name = 'Task';
        reqcls.fields.assignee.id = '557058:435139d4-b95c-48a7-9132-69b238e30edc';
        reqcls.fields.reporter.id = '557058:435139d4-b95c-48a7-9132-69b238e30edc';
        reqcls.fields.project.key ='SI';
        //reqcls.fields = fld;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Jira/rest/api/3/issue');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        string body = JSON.serialize(reqcls);
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getStatusCode());
        System.debug(res.getBody());
        if(res.getStatusCode() == 201){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            system.debug(results.get('key'));
            lstcs[0].Jira_Id__c = (string) results.get('key') ;
            update lstcs[0];

        }

        
    }
}