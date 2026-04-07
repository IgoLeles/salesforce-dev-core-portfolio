public class AccountAddressVerificationHandler {

    public static void validatePostalCodes(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return;
        }

        for (Account acc : accounts) {
            if (acc == null) {
                continue;
            }

            if (String.isBlank(acc.BillingPostalCode)) {
                continue;
            }

            Boolean isValid = isValidPostalCode(acc.BillingPostalCode, acc.BillingCountry);

            if (!isValid) {
                acc.BillingPostalCode.addError(
                    'Invalid Billing Postal Code. Only valid Brazilian or Romanian postal codes are allowed.'
                );
            }
        }
    }

public static Boolean isValidPostalCode(String postalCode, String country) {

    if (String.isBlank(postalCode)) {
        return true;
    }

    String trimmedPostalCode = postalCode.trim();

    Boolean isBrazilValid = Pattern.matches('^\\d{5}-?\\d{3}$', trimmedPostalCode);
    Boolean isRomaniaValid = Pattern.matches('^\\d{6}$', trimmedPostalCode);

    if (String.isBlank(country)) {
        return isBrazilValid || isRomaniaValid;
    }

    String c = country.trim().toLowerCase();

    if (c == 'brazil' || c == 'brasil' || c == 'br') {
        return isBrazilValid;
    }

    if (c == 'romania' || c == 'romênia' || c == 'romenia' || c == 'ro') {
        return isRomaniaValid;
    }

    return false;
}
}