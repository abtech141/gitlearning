trigger caseTrigger on Case (after insert) {
    List<Id> csIds = new List<Id>();
    for(Case cs :trigger.new){
        csIds.add(cs.Id);
    }
    caseTriggerHandler.afterInsert(csIds);
}