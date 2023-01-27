import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import filterPokemonsMessageChannel from '@salesforce/messageChannel/FilterPokemonsMessageChannel__c';

export default class FiltersPokemonList extends LightningElement {
    value_type = null;
    show_value_type = [];
    value_generation = null;
    show_value_generation = null;
    value_name = null;
    show_value_name = null;
    error;
    
    @wire(MessageContext)
    messageContext

    get options_types () {
        return [
            {label:'All',value:'All'},
            {label:'Normal',value:'Normal'},
            {label:'Fighting',value:'Fighting'},
            {label:'Flying',value:'Flying'},
            {label:'Poison',value:'Poison'},
            {label:'Ground',value:'Ground'},
            {label:'Rock',value:'Rock'},
            {label:'Bug',value:'Bug'},
            {label:'Ghost',value:'Ghost'},
            {label:'Steel',value:'Steel'},
            {label:'Fire',value:'Fire'},
            {label:'Water',value:'Water'},
            {label:'Grass',value:'Grass'},
            {label:'Electric',value:'Electric'},
            {label:'Psychic',value:'Psychic'},
            {label:'Ice',value:'Ice'},
            {label:'Dragon',value:'Dragon'},
            {label:'Dark',value:'Dark'},
            {label:'Fairy',value:'Fairy'},
            {label:'Unknown',value:'Unknown'},
            {label:'Shadow',value:'Shadow'}
        ];
    }

    get options_generation() {
        var generations = [];
        generations.push({ label: 'All', value: 'All' });
        for (let i = 1; i <= 8; i++) {
            generations.push({ label: 'Generation '+i, value: i });
        }
        return generations;
    }
    
    handleChangeType(event) {
        if(event.detail.value == "All"){
            this.show_value_type = [];
            this.value_type = null;
        }
        else{
            this.show_value_type.push(event.detail.value);
            this.value_type = this.show_value_type.join(';');
        }
    }

    handleChangeGeneration(event) { 
        this.value_generation = event.detail.value;
        if(event.detail.value == "All"){
            this.show_value_generation = null;
        }
        else{
            this.show_value_generation = 'Generation ' + this.value_generation;
        }
    }

    handleChangeName(event){
        if(event.detail.value == ''){
            this.value_name = null;
            this.show_value_name = null;
        }
        else{
            this.value_name = event.detail.value;
            this.show_value_name = 'Search for: ' + this.value_name;
        }
    }

    handleClickSearch(){
        if(this.value_generation != null && this.value_generation != 'All' 
        && this.value_type != null && this.value_type != 'All' && this.value_name != null){
            const message = {
                filterKey: this.value_generation,
                filterKey2: this.value_type,
                filterKey3: this.value_name,
                queryType: "generation&type&name"
            };
            publish(this.messageContext, filterPokemonsMessageChannel, message);
        }
        else{
            if(this.value_generation != null && this.value_generation != 'All' 
            && this.value_type != null && this.value_type != 'All'){
                const message = {
                    filterKey: this.value_generation,
                    filterKey2: this.value_type,
                    queryType: "generation&type"
                };
                publish(this.messageContext, filterPokemonsMessageChannel, message);
            }
            else{
                if(this.value_generation != null && this.value_generation != 'All'
                && this.value_name != null){
                    const message = {
                        filterKey: this.value_generation,
                        filterKey2: this.value_name,
                        queryType: "generation&name"
                    };
                    publish(this.messageContext, filterPokemonsMessageChannel, message);
                }
                else{
                    if(this.value_generation != null && this.value_generation != 'All'){
                        const message = {
                            filterKey: this.value_generation,
                            queryType: "generation"
                        };
                        publish(this.messageContext, filterPokemonsMessageChannel, message);
                    }
                    else{
                        if(this.value_type != null && this.value_type != 'All'
                        && this.value_name != null){
                            const message = {
                                filterKey: this.value_type,
                                filterKey2: this.value_name,
                                queryType: "type&name"
                            };
                            publish(this.messageContext, filterPokemonsMessageChannel, message);
                        }
                        else{
                            if(this.value_type != null && this.value_type != 'All'){
                                const message = {
                                    filterKey: this.value_type,
                                    queryType: "type"
                                };
                                publish(this.messageContext, filterPokemonsMessageChannel, message);
                            }
                            else{
                                if(this.value_name != null){
                                    const message = {
                                        filterKey: this.value_name,
                                        queryType: "name"
                                    };
                                    publish(this.messageContext, filterPokemonsMessageChannel, message);
                                }
                                else{
                                    const message = {
                                        filterKey: 'all',
                                        queryType: "all"
                                    };
                                    publish(this.messageContext, filterPokemonsMessageChannel, message);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}