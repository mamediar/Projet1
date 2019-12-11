public class IVRUtil {

    private final static String FASCIA_1 = '9-12';
    private final static String FASCIA_2 = '12-15';
    private final static String FASCIA_3 = '15-18';
    public final static String FASCIA_DEFAULT = '1';

    public virtual class BatchException extends Exception {}


    public static Account checkCreateAccount(String codCliente){
        return checkCreateAccount(codCliente,true);
    }

    // controlla se esiste sul CRM Account per OCS Code 
    // se non esiste, lo crea recuperando i dati  dal WS
    public static Account checkCreateAccount(String codCliente,Boolean executeInsert){
        // deo aggiungere 'C' davanti all'ocsCustomerCode, perchè la creazione 
        // AccountUtils.makeAccounts prevede un prefisso con la 'C'
        String ocsCustomerCode='C'+codCliente;
        Account[] acc = [SELECT ID, OCS_External_id__c FROM Account WHERE OCS_External_id__c=:ocsCustomerCode LIMIT 1];
        //L'account non è presente a sistema
        if (acc.size() == 0) {
            // invoca Web service recupera dati post vendita: in risposta fornisce tutte le info utili per la creazione dell'account
            OCSRecuperaDatiPostvenditaResponse responseDatiPost = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(codCliente);
            if (responseDatiPost==null || responseDatiPost.cliente==null || responseDatiPost.cliente.size()==0) {
                throw new BatchException('Account non trovato con  WS recupera dati post vendita');
            }
            //recupera l'ogetto ocsCliente
            List<OCSCliente> ocsClients = OCSObjectsFactory.makeClienti(responseDatiPost);
            
            //AccountUtils.makeAccounts Istanzia un nouvo ogetto Account e ribalta le informazioni restituite dal servizio OCSRecuperaDatiPostvendita 
            //"Pre-compilandolo" e lo restituisce
            List<Account> accounts = AccountUtils.makeAccounts(ocsClients,'Compass');

            //se il metodo checkCreateAccount viene invocato NON specificando executeInsert = false l'account viene inserito e restituito al metodo chiamante, 
            //altrimenti l'account viene restituito "Pre-compilato" per lavorazi e/o censimento su CRM postumi
            if (executeInsert) { 
                insert accounts;
            }
            System.debug('checkAccount insert new account');
            return accounts.get(0);
        } 
        if (!executeInsert) {
            return null;
        }
        return acc[0];

    }

    //Se parametro Fascia Ricontatto è:
    //  0 -> default fascia 9-18
    //  1 -> fascia 9-12
    //  2 -> fascia 12-15
    //  3 -> fascia 15-18
    public static DateTime setDueDate(Integer fasciaDiRicontatto){

        Integer oraStart = 9;
        Integer oraEnd = 18;

        switch on fasciaDiRicontatto{

            when 1{
                oraStart=9;
                oraEnd=12;
            }
            when 2{
                oraStart=12;
                oraEnd=15;
            }
            when 3{
                oraStart=15;
                oraEnd=18;
            }

        }

        DateTime NOW = datetime.now();
        Datetime startDate =  DateTime.newInstance(NOW.year(), NOW.month(), NOW.day(),oraStart,0,0);
        Datetime endDate =  DateTime.newInstance(NOW.year(), NOW.month(), NOW.day(),oraEnd,0,0);
        Datetime dataRicontatto = NOW;

        if (NOW<startDate) {
            dataRicontatto = startDate;
        }
        if (NOW>endDate) {
            dataRicontatto = DateTime.newInstance(NOW.year(), NOW.month(), NOW.day()+1,oraStart,0,0);
        }
        return dataRicontatto.addMinutes(1);
    }

    public static String getFasciaDiRicontatto(Integer fasciaRicontatto){

        Map<Integer,String> mapFasciaRicontatto = new Map<Integer,String>();
        mapFasciaRicontatto.put(1,FASCIA_1);
        mapFasciaRicontatto.put(2,FASCIA_2);
        mapFasciaRicontatto.put(3,FASCIA_3);

        if(fasciaRicontatto > 0 && fasciaRicontatto < 4){
           return mapFasciaRicontatto.get(fasciaRicontatto); 
        }
        return FASCIA_DEFAULT;

    }

    public static Date parseStringToDate(String dateString){
        
        Integer year = Integer.valueOf(dateString.mid(0,4));
        Integer month = Integer.valueOf(dateString.mid(4,2));
        Integer day = Integer.valueOf(dateString.mid(6,2));

        Date d = Date.newInstance(year,month,day);
        return d;
    }


    // invio Note a OCS - future perchè dopo creazione Case
    @Future(callout=true)
    public static void sendNoteOCS(String codicePratica, String codiceTipoPratica, String codiceOcs, String nota){
        system.debug('nota da spedire a OCS: '+nota);
        String strUserAlias = [SELECT Alias FROM User WHERE Id =: UserInfo.getUserId()].Alias;
        if(!System.Test.isRunningTest()){
            OCSGestioneNoteResponse  response =  OCSGestioneNoteInvoker.gestioneNote(strUserAlias, codiceOcs, codicePratica, codiceTipoPratica, 'A', 'P', nota);
        }else{
            String response = '[APIResponse.status=OK, APIResponse.statusCode=200, OCSResponse.resultCode=0, OCSResponse.resultMessage=Ok, gestioneNoteResponse=InfoNota:[as400Errore=, as400Status=OK]]';
        }
        
    }


}