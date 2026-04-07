global class ArchiveOldContactsBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
    DateTime sixMonthsAgo = System.now().addMonths(-6);

    return Database.getQueryLocator([
    SELECT Id, Email, CreatedDate, Is_Archived__c
    FROM Contact
    WHERE CreatedDate < :sixMonthsAgo
    AND (Email = null OR Email = '')
    AND Is_Archived__c = false
    ]);
    }

    global void execute(Database.BatchableContext bc, List<Contact> scope) {
        for (Contact con : scope) {
            con.Is_Archived__c = true;
        }

        if (!scope.isEmpty()) {
            update scope;
        }
    }

    global void finish(Database.BatchableContext bc) {
    }
}