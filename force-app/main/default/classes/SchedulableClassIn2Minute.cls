global class SchedulableClassIn2Minute implements Schedulable {
    global void execute(SchedulableContext ctx) {
        UpdateAndInsertAccountInEvery2Minutes scheduleJob = new UpdateAndInsertAccountInEvery2Minutes();
        // String cronExp = '0 2 * * * ?';
        // System.schedule('Execute in every 2 minutes', cronExp, scheduleJob);
        Database.executeBatch(scheduleJob, 200);
       // System.abortJob(ctx.getTriggerId());
    }
}