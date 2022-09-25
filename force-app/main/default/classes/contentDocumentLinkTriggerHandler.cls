public class contentDocumentLinkTriggerHandler {
    public static void afterInsert(List<ContentDocumentLink> lstcontLink){
        for(ContentDocumentLink cdlink:lstcontLink){
            string recid = cdlink.LinkedEntityId;
            if(recid.Startswith('500') ){
                AddJiraAttachment.fileUploadCallout(recid,cdlink.ContentDocumentId) ;
            }
        }
        
    }
}