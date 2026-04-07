public class LeadManager {

    public static void qualifyAndConvertLeads(List<Lead> leadsToQualify) {
        
        if (leadsToQualify == null || leadsToQualify.isEmpty()) {
            return;
        }

        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();

        // Get a valid converted status for Lead conversion
        LeadStatus convertedStatus = [
            SELECT MasterLabel
            FROM LeadStatus
            WHERE IsConverted = true
            LIMIT 1
        ];

        for (Lead ld : leadsToQualify) {
            // Skip null records or leads without Id
            if (ld == null || ld.Id == null) {
                continue;
            }

            // Business rule:
            // Only convert leads with:
            // Status = "Open - Not Contacted"
            // AnnualRevenue > 100000
            if (ld.Status == 'Open - Not Contacted' &&
                ld.AnnualRevenue != null &&
                ld.AnnualRevenue > 100000) {

                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(ld.Id);
                lc.setConvertedStatus(convertedStatus.MasterLabel);
                lc.setDoNotCreateOpportunity(false);

                leadConverts.add(lc);
            }
        }

        // Bulk conversion only for qualified leads
        if (!leadConverts.isEmpty()) {
            List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, false);

            // I haven't thrown exceptions to keep batch execution safe. We can even extend this block to log.
            for (Database.LeadConvertResult result : results) {
                if (!result.isSuccess()) {
                    for (Database.Error err : result.getErrors()) {
                        System.debug('Lead conversion error: ' + err.getMessage());
                    }
                }
            }
        }
    }
}