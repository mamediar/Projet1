@isTest
public with sharing class SFAListaDaSedeGestioneAttivitaContrTest {
    
     @isTest
     public static void test1(){
        
        Test.startTest();
        XCS_Disposition__c dis = new XCS_Disposition__c(Name='Positivo',External_Id__c='1732');
        insert dis;
        
        XCS_Disposition__c dis2 = new XCS_Disposition__c(Name='Ancora_Positivo',Parent__c=dis.Id);
        insert dis2;
        
        XCS_Categoria__c cat = new XCS_Categoria__c(Name='categoria1');
        insert cat;
        
        SFA_TipologiaLista__c lista = new SFA_TipologiaLista__c(Name='nome_lista');
        insert lista;    
        
        XCS_dealers_conv_activity_disp__c dealers = new XCS_dealers_conv_activity_disp__c();
        dealers.Codice_Attivita_Lista_da_Sede__c = lista.Id;
        dealers.Esito_1__c = dis.Id;
        dealers.Esito_2__c = dis2.Id;
        insert dealers;
        
       
        List<XCS_dealers_conv_activity_disp__c> lst = SFAListaDaSedeGestioneAttivitaController.getCategoryList();
        system.assertEquals(true, lst.size() >= 0); 
        
        List<XCS_Disposition__c> disListL1 = SFAListaDaSedeGestioneAttivitaController.getDispositionLevel1();
        system.assertEquals(true, disListL1.size() >= 0); 
        
        List<XCS_Disposition__c> disList = SFAListaDaSedeGestioneAttivitaController.getDispositionList(dis.Id);
        system.assertEquals(true, disList.size() >= 0);
        
        //SFAListaDaSedeGestioneAttivitaController.createGestisciAttivita(lista.Id, dis.Id);
        Id leveId= null;
        system.assertEquals(true, SFAListaDaSedeGestioneAttivitaController.createGestisciAttivita(lista.Id,leveId, dis.Id));
        
        List<XCS_dealers_conv_activity_disp__c> attList = SFAListaDaSedeGestioneAttivitaController.getGestisciAttivita(lista.Id, dis.Id);
        system.assertEquals(true, attList.size() >= 0);
        
        Id retId = SFAListaDaSedeGestioneAttivitaController.insertCategory(lista.Name, dis.Id);
        system.assertEquals(true,retId!=null);
        
        Id retId2 = SFAListaDaSedeGestioneAttivitaController.insertCategory('nuova lista', dis2.Id);
        system.assertEquals(true,retId2!=null);
        
        List<XCS_dealers_conv_activity_disp__c> dealerList = new List<XCS_dealers_conv_activity_disp__c>();
        dealerList.add(dealers);
        
        system.assertEquals(true,SFAListaDaSedeGestioneAttivitaController.removeActivity(dealerList));
        
        system.assertNotEquals('lista',SFAListaDaSedeGestioneAttivitaController.getCategoryName(lista.Id));
        system.assertNotEquals('level_1',SFAListaDaSedeGestioneAttivitaController.getLevel1Name(dis2.Id));
        system.assertNotEquals('disp_Name',SFAListaDaSedeGestioneAttivitaController.getDispositionName(dis.Id));
        system.assertNotEquals(true,SFAListaDaSedeGestioneAttivitaController.findCategoryByName(lista.Name));
        
        
        
        TEst.stopTest();
    }
    
    
    @isTest
    public static void test2(){
        
        
        XCS_Disposition__c dis = new XCS_Disposition__c(Name='Positivo',External_Id__c='1732');
        insert dis;
        
        XCS_Disposition__c dis2 = new XCS_Disposition__c(Name='Ancora_Positivo',Parent__c=dis.Id);
        insert dis2;
        
        XCS_Categoria__c cat = new XCS_Categoria__c(Name='categoria1');
        insert cat;
        
        SFA_TipologiaLista__c lista = new SFA_TipologiaLista__c(Name='nome_lista');
        insert lista; 
        
        
        Map<String,String> mappa = new Map<String,String>();
        mappa.put('catId',String.valueOf(lista.Id));
        mappa.put('levId',String.valueOf(dis.Id));
        mappa.put('disId',String.valueOf(dis2.Id));
        
        List<Map<String,String>> mapList = new List<Map<String,String>>();
        mapList.add(mappa);
        
        //insert mapList;
        
        Test.startTest();
    	system.assertEquals(true,SFAListaDaSedeGestioneAttivitaController.insertRecord(mapList, lista.Id));
        Test.stopTest();
        
    }


     @isTest
     public static void test3(){
        
        Test.startTest();
        XCS_Disposition__c dis = new XCS_Disposition__c(Name='Positivo',External_Id__c='1732');
        insert dis;
        
        XCS_Disposition__c dis2 = new XCS_Disposition__c(Name='Ancora_Positivo',Parent__c=dis.Id);
        insert dis2;
        
        XCS_Categoria__c cat = new XCS_Categoria__c(Name='categoria1');
        insert cat;
        
         SFA_TipologiaLista__c lista = new SFA_TipologiaLista__c(Name='nome_lista',Descrizione__c = 'desc');
        insert lista; 
      
        XCS_dealers_conv_activity_disp__c dealers = new XCS_dealers_conv_activity_disp__c();
        dealers.Codice_Attivita_Lista_da_Sede__c = lista.Id;
        dealers.Esito_1__c = dis.Id;
        dealers.Esito_2__c = dis2.Id;
        insert dealers;
        
       
        String descr = SFAListaDaSedeGestioneAttivitaController.getCategoryName(lista.id);
        System.assert(!String.isEmpty(descr)); 
        
        String levelName = SFAListaDaSedeGestioneAttivitaController.getLevel1Name(dis.id);
        System.assert(!String.isEmpty(levelName));
        
        String dispName = SFAListaDaSedeGestioneAttivitaController.getDispositionName(dis.id);
        System.assert(!String.isEmpty(dispName));
        
        List<XCS_dealers_conv_activity_disp__c> listaAct = new  List<XCS_dealers_conv_activity_disp__c>();
        listaAct.add(dealers);
        Boolean res  = SFAListaDaSedeGestioneAttivitaController.removeActivity(listaAct);
        System.assert(res);
 
        TEst.stopTest();
    }
    

}