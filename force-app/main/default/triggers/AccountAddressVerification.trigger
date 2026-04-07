trigger AccountAddressVerification on Account (before insert, before update) {
    AccountAddressVerificationHandler.validatePostalCodes(Trigger.new);
}