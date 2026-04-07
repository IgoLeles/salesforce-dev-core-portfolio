@isTest
private class OpportunityDiscountAssignerTest {

    @isTest
    static void testApplyDiscountOnInsert() {
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Name = 'Opp Prospecting',
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 1000
            ),
            new Opportunity(
                Name = 'Opp Qualification',
                StageName = 'Qualification',
                CloseDate = Date.today().addDays(30),
                Amount = 1000
            ),
            new Opportunity(
                Name = 'Opp Negotiation',
                StageName = 'Negotiation/Review',
                CloseDate = Date.today().addDays(30),
                Amount = 1000
            ),
            new Opportunity(
                Name = 'Opp Closed Won',
                StageName = 'Closed Won',
                CloseDate = Date.today().addDays(30),
                Amount = 1000
            )
        };

        Test.startTest();
        insert opps;
        Test.stopTest();

        List<Opportunity> insertedOpps = [
            SELECT Id, Name, StageName, Amount
            FROM Opportunity
            WHERE Id IN :opps
            ORDER BY Name
        ];

        Map<String, Opportunity> oppMap = new Map<String, Opportunity>();
        for (Opportunity opp : insertedOpps) {
            oppMap.put(opp.Name, opp);
        }

        System.assertEquals(950, oppMap.get('Opp Prospecting').Amount);
        System.assertEquals(900, oppMap.get('Opp Qualification').Amount);
        System.assertEquals(850, oppMap.get('Opp Negotiation').Amount);
        System.assertEquals(1000, oppMap.get('Opp Closed Won').Amount);
    }

    @isTest
    static void testApplyDiscountOnUpdate() {
        Opportunity opp = new Opportunity(
            Name = 'Opp Update Test',
            StageName = 'Closed Won',
            CloseDate = Date.today().addDays(30),
            Amount = 2000
        );

        insert opp;

        opp.StageName = 'Qualification';
        opp.Amount = 2000;

        Test.startTest();
        update opp;
        Test.stopTest();

        Opportunity updatedOpp = [
            SELECT Id, StageName, Amount
            FROM Opportunity
            WHERE Id = :opp.Id
        ];

        System.assertEquals('Qualification', updatedOpp.StageName);
        System.assertEquals(1800, updatedOpp.Amount);
    }

    @isTest
    static void testNullAmountDoesNotFail() {
        Opportunity opp = new Opportunity(
            Name = 'Opp Null Amount',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );

        Test.startTest();
        insert opp;
        Test.stopTest();

        Opportunity insertedOpp = [
            SELECT Id, Amount
            FROM Opportunity
            WHERE Id = :opp.Id
        ];

        System.assertEquals(null, insertedOpp.Amount);
    }
}