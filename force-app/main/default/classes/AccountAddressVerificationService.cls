public class AccountAddressVerificationService {

    public static void validateAccounts(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return;
        }

        for (Account acc : accounts) {
            if (acc == null) {
                continue;
            }

            String country = acc.BillingCountry;
            String postalCode = acc.BillingPostalCode;

            if (!isValidPostalCode(country, postalCode)) {
                acc.BillingPostalCode.addError(
                    'Invalid Billing Postal Code. Only valid Brazilian and Romanian postal codes are accepted.'
                );
            }
        }
    }

    public static Boolean isValidPostalCode(String country, String postalCode) {
        if (String.isBlank(country) || String.isBlank(postalCode)) {
            return false;
        }

        String normalizedCountry = country.trim().toLowerCase();
        String normalizedPostalCode = postalCode.trim();

        // Brazil / Brasil: 12345-678
        if (normalizedCountry == 'brazil' || normalizedCountry == 'brasil') {
            return Pattern.matches('^\\d{5}-\\d{3}$', normalizedPostalCode);
        }

        // Romania / Romênia / Romenia: 123456
        if (
            normalizedCountry == 'romania' ||
            normalizedCountry == 'romênia' ||
            normalizedCountry == 'romenia'
        ) {
            return Pattern.matches('^\\d{6}$', normalizedPostalCode);
        }

        return false;
    }
}