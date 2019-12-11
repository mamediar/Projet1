@isTest
public class SchedaVerificaFilialeVisElencoPratTest {
     @TestSetup
    static void makeData(){
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Account branch = new Account(Name = 'Alessandria',Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria');
        insert branch;
        ApiRest__c api = new ApiRest__c(EndPoint__c='test',Method__c='POST',name='recuperaPratichePerVisita',Password__c='password',Ref__c='CompassInternal',User__c='user');
        insert api;
        ApiUtil__c util = new ApiUtil__c(Name = 'CompassInternal', Password__c='Password__c',Ref__c='CompassInternal',User__c='User',Endpoint__c='endpoint');
        insert util;
    }

    @isTest
    static void inserisciElementiSelezionatiWithError(){
        String result;
        String exceptions;
        try{
            result = SchedaVerificaFilialeVisElencoPratCtrl.inserisciElementiSelezionati('','');
        } catch(Exception e){
            exceptions = e.getMessage();
        }
  
        System.assert(!String.isBlank(exceptions));
    }

    @isTest
    static void generaPratica (){
        Scheda_Verifica_Filiale__c scheda = new Scheda_Verifica_Filiale__c();
        scheda.Periodo_dal__c = System.today();
        insert scheda;
        Map<String,String> elemento = new Map<String,String> ();
        elemento.put('canale', '1');
        elemento.put('codCliente', '1');
        elemento.put('dataLiquidazione', '1');
        elemento.put('finanziato', '1');
        elemento.put('intermediario', '1');
        elemento.put('numPratica', '1');
        elemento.put('procedura', '1');
        elemento.put('prodotto', '1');
        elemento.put('canale', '1');
        elemento.put('ragioneSociale', '1');
        
        Pratica_Scheda_Filiale__c pratica = SchedaVerificaFilialeVisElencoPratCtrl.generaPratica(elemento,scheda.ID);
        System.assertEquals('1', pratica.Canale__c);
        System.assertEquals('1', pratica.Cod_Cliente__c);
        System.assertEquals('1', pratica.Data_Liquidazione__c);
    }

    @isTest
    static void restService(){
        String input = '{"codCliente":"224","codOcsDealer":"3","paAuto":"0","pfMobili":"0","ppRete":"0","ppPoste":"0","ppBanche":"0","ppAgeAss":"0","pfNoMobili":"0","dataLiquidazioneDa":"0","dataLiquidazioneA":"0"}';
        String output = SchedaVerificaFilialeVisElencoPratCtrl.restService(input);
        System.assertEquals('errore servizio', output);
    }

}