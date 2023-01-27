public class PokemonListController {
   
    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> getPokemons() {
        return [
            SELECT Name, Generation__c, Height__c, Picture__c, Types__c, Weight__c,
             Stats_attack__c, Stats_defense__c, Stats_hp__c, Stats_speed__c
            FROM Pokemon__c
            WITH SECURITY_ENFORCED
            ORDER BY ExtId__c
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> getPokemonsByFilter(String whereQuery) {
        String select_from_query='SELECT Name, Generation__c, Height__c, '
        +'Picture__c, Types__c, Weight__c, Stats_attack__c, Stats_defense__c, '
        +'Stats_hp__c, Stats_speed__c FROM Pokemon__c WHERE ';
        String order_query=' ORDER BY ExtId__c';
        
        whereQuery = select_from_query + whereQuery + order_query;
        return Database.query(whereQuery);
    }
}
