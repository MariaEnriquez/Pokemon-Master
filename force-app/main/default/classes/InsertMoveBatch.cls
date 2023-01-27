global class InsertMoveBatch implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    public Integer recordsProcessed = 0;

    global List<Integer> start(Database.BatchableContext BC) {
        List<Integer> listIds = new List<Integer>();
        for (Integer i = 1; i <= 826; i++) {
            listIds.add(i);
        }
        return listIds;
    }
    
    global void execute(Database.BatchableContext BC, List<Integer> listIds) {
        try {
            Move__c move = ProcessPokemonMoveAbility.getMove(listIds[0]);
            insert move;
            recordsProcessed++;
        } catch(Exception e) {
            System.debug(e);
        }
    } 
     
    global void finish(Database.BatchableContext BC) {
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        
        EmailUtils.sendMessage('Insert Move' + job.Status, 'Records processed: ' + recordsProcessed);
    }
}