public class caseCommentTriggerHandler {
    public static void afterInsert(List<CaseComment> lstcscmt){
        for(CaseComment cm:lstcscmt){
            caseCommentTriggerHandler.addJiraComment(cm.ParentId,cm.CommentBody);
        }
        
    }
    
    @future(callout=true)
    public static void addJiraComment(Id csid,string commentText){
        List<Case> cslist =[SELECT Id, Jira_Id__c FROM Case where Id =:csid];
        if(cslist.size() > 0 && cslist[0].Jira_Id__c != null){
            JiraCommentReq jirareq = new JiraCommentReq();
            List<JiraCommentReq.cls_main_content> lstmaincon = new List<JiraCommentReq.cls_main_content>();
            JiraCommentReq.cls_main_content maincon = new JiraCommentReq.cls_main_content();
            List<JiraCommentReq.cls_content> lstcont = new List<JiraCommentReq.cls_content>();
            JiraCommentReq.cls_content cont = new JiraCommentReq.cls_content();
            maincon.text = commentText;
            lstmaincon.add(maincon);
            cont.content = lstmaincon;
            lstcont.add(cont);
            jirareq.body.content = lstcont;
            string body = JSON.serialize(jirareq);
            system.debug(body);
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Jira/rest/api/3/issue/'+cslist[0].Jira_Id__c+'/comment');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(body);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res.getStatusCode());
            System.debug(res.getBody());
            if(res.getStatusCode() == 201){
                system.debug('Comment added');
            }
        }
    }
}