@isTest
private class AccountAddressVerificationHandlerTest {

    @isTest
    static void testValidBrazilPostalCodeWithDash() {
        Account acc = new Account(
            Name = 'Valid BR Dash',
            BillingCountry = 'Brazil',
            BillingPostalCode = '12345-678'
        );

        insert acc;

        System.assertNotEquals(null, acc.Id);
    }

    @isTest
    static void testValidBrazilPostalCodeWithoutDash() {
        Account acc = new Account(
            Name = 'Valid BR No Dash',
            BillingCountry = 'Brazil',
            BillingPostalCode = '12345678'
        );

        insert acc;

        System.assertNotEquals(null, acc.Id);
    }

    @isTest
    static void testValidRomaniaPostalCode() {
        Account acc = new Account(
            Name = 'Valid RO',
            BillingCountry = 'Romania',
            BillingPostalCode = '123456'
        );

        insert acc;

        System.assertNotEquals(null, acc.Id);
    }

    @isTest
    static void testInvalidBrazilPostalCode() {
        Account acc = new Account(
            Name = 'Invalid BR',
            BillingCountry = 'Brazil',
            BillingPostalCode = '1234'
        );

        try {
            insert acc;
            System.assert(false, 'Expected error for invalid BR postal code');
        } catch (DmlException e) {
                       System.assert(e.getMessage().contains('Invalid Billing Postal Code'));
        }
    }

    @isTest
    static void testInvalidRomaniaPostalCode() {
        Account acc = new Account(
            Name = 'Invalid RO',
            BillingCountry = 'Romania',
            BillingPostalCode = 'ABCDE'
        );

        try {
            insert acc;
            System.assert(false, 'Expected error for invalid RO postal code');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Invalid Billing Postal Code'));
        }
    }

    @isTest
    static void testNoCountryButValidFormat() {
        Account acc = new Account(
            Name = 'No Country Valid',
            BillingPostalCode = '123456'
        );

        insert acc;

        System.assertNotEquals(null, acc.Id);
    }

    @isTest
    static void testNoCountryInvalidFormat() {
        Account acc = new Account(
            Name = 'No Country Invalid',
            BillingPostalCode = 'ABC123'
        );

        try {
            insert acc;
            System.assert(false, 'Expected error for invalid postal code');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Invalid Billing Postal Code'));
        }
    }

    @isTest
    static void testNullPostalCode() {
        Account acc = new Account(
            Name = 'Null Postal',
            BillingCountry = 'Brazil'
        );

        insert acc;

        System.assertNotEquals(null, acc.Id);
    }

    @isTest
    static void testUpdateInvalidPostalCode() {
        Account acc = new Account(
            Name = 'Update Test',
            BillingCountry = 'Brazil',
            BillingPostalCode = '12345-678'
        );

        insert acc;

        acc.BillingPostalCode = 'INVALID';

        try {
            update acc;
            System.assert(false, 'Expected error on update');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Invalid Billing Postal Code'));
        }
    }
}