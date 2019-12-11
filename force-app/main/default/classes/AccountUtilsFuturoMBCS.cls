public class AccountUtilsFuturoMBCS {
    
    public static Account_Futuro_MBCS__c makeAccount(Map<String, String> data, String societa){
        
        Account_Futuro_MBCS__c res=new Account_Futuro_MBCS__c(
            LastName__c = data.get('cognome'),
            External_id__c = String.isNotEmpty(data.get('codCliente')) ? 'C'+data.get('codCliente') : null,
            FirstName__c = data.get('nome'),
            Birthdate__c = dateToParse(data.get('dataNascita')),
           // Birthdate__c = data.get('dataNascita'),
            Birthcity__c = data.get('luogoNascita'),
            Birthprovince__c = data.get('provNascita'),
            Sesso__c =data.get('sesso'),
            Codice_Fiscale__c = data.get('codFiscale'),
            //Ragione_Sociale__c = data.get('piva'),
            Street__c = data.get('indirizzo'),
            Zip_Code__c = data.get('cap'),
            City__c =data.get('localita'),
            Province__c = data.get('provincia'),
            //Email__c = getEmail(data.get('codCliente')),
            Phone__c = data.get('telefonoCasa'),
            Mobile__c = data.get('telCellulare')
            
        );
        System.debug('AccountUtilsFuturoMBCS makeAccount1 res: ' + res);
        return res;
        
    }
    
    public static Account_Futuro_MBCS__c makeAccount(OCSCliente cm, String company){
        
        Account_Futuro_MBCS__c res=new Account_Futuro_MBCS__c(
            
            LastName__c = cm.cognome, 
            External_id__c = String.isNotEmpty(cm.codCliente) ? 'C'+cm.codCliente : null,
            FirstName__C = cm.nome,
            Birthdate__c = dateToParse(cm.dataNascita),
            Birthcity__c = cm.luogoNascita,
            Birthprovince__c = cm.provNascita,
            Sesso__c = cm.sesso,
            Codice_Fiscale__c = cm.codFiscale,
            //Ragione_Sociale__c = cm.piva,
            Street__c = cm.indirizzo,
            Zip_Code__c = cm.cap,
            City__c = cm.localita,
            Province__c = cm.provincia,
            //Email__c = getEmail(cm.codCliente),
            Phone__c = cm.telefonoCasa,
            Mobile__c = cm.telCellulare
            
        );
        
        System.debug('AccountUtilsFuturoMBCS makeAccount2 res: ' + res);
        return res;
        
    }
    
    public static Account_Futuro_MBCS__c upsertAccount(Account_Futuro_MBCS__c acc, String company){
        
        Account_Futuro_MBCS__c res = new Account_Futuro_MBCS__c(  
            LastName__c = acc.LastName__c,
            External_Id__c = acc.External_Id__c,
            FirstName__c = acc.FirstName__c,
            Birthdate__c = acc.Birthdate__c,
            Birthcity__c = acc.Birthcity__c,
            Birthprovince__c = acc.Birthprovince__c,
            Sesso__c = acc.Sesso__c,
            Codice_Fiscale__c = acc.Codice_Fiscale__c,
            Ragione_Sociale__c = acc.Ragione_Sociale__c,
            Street__c = acc.Street__c,
            Zip_Code__c = acc.Zip_Code__c,
            City__c = acc.City__c,
            Province__c = acc.Province__c,
            Email__c = acc.Email__c,
            Phone__c = acc.Phone__c,
            Mobile__c = acc.Mobile__c
            
        );
        //TODO - Verificare le condizioni e le tipolgie di anagrafica
        System.debug('AccountUtilsFuturoMBCS upsertAccount res: ' + res);
        if(String.isNotEmpty(res.External_Id__c)){
            upsert res External_Id__c;
        }
        else{
            insert res;
        }
        System.debug('AccountUtilsFuturoMBCS upsertAccount res ID: ' + res.Id);
        return res;
    }
    
    
    @TestVisible
    private static Date dateToParse(String dateOCS){
        
        System.debug('OCSRecuperaDatiPostvenditaController dateToParse input: ' + dateOCS);
        Date res = null; 
     //   try{
            
                    if(dateOCS != '0' && dateOCS != null && dateOCS != ''){ 
                    
                      if(dateOCS.contains('/') ){
                        	res = Date.parse(dateOCS);
                             System.debug('AccountUtilsFuturoMBCS dateToParse / '+res);
                        }
                        else if(dateOCS.contains('-')){
                        	res = Date.newInstance(Integer.valueOf(dateOCS.substring(0,4)), 
                                         Integer.valueOf(dateOCS.substring(5,7)),
                                         Integer.valueOf(dateOCS.substring(8,10)));
                              System.debug('AccountUtilsFuturoMBCS dateToParse elseif '+res);
                            
                        }
                        else{
                        	res = Date.newInstance(Integer.valueOf(dateOCS.substring(0,4)), 
                                         Integer.valueOf(dateOCS.substring(4,6)),
                                         Integer.valueOf(dateOCS.substring(6,8)));
                             System.debug('AccountUtilsFuturoMBCS dateToParse Else '+res);
                        }
                    }
                    else
                    	res = null;
                    
                        
        //}
        
      /*  catch(Exception e){
            System.debug('AccountUtilsFuturoMBCS dateToParse Exception, message: ' + e.getCause()+'\n' + e.getStackTraceString());
        }*/
        
        return res;
        
    }
    
    
    @TestVisible
    private static String getEmail(String codCliente) {
        
        String res = '';
        List<Account_Futuro_MBCS__c> listAcc = [select Id, Email__c from Account_Futuro_MBCS__c where External_Id__c = :codCliente];
        if(listAcc.size() > 0) {
            res = listAcc[0].Email__c;
        }
        
        return res;
        
    } 
    
}