@isTest
private class DiscountCalculatorTest {

    @isTest
    static void testNullAmount() {
        System.assertEquals(
            null,
            DiscountCalculator.calculateDiscount(null, 'OSF5')
        );
    }

    @isTest
    static void testNoDiscount() {
        System.assertEquals(
            50,
            DiscountCalculator.calculateDiscount(50, null)
        );
    }

    @isTest
    static void test10Percent() {
        System.assertEquals(
            180,
            DiscountCalculator.calculateDiscount(200, null)
        );
    }

    @isTest
    static void test15Percent() {
        System.assertEquals(
            255,
            DiscountCalculator.calculateDiscount(300, null)
        );
    }

    @isTest
    static void test20Percent() {
        System.assertEquals(
            400,
            DiscountCalculator.calculateDiscount(500, null)
        );
    }

    @isTest
    static void testDiscountCodeOnly() {
        System.assertEquals(
            47.5,
            DiscountCalculator.calculateDiscount(50, 'OSF5')
        );
    }

    @isTest
    static void testTierPlusCode() {
        System.assertEquals(
            323,
            DiscountCalculator.calculateDiscount(400, 'OSF5')
        );
    }
}