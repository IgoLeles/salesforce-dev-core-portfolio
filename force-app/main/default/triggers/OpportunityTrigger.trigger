trigger OpportunityTrigger on Opportunity (before insert, before update) {
    OpportunityDiscountAssigner.applyDiscount(Trigger.new);
}