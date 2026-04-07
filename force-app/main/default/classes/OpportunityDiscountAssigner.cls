public class OpportunityDiscountAssigner {

    public static void applyDiscount(List<Opportunity> opportunities) {
        if (opportunities == null || opportunities.isEmpty()) {
            return;
        }

        for (Opportunity opp : opportunities) {
            if (opp == null || opp.Amount == null || String.isBlank(opp.StageName)) {
                continue;
            }

            Decimal discountPercent = 0;

            if (opp.StageName == 'Prospecting') {
                discountPercent = 0.05;
            } else if (opp.StageName == 'Qualification') {
                discountPercent = 0.10;
            } else if (opp.StageName == 'Negotiation/Review') {
                discountPercent = 0.15;
            }

            if (discountPercent > 0) {
                opp.Amount = opp.Amount - (opp.Amount * discountPercent);
            }
        }
    }
}