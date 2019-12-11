/**
   *@author Mame Diarra    
   *@date 2019/08/14
   * @description test ModificaAppuntamentoController Class
   */
@isTest
public class ModificaAppuntamentoControllerTest {
    
	@TestSetup
    static void setup(){
        Date myDate = Date.newInstance(1960, 2, 17);
        Account acct= new Account(FirstName='mame', LastName='kane', Sesso__pc='F', Data_Nascita__c=myDate);
        insert acct;
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Branch').getRecordTypeId();
        Account acct2= new Account(Name='test', RecordTypeId = recordTypeId);
        insert acct2;
        
        Product2 product1= new Product2(Name='test');
        insert product1;
        
        String inpputString='2019-07-01T11:25:00.000Z';
        DateTime resultDateTime = DateTime.ValueofGmt(inpputString.replace('T', ' ')); 
        XCS_Town__c town = new XCS_Town__c(Provincia_Desc__c='dakar',Catastale__c='A003',Comune__c='dakar plateau');
        Event event= new Event(Telefono_Cellulare__c='0238323',Product__c=product1.Id,
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,
                              ActivityDateTime=resultDateTime);
        insert event;
    }
    
    @isTest
    public static void testGetEventByDateActivity(){
        Event event=[select Id,ActivityDate from Event limit 1];
        Map<String ,Object> returnValue=ModificaAppuntamentoController.getEventByDateActivity(event.ActivityDate);
            
    }
    
    @isTest
    public static void testUpdateEvent(){
        Event event=[select Id,ActivityDate,Telefono_Cellulare__c,DurationInMinutes,ActivityDateTime from Event limit 1];
        event.Telefono_Cellulare__c='01585698';
        Map<String ,Object> returnValue =ModificaAppuntamentoController.updateEvent(event,'10:00');
    }
    
    @isTest
    public static void testAnnulaEvent(){
        Event event=[select Id,ActivityDate,Telefono_Cellulare__c,DurationInMinutes,ActivityDateTime,Stato_Azione__c from Event limit 1];
        event.Telefono_Cellulare__c='01585698';
        Map<String ,Object> returnValue =ModificaAppuntamentoController.annulaEvent(event);
    }
    
    @isTest
    public static void testGetDisposition(){
        Map<String ,Object> returnValue =ModificaAppuntamentoController.getDisposition('23');
    }
    
    @isTest
    public static void testGetAccountById(){
        Account acct=[select Id from Account limit 1];
        Map<String ,Object> returnValue =ModificaAppuntamentoController.getAccountById(acct.Id);
        //Exception
        Map<String ,Object> returnValueExp =ModificaAppuntamentoController.getAccountById(acct.Id);
    }
    
    @isTest
    public static void testGetProduct(){
        Product2 product=[select Id from Product2 limit 1];
        Map<String ,Object> returnValue =ModificaAppuntamentoController.getProduct(''+product.Id);
        //Exception
        Map<String ,Object> returnValueExp =ModificaAppuntamentoController.getProduct(null);
    }
    
    @isTest
    public static void testgetDateTime(){
        Event event=[select Id,ActivityDate,Telefono_Cellulare__c,DurationInMinutes,ActivityDateTime from Event limit 1];
        event.Telefono_Cellulare__c='01585698';
        Map<String ,Object> returnValue =ModificaAppuntamentoController.getDateTime(event,'10:00');
    }
    
        @isTest
    public static void testControleDateEvent(){
        Event event=[select Id,ActivityDate,Telefono_Cellulare__c,DurationInMinutes,ActivityDateTime from Event limit 1];
        event.Telefono_Cellulare__c='01585698';
        Map<String ,Object> returnValue =ModificaAppuntamentoController.controleDateEvent(event.ActivityDate,'');
        
    }
}