public with sharing class SchedaVerificaFilialeVisElencoPratCtrl {
    public static Map<String,String> labelApi;
    @AuraEnabled
    public static string inserisciElementiSelezionati(String listaElementi,String schedaFilialeId){
        System.debug('___SchedaVerificaFilialeVisElencoPratCtrl.inserisciElementiSelezionati___START');
        System.debug('listaelementi:'+listaElementi);
        List<Pratica_Scheda_Filiale__c> praticaToInsert = new List<Pratica_Scheda_Filiale__c>();
	    List<Map<String,String>> deserializedList = (List<Map<String,String>>)JSON.deserialize(listaElementi, List<Map<String,String>>.class);
        try{
            //mapping inverso, da label a nome api
            Schema.DescribeFieldResult fieldResult = Pratica_Scheda_Filiale__c.Tipologia__c.getDescribe();
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            labelApi = new Map<String,String>();
            for (Schema.PicklistEntry f : values)
                labelApi.put(f.getLabel(),f.getvalue());

            for(Map<String,String> elemento : deserializedList){
                Pratica_Scheda_Filiale__c pratica = generaPratica(elemento,schedaFilialeId);
                praticaToInsert.add(pratica);
            }
            insert praticaToInsert;
        } catch(Exception e){
            System.debug('___SchedaVerificaFilialeVisElencoPratCtrl.inserisciElementiSelezionati___ ---->EXCEPTION');
            System.debug(e.getMessage());
            return e.getMessage();
        }
        
        System.debug('___SchedaVerificaFilialeVisElencoPratCtrl.inserisciElementiSelezionati___DONE');
        return 'success';
    }

    @AuraEnabled
    public static Pratica_Scheda_Filiale__c generaPratica(Map<String,String> elemento,String schedaFilialeId){
        Pratica_Scheda_Filiale__c pratica = new Pratica_Scheda_Filiale__c();
        pratica.Canale__c = elemento.get('canale');
        pratica.Cod_Cliente__c = elemento.get('codCliente');
        pratica.Data_Liquidazione__c = elemento.get('dataLiquidazione') != null ? elemento.get('dataLiquidazione') : null;
        pratica.Finanziato__c = elemento.get('finanziato')!= null ? Decimal.valueOf(elemento.get('finanziato')) : null;
        pratica.Intermediario__c = elemento.get('intermediario');
        pratica.Numero_Pratica__c = elemento.get('numPratica');
        pratica.Procedura__c = elemento.get('procedura');
        pratica.Prodotto__c = elemento.get('prodotto');
        pratica.Scheda_Verifica_Filiale__c = schedaFilialeId;
        pratica.Tipo_Prodotto__c = elemento.get('tipoProdotto');
        pratica.Tipologia__c = labelApi!=null && labelApi.size()>0 ? labelApi.get(elemento.get('tipologia')):'';
        pratica.Ragione_Sociale__c = elemento.get('ragioneSociale');
        return pratica;
    }

    @AuraEnabled
    public static string restService(String request){
        System.debug('___SchedaVerificaFilialeVisElencoPratCtrl.restService___START');
        System.debug(request);
        Map<String,String> requestMap = (Map<String,String>) JSON.deserialize(request,Map<String,String>.class);
        
        
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :Userinfo.getUserId() ];
        Boolean enableAccess = false;
        //controllo per permission set
        for(PermissionSetAssignment permission:lstcurrentUserPerSet){
            if(permission.PermissionSet.Name == 'SchedaVerificaFiliale_Coordinatore'){
                enableAccess = true;
                break;
            }
        }
        //controllo per profilo
        if(!enableAccess){
            User utente = [select id,Profile.Name from user where id=:Userinfo.getUserId()];
            if(utente.Profile.Name == 'System Administrator' || utente.Profile.Name == 'Amministratore del sistema'){
                enableAccess = true;
            }
        }

        if(enableAccess == true){
            RecuperaPratichePerVisitaInvoker.RecuperaPratichePerVisitaResponse response = RecuperaPratichePerVisitaInvoker.invoke(requestMap);
            System.debug('response:'+response);
            System.debug('response:'+response.isOK());
            System.debug('response:'+response.getMessage());
            /*Boolean fake = false;
            if(fake){
            response.elencoPratiche = new List<RecuperaPratichePerVisitaInvoker.PraticaPerVisitaDTO>();
            for(Integer i=0; i<50; i++){
                RecuperaPratichePerVisitaInvoker.PraticaPerVisitaDTO pratica = new RecuperaPratichePerVisitaInvoker.PraticaPerVisitaDTO();

                pratica.numPratica = 'c'+i;
                pratica.tipologia = 'paAuto';
                pratica.tipoProdotto = 'pfMobili';
                pratica.prodotto = 'ppRete';
                pratica.codCliente = 'ppPoste';
                pratica.ragioneSociale = 'ppBanche';
                pratica.canale = 'ppAgeAss';
                pratica.finanziato = '0.1';
                pratica.procedura = 'ppAgeAss';
                pratica.canale = 'pfNoMobili';
                pratica.intermediario = 'pfNoMobili';
                response.elencoPratiche.add(pratica);
                }
            }*/
        
        


            if(response.isOK() && 'OK'.equalsIgnoreCase(response.getMessage())){
                System.debug('response.elencoPratiche:'+response.elencoPratiche);
                if(response.elencoPratiche != null &&  response.elencoPratiche.size()>0){
                    List<RecuperaPratichePerVisitaInvoker.PraticaPerVisitaDTO> pratiche = response.elencoPratiche;
                    System.debug('___SchedaVerificaFilialeVisElencoPratCtrl.restService___DONE');

                    //mapping descrizione tipologia pratica con il codice restituito
                    Schema.DescribeFieldResult fieldResult = Pratica_Scheda_Filiale__c.Tipologia__c.getDescribe();
                    List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
                    Map<String,String> apiLabel = new Map<String,String>();
                    for (Schema.PicklistEntry f : values)
                            apiLabel.put(f.getvalue(),f.getLabel());
                    for(RecuperaPratichePerVisitaInvoker.PraticaPerVisitaDTO pratica : pratiche){
                        pratica.tipologia = apiLabel.get(pratica.tipologia);
                    }
                    
                    return JSON.serialize(response.elencoPratiche);
                } else{
                    //nessuna pratica ricevuta
                    System.debug('___SchedaVerificaFilialeVisElencoPratCtrl.restService___DONE');
                    return 'Nessuna pratica trovata';
                }
            }else{
                //error
                System.debug('___SchedaVerificaFilialeVisElencoPratCtrl.restService___DONE');
                return 'errore servizio';
            }
        } else {
            return 'Utente non abilitato al servizio';
        }

    }

}