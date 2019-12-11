@isTest
public with sharing class CreaAppuntamentoControllerTest {
    
    @testSetup 
    static void testSetup() {
        Date myDate = Date.newInstance(1960, 2, 17);
        Account acct= new Account(FirstName='mame', LastName='kane', Sesso__pc='F', Data_Nascita__c=myDate);
        insert acct;
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Branch').getRecordTypeId();
        Account acct2= new Account(Name='test', RecordTypeId = recordTypeId);
        insert acct2;
        List<Product2> listproduit = new List<Product2>{
            new Product2(Name='P1', ProductCode='145', Family='PP_ONLINE_COMPASS_DS' , Livello__c = 0 ),
            new Product2(Name='P2', ProductCode='146', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 0 ),
            new Product2(Name='P3', ProductCode='147', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 1 )
        };
      insert listproduit;
        Product2 product1= new Product2(Name='test');
        insert product1;
        Datetime dt =getDateTime();
        XCS_Desk__c desk = new XCS_Desk__c(Name ='Desk1',isActive__c=true, Branch__c=acct2.Id, DeskName__c='Desk1' );
        insert desk;
        XCS_DeskItem__c deskItem = new XCS_DeskItem__c(Desk__c= desk.Id,	StartTime__c= dt.time(),
                            EndTime__c= dt.addHours(4).time().addMinutes(30),Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                            Thursday__c=true, Friday__c=true,Saturday__c=false,Sunday__c =false);
        insert deskItem;
        String inpputString='2019-10-15T11:30:00.000Z';
        DateTime resultDateTime = DateTime.ValueofGmt(inpputString.replace('T', ' ')); 
        XCS_Town__c town = new XCS_Town__c(Provincia_Desc__c='dakar',Catastale__c='A003',Comune__c='dakar plateau');
        Event event= new Event(Telefono_Cellulare__c='0238323',Product__c=product1.Id,
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,Type='Appuntamento',
                              ActivityDateTime=resultDateTime,ActivityDate=resultDateTime.date());
        insert event;
	}
    
    @isTest
    public static void testGetAllProductInteressato(){
         Map<String ,Object>  result=CreaAppuntamentoController.getAllProductInteressato();
    }
        
    @isTest
    public static void testGetProvince(){
        Map<String ,Object> result = CreaAppuntamentoController.getProvince();
    }
    
    @isTest
    public static void testGetAllProductDettaglio(){
         Product2 product = [select Name,Livello__c from Product2 limit 1];
         Map<String ,Object>  result=CreaAppuntamentoController.getAllProductDettaglio(product.Id);
    }
    
    @isTest
    public static void testGetCommuneByProvince(){
         Map<String ,Object>  result=CreaAppuntamentoController.getCommuneByProvince('dakar plateau');
    }
    
    @isTest
    public static void testControlleDateEvent(){
        Event event= [select Id,ActivityDateTime, ActivityDate  from Event limit 1];
         Map<String ,Object>  result=CreaAppuntamentoController.controlleDateEvent(event.ActivityDate);
    }
    
    @isTest
    public static void testCreateEvent(){
        Map<Id ,Object> slotMap = new Map<Id ,Object>();
        Account account=[select Id from Account limit 1];
        String inpputString='2019-10-15T11:30:00.000Z';
        DateTime resultDateTime = DateTime.ValueofGmt(inpputString.replace('T', ' ')); 
        Event event= new Event(Telefono_Cellulare__c='0238323',Product__c='01t0Q0000022iMoQAI',
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,
                              ActivityDateTime=resultDateTime,ActivityDate=resultDateTime.date());
        Account act= new Account(Phone='77898934',FirstName='mame',LastName='kane');
        Account act2= new Account(Phone='77898454',FirstName='opqrs',LastName='tuvwxyz');
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Map<String ,Object> result2 =CreaAppuntamentoController.createEvent(event,act2,filiale.Name,'11:00',slotMap);
        Map<String ,Object> result =CreaAppuntamentoController.createEvent(event,act,filiale.Name,'11:00',slotMap);
        System.debug('Event '+result);
        Map<String ,Object> result3 =CreaAppuntamentoController.createEvent(event,account,filiale.Name,'11:00',slotMap);
    }
    
    @isTest
    public static void testCalcolaCodiceFiscale(){
        Account cliente=[select Id, FirstName, LastName, Sesso__pc, Data_Nascita__c
                         from Account limit 1];
        String catastale='A003';
        Map<String ,Object> result = CreaAppuntamentoController.CalcolaCodiceFiscale(cliente,catastale);
        Map<String ,Object> result2 = CreaAppuntamentoController.CalcolaCodiceFiscale(cliente,'');
        System.debug('codice '+result);
    }
    
    @isTest
    static void controleDateEventTest(){
        Test.startTest();
            Event event= [select Id,ActivityDateTime, ActivityDate  from Event limit 1];
            Map<String ,Object> result =CreaAppuntamentoController.controleDateEvent(event.ActivityDate,'');
            Map<String ,Object> result2 =CreaAppuntamentoController.controleDateEvent(event.ActivityDate,null);

        Test.stopTest();
    }
	
    @isTest
    static void controlDateNascitaClienteTest(){
        Test.startTest();
            Account account=[select Id, Data_Nascita__c from Account limit 1];
            Map<String ,Object> result =CreaAppuntamentoController.controlDateNascitaCliente(account.Data_Nascita__c);
            Map<String ,Object> result2 =CreaAppuntamentoController.controlDateNascitaCliente(null);

        Test.stopTest();
    }
    @isTest
    static void getAccountByIdClienteTest(){
        Test.startTest();
             Account account=[select Id, Data_Nascita__c from Account limit 1];
            Map<String ,Object> result =CreaAppuntamentoController.getAccountByIdCliente(account.Id);
            Map<String ,Object> result2 =CreaAppuntamentoController.getAccountByIdCliente(null);

        
        Test.stopTest();
    }

    /**
     * @Author ADIOP
     * @date  08/08/2019
     * @description 
     **/
    @isTest
    static void getFilialesTest(){
        Test.startTest();
            CreaAppuntamentoController.getFiliales('societa', 'utenteEsterno',  'utenteInterno','');
        Test.stopTest();
    }

    /**
     * @Author ADIOP
     * @date  08/08/2019
     * @description 
     **/
    @isTest
    static void getDataLocationTest(){
        List<AppuntamentoListaFilialiResponse.FilialeOCS> filiales = new List<AppuntamentoListaFilialiResponse.FilialeOCS> ();
        AppuntamentoListaFilialiResponse.FilialeOCS filialeOCS = new AppuntamentoListaFilialiResponse.FilialeOCS();
        AppuntamentoListaFilialiResponse response = new AppuntamentoListaFilialiResponse();
        filialeOCS.id = 'dfghjklò';
        filialeOCS.idL = 'idl';
        filiales.add(filialeOCS);
        Test.startTest();
            CreaAppuntamentoController.getDataLocation(response.xml.result);
        Test.stopTest();
    }
    //
     @isTest
    static void getFilialeByIdTest(){
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Test.startTest();
		CreaAppuntamentoController.getFilialeById(filiale.Id);
		CreaAppuntamentoController.getFilialeById(null);
        Test.stopTest();
    }
    @isTest
    static void checkOperatorTest(){
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Test.startTest();
		CreaAppuntamentoController.checkOperator();
        Test.stopTest();
    }
    
     static Datetime getDateTime(){
        Datetime dt = Datetime.now();
        dt = dt.addDays(3);
        Datetime dtnew = Datetime.newInstance(dt.year(), dt.month(), dt.day(), 8, 0, 0);
        System.debug(' ################# dtnew'+dtnew);
        return dtnew ;
    }
    
}