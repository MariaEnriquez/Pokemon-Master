@isTest
public class BatchMultipleCalloutsTest {
    public static testmethod void testBatchPokemonAndMoveAndAbilityCallout() {
        SingleRequestMock fakePokemonResp = new SingleRequestMock(200,
                                                    'Complete',
                                                    '{ "abilities": [ { "ability": { "name": "overgrow", "url": "https://pokeapi.co/api/v2/ability/65/" }, "is_hidden": false, "slot": 1 }, { "ability": { "name": "chlorophyll", "url": "https://pokeapi.co/api/v2/ability/34/" }, "is_hidden": true, "slot": 3 } ], "height": 7, "id": 1, "moves": [ { "move": { "name": "razor-wind", "url": "https://pokeapi.co/api/v2/move/13/" } }, { "move": { "name": "swords-dance", "url": "https://pokeapi.co/api/v2/move/14/" } }, { "move": { "name": "cut", "url": "https://pokeapi.co/api/v2/move/15/" } }, { "move": { "name": "bind", "url": "https://pokeapi.co/api/v2/move/20/" } }, { "move": { "name": "vine-whip", "url": "https://pokeapi.co/api/v2/move/22/" } } ], "name": "bulbasaur", "order": 1, "stats": [ { "base_stat": 45, "effort": 0, "stat": { "name": "hp", "url": "https://pokeapi.co/api/v2/stat/1/" } }, { "base_stat": 49, "effort": 0, "stat": { "name": "attack", "url": "https://pokeapi.co/api/v2/stat/2/" } }, { "base_stat": 49, "effort": 0, "stat": { "name": "defense", "url": "https://pokeapi.co/api/v2/stat/3/" } }, { "base_stat": 45, "effort": 0, "stat": { "name": "speed", "url": "https://pokeapi.co/api/v2/stat/6/" } } ], "types": [ { "slot": 1, "type": { "name": "grass", "url": "https://pokeapi.co/api/v2/type/12/" } }, { "slot": 2, "type": { "name": "poison", "url": "https://pokeapi.co/api/v2/type/4/" } } ], "weight": 69 }',
                                                    null);

        SingleRequestMock fakeMoveResp = new SingleRequestMock(200,
                                                    'Complete',
                                                    '{"accuracy": 100,"effect_chance": null,"effect_changes": [],"effect_entries": [{"effect": "Inflicts regular damage.","short_effect": "Inflicts regular damage with no additional effect."}],"id": 1,"name": "pound","power": 40,"pp": 35,"priority": 0,"target": {"name": "selected-pokemon","url": "https://pokeapi.co/api/v2/move-target/10/"},"type": {"name": "normal","url": "https://pokeapi.co/api/v2/type/1/"}}',
                                                    null);

        SingleRequestMock fakeAbilityResp = new SingleRequestMock(200,
                                                   'Complete',
                                                   '{"effect_entries": [{"effect": "Attacken die Schaden verursachen haben mit jedem Treffer eine 10% Chance das Ziel zur??ckschrecken zu lassen, wenn die Attacke dies nicht bereits als Nebeneffekt hat. Der Effekt stapelt nicht mit dem von getragenen Items.Au??erhalb vom Kampf: Wenn ein Pok??mon mit dieser F??higkeit an erster Stelle im Team steht, tauchen wilde Pok??mon nur halb so oft auf.","language": {"name": "de","url": "https://pokeapi.co/api/v2/language/6/"},"short_effect": "Mit jedem Treffer besteht eine 10% Chance das Ziel zur??ckschrecken zu lassen."},{"effect": "This Pok??mons damaging moves have a 10% chance to make the target flinch with each hit if they do not already cause flinching as a secondary effect.This ability does not stack with a held item. Overworld: The wild encounter rate is halved while this Pok??mon is first in the party.","language": {"name": "en","url": "https://pokeapi.co/api/v2/language/9/"},"short_effect": "Has a 10% chance of making target Pok??mon flinch with each hit."}],"id": 1,"name": "stench"}',
                                                    null);

        Map<String, HttpCalloutMock> endpoint3TestResp =
                                   new Map<String,HttpCalloutMock>();
        endpoint3TestResp.put('https://pokeapi.co/api/v2/pokemon/1',fakePokemonResp);
        endpoint3TestResp.put('https://pokeapi.co/api/v2/move/1',fakeMoveResp);
        endpoint3TestResp.put('https://pokeapi.co/api/v2/ability/1',fakeAbilityResp);

        HttpCalloutMock multiCalloutMock =
            	                   new MultiRequestMock(endpoint3TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();
            Id batchMoveId = Database.executeBatch(new InsertMoveBatch(), 826);
            Id batchAbilityId = Database.executeBatch(new InsertAbilityBatch(), 267);
            Id batchPokemonId = Database.executeBatch(new InsertPokemonBatch(), 898);
        Test.stopTest();
        System.assert(true);
    }
}
