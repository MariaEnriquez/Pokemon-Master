public with sharing class ProcessPokemonMoveAbility {
    public static HttpResponse getHttpResponse(String url) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }

    public static Move__c getMove(Integer i){
        String url = 'https://pokeapi.co/api/v2/move/'+i;
        HttpResponse response = getHttpResponse(url);
        
        if(response.getStatusCode() == 200){
            Map<String,Object> data_object = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Move__c data = new Move__c();

            data.Accuracy__c = (Integer) data_object.get('accuracy');
            data.Effect_chance__c = (Integer) data_object.get('effect_chance');
            List<Object> effect_entries = (List<Object>) data_object.get('effect_entries');
            String Effect_entries_c = '';
            for (Object effect : effect_entries) {
                String short_effect = (String) ((Map<String,Object>)effect).get('short_effect');
                if(short_effect == ''){
                    Effect_entries_c = (String) ((Map<String,Object>)effect).get('effect');
                }
                else{
                    Effect_entries_c = short_effect;
                }
            }
            data.Effect_entries__c = Effect_entries_c;
            data.ExtId__c = (Integer) data_object.get('id');
            String name = (String) data_object.get('name');
            data.Name = name.substring(0,1).toUpperCase() + name.substring(1);
            data.Power__c = (Integer) data_object.get('power');
            data.Pp__c = (Integer) data_object.get('pp');
            data.Priority__c = (Integer) data_object.get('priority');
            Map<String,Object> mapTarget = (Map<String,Object>) data_object.get('target');
            String Target_c = (String) mapTarget.get('name');
            data.Target__c = Target_c;
            Map<String,Object> mapType = (Map<String,Object>) data_object.get('type');
            String Type_c = (String) mapType.get('name');
            data.Type__c = Type_c;
            
            return data;
        }
        else {
            return null;
        }
    }

    public static Ability__c getAbility(Integer i){
        String url = 'https://pokeapi.co/api/v2/ability/'+i;
        HttpResponse response = getHttpResponse(url);

        if(response.getStatusCode() == 200){
            Map<String,Object> data_object = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Ability__c data = new Ability__c();

            List<Object> effect_entries = (List<Object>) data_object.get('effect_entries');
            String Effect_entries_c = '';
            for (Object items_effect : effect_entries) {
                Map<String,Object> language = (Map<String,Object>) ((Map<String,Object>)items_effect).get('language');
                String data_language = (String) language.get('name');
                if (data_language == 'en') {
                    String short_effect = (String) ((Map<String,Object>)items_effect).get('short_effect');
                    if(short_effect == ''){
                        Effect_entries_c = (String) ((Map<String,Object>)items_effect).get('effect');
                    }
                    else{
                        Effect_entries_c = short_effect;
                    }
                }
            }
            data.Effect_entries__c = Effect_entries_c;
            data.ExtId__c = (Integer) data_object.get('id');
            String name = (String) data_object.get('name');
            data.Name = name.substring(0,1).toUpperCase() + name.substring(1);
            
            return data;
        }
        else {
            return null;
        }
    }

    public static Pokemon__c getPokemon(Integer i){
        String url = 'https://pokeapi.co/api/v2/pokemon/'+i;
        HttpResponse response = getHttpResponse(url);

        if(response.getStatusCode() == 200){
            Map<String,Object> data_object = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Pokemon__c data = new Pokemon__c();

            List<Object> listAbilities = (List<Object>) data_object.get('abilities');
            if (listAbilities.size() > 0) {
                Integer randomNumber = Integer.valueof((Math.random() * listAbilities.size()));
                Map<String,Object> mapAbility = (Map<String,Object>) ((Map<String,Object>)listAbilities[randomNumber]).get('ability');
                List<String> listUrl = ((String) mapAbility.get('url')).split('/');
                String ExtIdAbility = listUrl[listUrl.size()-1];
                
                Ability__c[] ability = [select ID from Ability__c where ExtId__c =: Decimal.valueOf(ExtIdAbility)];
                if(ability.size() > 0){
                    data.Ability__c = ability[0].Id;
                }
            }

            data.ExtId__c = (Integer) data_object.get('id');
            data.Height__c = String.valueOf(data_object.get('height')) + ' mts.';
            String name = (String) data_object.get('name');
            data.Name = name.substring(0,1).toUpperCase() + name.substring(1);

            Map<String,Object> mapSprites = (Map<String,Object>) data_object.get('sprites');
            if (mapSprites != null) {
                data.Picture__c = (String) mapSprites.get('front_default');
            }

            List<Object> listMoves = (List<Object>) data_object.get('moves');
            if(listMoves.size() >= 4){
                data.Slot1__c = getIdMove(listMoves[0]);
                data.Slot2__c = getIdMove(listMoves[1]);
                data.Slot3__c = getIdMove(listMoves[2]);
                data.Slot4__c = getIdMove(listMoves[3]);
            }
            if(listMoves.size() == 1){
                data.Slot1__c = getIdMove(listMoves[0]);
            }
            if(listMoves.size() == 2){
                data.Slot1__c = getIdMove(listMoves[0]);
                data.Slot2__c = getIdMove(listMoves[1]);
            }
            if(listMoves.size() == 3){
                data.Slot1__c = getIdMove(listMoves[0]);
                data.Slot2__c = getIdMove(listMoves[1]);
                data.Slot3__c = getIdMove(listMoves[2]);
            }

            List<Object> listStats = (List<Object>) data_object.get('stats');
            for (Object Stats : listStats) {
                Map<String,Object> stat = (Map<String,Object>) ((Map<String,Object>)Stats).get('stat');
                String stat_name = (String) stat.get('name');
                switch on stat_name {
                    when 'hp' {
                        data.Stats_hp__c = (Integer) ((Map<String,Object>)Stats).get('base_stat');
                    }
                    when 'attack' {
                        data.Stats_attack__c = (Integer) ((Map<String,Object>)Stats).get('base_stat');
                    }
                    when 'defense' {
                        data.Stats_defense__c = (Integer) ((Map<String,Object>)Stats).get('base_stat');
                    }
                    when 'speed' {
                        data.Stats_speed__c = (Integer) ((Map<String,Object>)Stats).get('base_stat');
                    }
                }
            }

            List<Object> listTypes = (List<Object>) data_object.get('types');
            String type_c = '';
            Integer cont = 0;
            for (Object types : listTypes) {
                cont++;
                Map<String,Object> type = (Map<String,Object>) ((Map<String,Object>)types).get('type');
                if(cont==listTypes.size()){
                    type_c += (String) type.get('name');
                }
                else{
                    type_c += (String) type.get('name') + ';';
                }
            }

            data.Types__c = type_c;
            data.Weight__c = String.valueOf(data_object.get('weight')) + ' kg.';
            
            return data;
        }
        else{
            return null;
        }
    }

    private static Id getIdMove(Object listMoves){
        Map<String,Object> mapMove = (Map<String,Object>) ((Map<String,Object>)listMoves).get('move');
        List<String> listUrl = ((String) mapMove.get('url')).split('/');
        String ExtIdMove = listUrl[listUrl.size()-1];
        Move__c[] move = [select ID from Move__c where ExtId__c =: Decimal.valueOf(ExtIdMove)];
        if (move.size() > 0) {
            return move[0].Id;
        }
        else {
            return null;
        }
    }
}