@isTest
public class IntegrativoPenetrazioneCntTest {
    
    @TestSetup
    static void makeData(){

        List<Intervista_integrativo__c> intervistas = new List<Intervista_integrativo__c>();
        for (Integer i = 0; i < 8; i++) {
            Intervista_integrativo__c newIntervista = new Intervista_integrativo__c(); 
            newIntervista.Stato__c='vuoto';
            newIntervista.Plc_Prodotto__c ='PA';
            newIntervista.Name='';
            newIntervista.Plc_filiale__c='';
            newIntervista.Plc_Convenzionato__c='';
            newIntervista.Plc_Cliente__c='Test';
            newIntervista.Plc_Agente__c='';
            newIntervista.Num_Rate__c=0;
            newIntervista.Name='Test';
            newIntervista.Type__c='Penetrazione';
            newIntervista.Status__c='New';
            newIntervista.Data_Liquidazione__c=System.today();
        	newIntervista.Plc_Tipo_Prodotto__c='PA';
            newIntervista.CodiceServizio3__c = 'GAF01';
            newIntervista.CodiceServizio2__c = 'SIN01';
            newIntervista.CodiceServizio1__c = 'AIGA4';
            newIntervista.CodiceServizio4__c = null;
            newIntervista.CodiceServizio5__c = null;
            intervistas.add(newIntervista);
          
        }
        insert intervistas;
        
        intervistas[0].Plc_Prodotto__c='PA';
        intervistas[1].Plc_Prodotto__c='PA';
        intervistas[1].Plc_Tipo_Prodotto__c='PA';
        intervistas[0].Stato__c='Conclusa';
        
        intervistas[2].Plc_Prodotto__c ='PF';
        intervistas[3].Plc_Prodotto__c ='PF';
        intervistas[2].Plc_Tipo_Prodotto__c='PF';
        intervistas[2].Stato__c ='Conclusa';
        
        intervistas[4].Plc_Prodotto__c='PP Borg';
        intervistas[5].Plc_Prodotto__c='PP Borg';
        intervistas[4].Plc_Tipo_Prodotto__c='PP Borg';
        intervistas[4].Stato__c='Conclusa';
        
        intervistas[6].Plc_Prodotto__c='PP Altri';
        intervistas[7].Plc_Prodotto__c='PP Altri';
        intervistas[6].Plc_Tipo_Prodotto__c='PP Altri';
        intervistas[6].Stato__c='Conclusa';

        update intervistas;
        
        List<COM_CRMComodity_Check_Asc_Desc__c> comodities = new List<COM_CRMComodity_Check_Asc_Desc__c>();
        for (Integer i = 0; i < 4; i++) {
            COM_CRMComodity_Check_Asc_Desc__c comodity = new COM_CRMComodity_Check_Asc_Desc__c(); 
            comodity.Name='GAF01';
            comodity.COM_CRMTipo__c = 'MOTOR PROTECTION';
            comodity.COM_CRMflag_prod_sani_non_conn__c = 'N';
            comodities.add(comodity);
        }
        
        comodities[2].Name= 'AIGA4';
        comodities[3].Name= 'SIN01';
        insert comodities;
        comodities[0].COM_CRMflag_prod_sani_non_conn__c= 'S';
        comodities[1].COM_CRMflag_prod_sani_non_conn__c= 'S';
        update comodities;
        
    }

    @isTest
    static void countInterviewProductTest(){
        Test.startTest();
            Map<String,Object> response = IntegrativoPenetrazioneCnt.countInterviewProduct();
        Test.stopTest();   
    } 
    
    @isTest
    static void getAllIntervistaWithoutFilterTest(){
        Test.startTest();
            Map<String,Object> response = IntegrativoPenetrazioneCnt.getAllIntervistaWithoutFilter();
            System.debug('Intervistas: '+response.get('data'));
        	System.assertEquals(response.get('error'), false);
        Test.stopTest();   
    } 
    
    /**
 	* @author Mame Diarra
	* @date Creation 11/06/2019
 	* @version 
 	* @description Test of updateIntervista method.
 	*/
    @isTest
    static void updateIntervistaTest(){
        Test.startTest();
        Intervista_integrativo__c intervistaIntegrativo = [SELECT LastModifiedDate,Owner.Name, COM_Num_Non_Risponde__c, COM_Num_richiamare__c, COM_Richiamare_il__c, COM_Current_Period__c, COM_Data_Esito__c, COM_Intervista_Number__c, COM_Ultimo_Esito__c, Limite_mensile__c, Note__c, Durata_Sanitarie__c, Ac_Cap__c,
		                     Ragione_Sociale_Intermediario__c, Imp_Liquidato__c, Imp_Capitale__c, Num_Rate__c, Imp_Rata__c, Ac_Telefono_Sede__c, Ac_Telefono_Cel__c, Ac_Telefono_2__c, Ac_Telefono__c, Ac_Sesso__c, Ac_Rag_Sociale_2__c, Ac_Rag_Sociale_1__c, CodiceServizio5__c, CodiceServizio4__c,
		                     CodiceServizio3__c, CodiceServizio2__c, CodiceServizio1__c, Plc_Tipo_Prodotto__c,
		                     Plc_Agente__c, Plc_Convenzionato__c, Plc_Prodotto__c, Plc_Cliente__c, Data_Liquidazione__c,
		                     Stato__c, Status__c, Type__c, Name, Id, Regione__c, Area__c, Plc_filiale__c, COM_Data_Scadenza_Recesso__c, COM_Intervista_Utile__c, COM_data_caricamento__c,
		                     Ac_Nascita_Luogo__c, Ac_Nascita_Data__c, Ac_Provincia__c, Ac_Localita__c, Ac_Indirizzo_1__c
		                     FROM Intervista_integrativo__c LIMIT 1];
        intervistaIntegrativo.Ac_Rag_Sociale_1__c = 'Name For Test';
        Intervista_integrativo__c mySobject = IntegrativoPenetrazioneCnt.updateIntervista(intervistaIntegrativo);
        System.assertEquals(mySobject.Ac_Rag_Sociale_1__c, 'Name For Test');
        intervistaIntegrativo.Stato__c = 'Name For Test';
        try {
        	mySobject = IntegrativoPenetrazioneCnt.updateIntervista(intervistaIntegrativo);
        } catch (Exception e) {
            System.Assert(e.getMessage().contains('error message:'));
            System.Assert(e.getMessage().contains('Upsert failed'));
        }
        Test.stopTest();
    }
    
    /**
 	* @author Khadim Rassoul Ndeye
	* @date Creation 30/06/2019
 	* @version 
 	* @description Test of getCommodityCheck method.
 	*/
    @isTest
    static void testGetCommodityCheck(){
        //Intervista_integrativo__c intervistaIntegrativo= new Intervista_integrativo__c();
        Test.startTest();
        Intervista_integrativo__c intervistaIntegrativo = [SELECT LastModifiedDate,Owner.Name, COM_Num_Non_Risponde__c, COM_Num_richiamare__c, COM_Richiamare_il__c, COM_Current_Period__c, COM_Data_Esito__c, COM_Intervista_Number__c, COM_Ultimo_Esito__c, Limite_mensile__c, Note__c, Durata_Sanitarie__c, Ac_Cap__c,
		                     Ragione_Sociale_Intermediario__c, Imp_Liquidato__c, Imp_Capitale__c, Num_Rate__c, Imp_Rata__c, Ac_Telefono_Sede__c, Ac_Telefono_Cel__c, Ac_Telefono_2__c, Ac_Telefono__c, Ac_Sesso__c, Ac_Rag_Sociale_2__c, Ac_Rag_Sociale_1__c, CodiceServizio5__c, CodiceServizio4__c,
		                     CodiceServizio3__c, CodiceServizio2__c, CodiceServizio1__c, Plc_Tipo_Prodotto__c,
		                     Plc_Agente__c, Plc_Convenzionato__c, Plc_Prodotto__c, Plc_Cliente__c, Data_Liquidazione__c,
		                     Stato__c, Status__c, Type__c, Name, Id, Regione__c, Area__c, Plc_filiale__c, COM_Data_Scadenza_Recesso__c, COM_Intervista_Utile__c, COM_data_caricamento__c,
		                     Ac_Nascita_Luogo__c, Ac_Nascita_Data__c, Ac_Provincia__c, Ac_Localita__c, Ac_Indirizzo_1__c
		                     FROM Intervista_integrativo__c LIMIT 1];
        Map<String,Object> response = IntegrativoPenetrazioneCnt.getCommodityCheck(intervistaIntegrativo);
        System.assertEquals(response.get('assicurazioneCount'), 4);
        Test.stopTest();
    }
    
    /**
 	* @author Khadim Rassoul Ndeye
	* @date Creation 30/06/2019
 	* @version 
 	* @description Test of AddResponse method.
 	*/
    @isTest
    static void testAddResponse(){
        Risposte__c respdomanda = new Risposte__c();
		respdomanda.D2__c      = 'NON HO SOTTOSCRITTO / NON RICORDO DI AVER SOTTOSCRITTO ALCUN PRODOTTO ASSICURATIVO';
		respdomanda.D4__c      = 'Non';
		respdomanda.D3__c      = 'Si';
        Risposte__c myResp=IntegrativoPenetrazioneCnt.addResponse(respdomanda);
        Risposte__c getMyResp=[SELECT Id,Type__c FROM Risposte__c LIMIT 1];
        System.assertNotEquals(getMyResp, null);
    }
 /**
 	* @author Khadim Rassoul Ndeye
	* @date Creation 30/07/2019
 	* @version 
 	* @description Test of savePraticaEscluso method.
 	*/
    @isTest
    static void testSavePraticaEscluso(){
        List<Com_integr_crit_esclusioni__c> esclusioni = new List<Com_integr_crit_esclusioni__c>();
        List<String> data = new List<String>{'12345678', '12388678', '12345448', '99945678'};
        Map<String,Object> response = IntegrativoPenetrazioneCnt.savePraticaEscluso(data);
        //System.assertNotEquals(getMyResp, null);
        System.assertEquals(response.get('error'), false);
        data.add('aaaa');
        response = IntegrativoPenetrazioneCnt.savePraticaEscluso(data);
        System.assertEquals(response.get('error'), true);
        
    }
}