@isTest
private class LeadManagerTest {

    @isTest
    static void testQualifyAndConvertLeads() {
        List<Lead> leads = new List<Lead>{
            new Lead(
                LastName = 'Qualified One',
                Company = 'Acme A',
                Status = 'Open - Not Contacted',
                AnnualRevenue = 150000
            ),
            new Lead(
                LastName = 'Not Qualified Status',
                Company = 'Acme B',
                Status = 'Working - Contacted',
                AnnualRevenue = 200000
            ),
            new Lead(
                LastName = 'Not Qualified Revenue',
                Company = 'Acme C',
                Status = 'Open - Not Contacted',
                AnnualRevenue = 50000
            )
        };

        insert leads;

        Test.startTest();
        LeadManager.qualifyAndConvertLeads(leads);
        Test.stopTest();

        List<Lead> updatedLeads = [
            SELECT Id, IsConverted
            FROM Lead
            WHERE Id IN :leads
            ORDER BY CreatedDate
        ];

        System.assertEquals(true, updatedLeads[0].IsConverted);
        System.assertEquals(false, updatedLeads[1].IsConverted);
        System.assertEquals(false, updatedLeads[2].IsConverted);

        List<Contact> contacts = [
            SELECT Id, LastName
            FROM Contact
            WHERE LastName = 'Qualified One'
        ];
        System.assertEquals(1, contacts.size());

        List<Opportunity> opps = [
            SELECT Id, Name
            FROM Opportunity
            WHERE Name = 'Acme A'
        ];
        System.assertEquals(1, opps.size());
    }

    @isTest
    static void testNullAndEmptyInput() {
        Test.startTest();
        LeadManager.qualifyAndConvertLeads(null);
        LeadManager.qualifyAndConvertLeads(new List<Lead>());
        Test.stopTest();

        System.assert(true);
    }
}