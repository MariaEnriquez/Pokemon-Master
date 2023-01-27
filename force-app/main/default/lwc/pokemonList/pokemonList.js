import { LightningElement, wire } from 'lwc';
import { subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import { NavigationMixin } from 'lightning/navigation';
import filterPokemonsMessageChannel from '@salesforce/messageChannel/FilterPokemonsMessageChannel__c';
import getPokemons from '@salesforce/apex/PokemonListController.getPokemons';
import getPokemonsByFilter from '@salesforce/apex/PokemonListController.getPokemonsByFilter';

export default class PokemonList extends NavigationMixin(LightningElement) {
    pokemons;
    loading = false;
    number_result = 0;
    error;

    @wire(MessageContext)
    messageContext

    connectedCallback(){
        if(!this.subscribe){
            this.subscription = subscribe(
                this.messageContext,
                filterPokemonsMessageChannel,
                (message) => this.handleFilterKeySubmit(message)
            );
        }

        this.loadRelatedPokemons();
    }

    disconnectedCallback(){
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleFilterKeySubmit(message){
        const filterKey = message.filterKey;
        const queryType = message.queryType;

        switch (queryType) {
            case "name":
                var filter = "Name LIKE '%" + filterKey + "%'";
                this.loadRelatedPokemonsByFilter(filter);
                break;

            case "generation":
                var filter = 'Generation__c = ' + filterKey;
                this.loadRelatedPokemonsByFilter(filter);
                break;

            case "type":
                var filter = "Types__c includes ('" + filterKey + "')";
                this.loadRelatedPokemonsByFilter(filter);
                break;

            case "generation&type":
                var filterKey2 = message.filterKey2;
                var filter = "Generation__c = " + filterKey +
                " AND Types__c includes ('" + filterKey2 + "')";
                this.loadRelatedPokemonsByFilter(filter);
                break;

            case "generation&name":
                var filterKey2 = message.filterKey2;
                var filter = "Generation__c = " + filterKey +
                " AND Name LIKE '%" + filterKey2 + "%'";
                this.loadRelatedPokemonsByFilter(filter);
                break;

            case "type&name":
                var filterKey2 = message.filterKey2;
                var filter = "Types__c includes ('" + filterKey + "')" +
                " AND Name LIKE '%" + filterKey2 + "%'";
                this.loadRelatedPokemonsByFilter(filter);
                break;

            case "generation&type&name":
                var filterKey2 = message.filterKey2;
                const filterKey3 = message.filterKey3;
                var filter = "Generation__c = " + filterKey + 
                " AND Types__c includes ('" + filterKey2 + "')" +
                " AND Name LIKE '%" + filterKey3 + "%'";
                this.loadRelatedPokemonsByFilter(filter);
                break;
        
            default:
                this.loadRelatedPokemons();
                break;
        }
    }

    loadRelatedPokemons(){
        this.loading = true;
        getPokemons()
        .then(result =>{
            this.pokemons = result;
            this.number_result = result.length;
            this.loading = false;
        })
        .catch(error =>{
            this.error = error;
            this.loading = false;
        });
    }

    loadRelatedPokemonsByFilter(filter){
        this.loading = true;
        getPokemonsByFilter({whereQuery: filter})
        .then(result =>{ console.log(result);
            this.pokemons = result;
            this.number_result = result.length;
            this.loading = false;
        })
        .catch(error =>{console.log(error);
            this.error = error;
            this.loading = false;
        });
    }

    navigateToViewPokemon(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.id,
                objectApiName: 'Pokemon__c',
                actionName: 'view'
            },
        });
    }
}