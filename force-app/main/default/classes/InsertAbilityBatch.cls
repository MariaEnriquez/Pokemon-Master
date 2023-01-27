global class InsertAbilityBatch implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts {
    public Integer recordsProcessed = 0;

    global List<Integer> start(Database.BatchableContext BC) {
        List<Integer> listIds = new List<Integer>();
        for (Integer i = 1; i <= 267; i++) {
            listIds.add(i);
        }
        return listIds;
    }
    
    global void execute(Database.BatchableContext BC, List<Integer> listIds) {
        try {
            Ability__c ability = ProcessPokemonMoveAbility.getAbility(listIds[0]);
            insert ability;
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
        // call some utility to send email
        EmailUtils.sendMessage('Insert Ability' + job.Status, 'Records processed: ' + recordsProcessed);
    }
}
