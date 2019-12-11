/**
 * @author Mame Diarra
 * @date Creation 11/06/2019
 * @version 
 * @description Test of CommodityFuturoCnt.
 */
@isTest
public class CommodityFuturoCntTest {
	@TestSetup
    static void setup(){
        COM_Agente__c comAgente= new COM_Agente__c();
        insert comAgente;
        Com_Commodity_Survey__c ComCommoditySurvey = new Com_Commodity_Survey__c(Name='test',COM_AGENTE_FUTURO__c=comAgente.Id);
        insert ComCommoditySurvey;
        
        Risposte__c RispostaIstance                           = new Risposte__c();
        RispostaIstance.Intervista_Futuro__c                  = ComCommoditySurvey.Id;
        RispostaIstance.Type__c                               = 'Futuro';
        insert RispostaIstance;
           
    }
    
 	
    @isTest
    static void getAllAgenteTest(){
        Map<String,Object> response=new Map<String,Object>();
        response=CommodityFuturoCnt.getAllAgente();
    }
    
    
    @isTest
    static void getCommoditiesTest(){
        Map<String,Object> response=new Map<String,Object>();
        response=CommodityFuturoCnt.getCommodities();
    }
    
    
    @isTest
    static void getCommoditySurveyDetailTest(){
        Map<String,Object> response=new Map<String,Object>();
        Com_Commodity_Survey__c ComCommoditySurvey=[SELECT Id,Name FROM Com_Commodity_Survey__c LIMIT 1];
        System.debug('Mame '+ComCommoditySurvey);
        response=CommodityFuturoCnt.getCommoditySurveyDetail(ComCommoditySurvey.Id);
        //for the exception
        Map<String,Object> response2=CommodityFuturoCnt.getCommoditySurveyDetail(null);
       
    }
    
    
    @isTest
    static void updateSobjectTest(){
        Com_Commodity_Survey__c ComCommoditySurvey= new Com_Commodity_Survey__c();
        SObject mySobject=CommodityFuturoCnt.updateSobject(ComCommoditySurvey);
        System.assertEquals(mySobject, null);
        //if mySobject not equals null
        ComCommoditySurvey=[SELECT Id,Name FROM Com_Commodity_Survey__c LIMIT 1];
		mySobject=CommodityFuturoCnt.updateSobject(ComCommoditySurvey);
        System.assertNotEquals(mySobject, null);
    }
    
    
    @isTest
    static void getCommoditiesByAgenteTest(){
        Map<String,Object> response= new Map<String,Object>();
        COM_Agente__c agenteFuturo=[SELECT Id FROM COM_Agente__c LIMIT 1];
        Risposte__c    RispostaObj=[SELECT ID,Type__c FROM Risposte__c LIMIT 1];
        SObject SSObj = (SObject)RispostaObj;
        response=CommodityFuturoCnt.getCommoditiesByAgente(agenteFuturo.Id);
        //for the exception
        response=CommodityFuturoCnt.upsertRisposta(RispostaObj);
        CommodityFuturoCnt.updateListSobject(new List<SObject>{SSObj});
        RispostaObj.Id=null;
        SObject SSObj1 = (SObject)RispostaObj;
        

        CommodityFuturoCnt.updateListSobject(new List<SObject>{SSObj1});

        
    }
    @isTest 
    static void method1()
    {
            Map<String,Object> response= new Map<String,Object>();
            Com_Commodity_Survey__c ComCommoditySurvey=[SELECT Id,Name FROM Com_Commodity_Survey__c LIMIT 1];
            response=CommodityFuturoCnt.getRisposteByCommoditySurveyId(ComCommoditySurvey.Id);
            response=CommodityFuturoCnt.getRisposteByCommoditySurveyId(null);
            response=CommodityFuturoCnt.getRisposteValutazione();
    }
}