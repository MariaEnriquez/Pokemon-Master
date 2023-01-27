@isTest
public with sharing class PokemonListControllerTest {
    @TestSetup
    static void setup(){
        insert new Pokemon__c[]{
            new Pokemon__c(Name = 'pokemon1', ExtId__c = 1, Types__c = 'Normal'), 
            new Pokemon__c(Name = 'pokemon2', ExtId__c = 152, Types__c = 'Normal'), 
            new Pokemon__c(Name = 'pokemon3', ExtId__c = 153, Types__c = 'Fire; Rock')
        };
    }    

    @isTest public static void testGetPokemons() {                     
        List<Pokemon__c> pokemons = PokemonListController.getPokemons();
        System.assertEquals(3, pokemons.size());
    }

    @isTest public static void testGetPokemonsByGeneration() {                     
        List<Pokemon__c> pokemons = PokemonListController.getPokemonsByFilter(
            'Generation__c = 2'
            );
        System.assertEquals(2, pokemons.size());
        
        pokemons = PokemonListController.getPokemonsByFilter('Generation__c = 3');
        System.assertEquals(0, pokemons.size());
    }

    @isTest public static void testGetPokemonsByType() {                     
        List<Pokemon__c> pokemons = PokemonListController.getPokemonsByFilter(
            'Types__c includes (\'Normal\')'
            );
        System.assertEquals(2, pokemons.size());  

        pokemons = PokemonListController.getPokemonsByFilter(
            'Types__c includes (\'Normal;Fire\')'
            );
        System.assertEquals(0, pokemons.size());
    }

    @isTest public static void testGetPokemonsByName() {                     
        List<Pokemon__c> pokemons = PokemonListController.getPokemonsByFilter(
            'Name LIKE \'%pokemon%\''
            );
        System.assertEquals(3, pokemons.size());

        pokemons = PokemonListController.getPokemonsByFilter('Name LIKE \'%pokemon4%\'');
        System.assertEquals(0, pokemons.size());
    }

    @isTest public static void testGetPokemonsByGenerationAndType() {                     
        List<Pokemon__c> pokemons = PokemonListController.getPokemonsByFilter(
            'Generation__c = 2 AND Types__c includes (\'Normal\')'
            );
        System.assertEquals(1, pokemons.size());

        pokemons = PokemonListController.getPokemonsByFilter(
            'Generation__c = 3 AND Types__c includes (\'Normal\')'
            );
        System.assertEquals(0, pokemons.size());
    }

    @isTest public static void testGetPokemonsByGenerationAndName() {                     
        List<Pokemon__c> pokemons = PokemonListController.getPokemonsByFilter(
            'Generation__c = 2 AND Name LIKE \'%on2%\''
            );
        System.assertEquals(1, pokemons.size());

        pokemons = PokemonListController.getPokemonsByFilter(
            'Generation__c = 2 AND Name LIKE \'%on4%\''
            );
        System.assertEquals(0, pokemons.size());
    }

    @isTest public static void testGetPokemonsByTypeAndName() {                     
        List<Pokemon__c> pokemons = PokemonListController.getPokemonsByFilter(
            'Types__c includes (\'Normal\') AND Name LIKE \'%pokemon2%\''
            );
        System.assertEquals(1, pokemons.size());

        pokemons = PokemonListController.getPokemonsByFilter(
            'Types__c includes (\'Normal\') AND Name LIKE \'%pokemon3%\''
            );
        System.assertEquals(0, pokemons.size());
    }

    @isTest public static void testGetPokemonsByGenerationAndTypeAndName() {                     
        List<Pokemon__c> pokemons = PokemonListController.getPokemonsByFilter(
            'Generation__c = 2 AND Types__c includes (\'Normal\') AND Name LIKE \'%pokemon2%\''
            );
        System.assertEquals(1, pokemons.size());

        pokemons = PokemonListController.getPokemonsByFilter(
            'Generation__c = 2 AND Types__c includes (\'Normal\') AND Name LIKE \'%pokemon3%\''
            );
        System.assertEquals(0, pokemons.size());
    }
}