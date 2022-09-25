trigger feedItemTrigger on FeedItem (after insert) {
    feedItemTriggerHandler.afterInsert(trigger.new);
}