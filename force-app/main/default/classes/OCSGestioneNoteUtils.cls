public class OCSGestioneNoteUtils {
    public static void postNoteVariazioneAnagrafica(String caseId,String note){
        System.debug('OCSGestioneNoteUtils postNoteVariazioneAnagrafica start');
        OCSGestioneNoteInvoker.filtraNote
            (
                [select Alias from User where Id=:UserInfo.getUserId()].Alias, //utente
                CaseUtils.getOCSAccountId(caseId), //codCliente
                '', //numPratica
                '', //tipoPratica
                'A', //modalita 
                'P', //tipoNote
                XCSGestioneNotePostvenditaUtils.buildNoteVariazioneAnagrafica(caseId,note) //note //Commentato perché la XCSGestioneNotePostvenditaUtils non compila
            ); 
        System.debug('OCSGestioneNoteUtils postNoteVariazioneAnagrafica end');
    }
    
    public static void postNoteInserimentoReclami(Case c){
        System.debug('OCSGestioneNoteUtils postNoteInserimentoReclami start');
        
        OCSGestioneNoteInvoker.filtraNote
            (
                [select Alias from User where Id=:UserInfo.getUserId()].Alias, //utente, verificare che vada bene
                OCSGestioneNoteUtils.getCodiceCliente(c), 
                c.NumeroPratica__c != null ? c.NumeroPratica__c : '', 
                c.Tipo_Pratica__c != null ? c.Tipo_Pratica__c : '', 
                'A',
                'P', 
                XCSGestioneNoteReclamiUtils.buildNoteInserimento(c)
            );
        System.debug('OCSGestioneNoteUtils postNoteInserimentoReclami end');
        
    }
    
    public static void postNoteChiusuraReclami(Case c){
        System.debug('OCSGestioneNoteUtils postNoteInserimentoReclami start');
        
        OCSGestioneNoteInvoker.filtraNote
            (
                [select Alias from User where Id=:UserInfo.getUserId()].Alias, //utente, verificare che vada bene
                OCSGestioneNoteUtils.getCodiceCliente(c), 
                c.NumeroPratica__c != null ? c.NumeroPratica__c : '', 
                c.Tipo_Pratica__c != null ? c.Tipo_Pratica__c : '', 
                'A',
                'P', 
                XCSGestioneNoteReclamiUtils.buildNoteChiusura(c)
            );
        
        System.debug('OCSGestioneNoteUtils postNoteInserimentoReclami end');
    }
    
    
    private static String getCodiceCliente(Case c){
        //
        //Il metodo funziona solo per i valori Compass, Futuro e MBC. Per valori ulteriori, che magari verranno implementati in futuro,
        //il metodo effettua il return di una stringa vuota
        //
        if (c.Referenced_Company__c == XCSCompassConstants.COMPASS) {
            Account acc = [SELECT getCodice_Cliente__c FROM Account WHERE Id =: c.AccountId ];
            return acc.getCodice_Cliente__c != null ? acc.getCodice_Cliente__c : '';
        }
        else{
            if(c.Referenced_Company__c == XCSCompassConstants.FUTURO || c.Referenced_Company__c == XCSCompassConstants.MBC){
                Account_Futuro_MBCS__c accFutMBC = [SELECT External_Id__c  FROM Account_Futuro_MBCS__c WHERE Id =: c.Account_Futuro_MBCS__c ];
                return accFutMBC.External_Id__c != null ? accFutMBC.External_Id__c.substring(1,accFutMBC.External_Id__c.length()) : '';
            }
        }
        return '';
    }
}