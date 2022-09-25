trigger contentDocumentLinkTrigger on ContentDocumentLink (after insert) {
contentDocumentLinkTriggerHandler.afterInsert(trigger.new);
}