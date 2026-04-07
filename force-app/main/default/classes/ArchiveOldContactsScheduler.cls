global class ArchiveOldContactsScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new ArchiveOldContactsBatch(), 200);
    }
}