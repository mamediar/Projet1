public class ConvenzionamentoParamFiller extends ParamFiller {
    
    Account acc;
    
    public ConvenzionamentoParamFiller( Account acc )
    { 
        this.acc = acc;
    }
    
    public override List<Parametro> getParams(){
        
        List<Parametro> paramsList =new List<Parametro>();
        
        //citta residenza convenzionato:
        Parametro param1=new Parametro();
        param1.valore=acc.ShippingCity;
        param1.variabile='$citta_conv';
        paramsList.add(param1);

        //Data Convenzionamento:
        DateTime now = DateTime.now();
        String dataAttuale = DateUtils.formatDateDDslashMMslashYYYY(now);
        Parametro param2=new Parametro();
        param2.valore=dataAttuale;
        param2.variabile='$data_conv';
        paramsList.add(param2);
                                    
        //codice OCS Convenzionato:
        Parametro param3=new Parametro();
        String paramOcsExt = (acc.OCS_External_Id__c!=null && acc.OCS_External_Id__c.length()>0) ? acc.OCS_External_Id__c.Substring(1) : '';
        param3.valore=paramOcsExt;
        param3.variabile='$cod_ocs_conv';
        paramsList.add(param3);
        
        //Ragione sociale Convenzionato:
        Parametro param4=new Parametro();
        param4.valore=acc.Name;
        param4.variabile='$nome_conv';
        paramsList.add(param4);
        
        //Indirizzo Convenzionato:
        Parametro param5=new Parametro();
        param5.valore=acc.ShippingStreet + ' - ' + acc.ShippingPostalCode + ' - ' + acc.ShippingCity + ' - ' + acc.ShippingState;
        param5.variabile='$ind_conv';
        paramsList.add(param5);

        String nomeAbbreviato = '';

        if (acc.CodiceAgente__c != null) {
            List<SFA_Convenzionam_CanaleAgenti__mdt> lstCanaleAgenti = 
                [SELECT Id, DeveloperName, Language, Canale__c, tipo_quest__c, nome_abbr__c, Codice_agente__c, Label 
                FROM SFA_Convenzionam_CanaleAgenti__mdt
                WHERE Codice_agente__c = :acc.CodiceAgente__c];
            
            if (lstCanaleAgenti.size() > 0) {
                nomeAbbreviato = lstCanaleAgenti[0].nome_abbr__c;
            }
        }

        //Nome abbreviato:
        Parametro param6=new Parametro();
        param6.valore=nomeAbbreviato;
        param6.variabile='$nome_abb_conv';
        paramsList.add(param6);
        
        return paramsList;
    } 
    
}