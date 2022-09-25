public class feedItemTriggerHandler {
    public static void afterInsert(List<FeedItem> lstfeeditem){
        for(FeedItem feeditm:lstfeeditem){
            string recid = feeditm.ParentId;
            if(feeditm.Type == 'TextPost' && recid.Startswith('500') ){
                caseCommentTriggerHandler.addJiraComment(recid,feeditm.Body);
            }
            // addJiraComment(cm.Id);
        }
        
    }
}