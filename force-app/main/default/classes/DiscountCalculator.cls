public class DiscountCalculator {

    public static Decimal calculateDiscount(Decimal amount, String discountCode) {
        if (amount == null) {
            return null;
        }

        Decimal finalAmount = amount;

        if (amount >= 100 && amount <= 200) {
            finalAmount = amount * 0.9; // 10%
        } else if (amount > 200 && amount < 500) {
            finalAmount = amount * 0.85; // 15%
        } else if (amount >= 500) {
            finalAmount = amount * 0.8; // 20%
        }

        if (discountCode != null && discountCode == 'OSF5') {
            finalAmount = finalAmount * 0.95; // extra 5%
        }

        return finalAmount;
    }
}

//"Return the original amount if the amount is null."
//This is contradictory (there is no "original" if it's null, in my opinion).
