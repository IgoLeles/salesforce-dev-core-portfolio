@isTest
private class ArchiveOldContactsBatchTest {

    @isTest
    static void testBatchArchivesOldContactsWithoutEmail() {
        Contact oldNoEmail = new Contact(
            LastName = 'Old No Email',
            Is_Archived__c = false
        );

        Contact oldWithEmail = new Contact(
            LastName = 'Old With Email',
            Email = 'teste@email.com',
            Is_Archived__c = false
        );

        Contact recentNoEmail = new Contact(
            LastName = 'Recent No Email',
            Is_Archived__c = false
        );

        insert new List<Contact>{ oldNoEmail, oldWithEmail, recentNoEmail };

        Test.setCreatedDate(oldNoEmail.Id, Datetime.now().addMonths(-7));
        Test.setCreatedDate(oldWithEmail.Id, Datetime.now().addMonths(-7));
        Test.setCreatedDate(recentNoEmail.Id, Datetime.now().addDays(-10));

        Test.startTest();
        Database.executeBatch(new ArchiveOldContactsBatch(), 200);
        Test.stopTest();

        Map<Id, Contact> results = new Map<Id, Contact>([
            SELECT Id, Email, Is_Archived__c
            FROM Contact
            WHERE Id IN :new List<Id>{ oldNoEmail.Id, oldWithEmail.Id, recentNoEmail.Id }
        ]);

        System.assertEquals(true, results.get(oldNoEmail.Id).Is_Archived__c);
        System.assertEquals(false, results.get(oldWithEmail.Id).Is_Archived__c);
        System.assertEquals(false, results.get(recentNoEmail.Id).Is_Archived__c);
    }

    @isTest
    static void testSchedulerRunsBatch() {
        Test.startTest();
        String jobId = System.schedule(
            'Archive Old Contacts Weekly Job',
            '0 0 2 ? * SUN',
            new ArchiveOldContactsScheduler()
        );
        Test.stopTest();

        System.assertNotEquals(null, jobId);
    }
}