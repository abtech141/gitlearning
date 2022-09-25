trigger CaseCommentTrigger on CaseComment (after insert) {

    caseCommentTriggerHandler.afterInsert(trigger.new);
}