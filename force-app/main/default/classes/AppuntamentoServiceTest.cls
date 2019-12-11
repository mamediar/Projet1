/**--------------------------------------------------------------------------------------
  * @Author Madicke BALDE
  * @description Test CLass For Appuntamento web service
  * @date 2019/08/13
 *---------------------------------------------------------------------------------------------*/
@isTest
public class AppuntamentoServiceTest {
   
    //  ################################ create Date test  ###############################################
    @TestSetup
    static void makeData(){

        // ############################## Get recordType Client ###########################################
         Id idRecordTypeAccount = CGMWSUtils_1_0.getRecordTypeId('Account', 'PersonAccount');
        // Get recordType Branch
         Id idRecordTypeAccountBranch = CGMWSUtils_1_0.getRecordTypeId('Account', 'Branch');
        //################################ create client : Accout with recordType Customer #################
       List<Account> listAccountCustomer = new List<Account>{
           new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEmADICKE', Codice_Fiscale__c ='RZZNNN69B25F158O'),
           new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEMacky', Codice_Fiscale__c ='447')
       };
       insert  listAccountCustomer;

         //################################## create client : Accout with recordType Branch ##############
       List<Account> listAccountBranch = new List<Account>{
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='EMPOLI', OCS_External_Id__c='22' ),
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='Naple', OCS_External_Id__c='24')
       };
        insert  listAccountBranch;

        // #################################### Create XCS_Desk  Data ##################################
        List<XCS_Desk__c> xcsDeskList = new  List<XCS_Desk__c>{
            new XCS_Desk__c(Name ='Desk1', Branch__c=listAccountBranch[0].Id, DeskName__c='Desk1' ),
            new XCS_Desk__c(Name ='Desk2', Branch__c=listAccountBranch[1].Id, DeskName__c='Desk2' ),
            new XCS_Desk__c(Name ='Desk3', Branch__c=listAccountBranch[0].Id, DeskName__c='Desk3' )
        };
       insert xcsDeskList;
    
       // ######################################## Create XCS_DeskItem__c ############################
       Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
       Datetime dt1 = Datetime.newInstance(2019, 08, 13, 09, 30, 0);
       Datetime dt2 = Datetime.newInstance(2019, 08, 13, 08, 0, 0);

        List<XCS_DeskItem__c> xcsDeskListItem = new  List<XCS_DeskItem__c>{
            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c= dt.time(),
                            EndTime__c= dt.addHours(4).time().addMinutes(30),Monday__c=false, Tuesday__c=false,Wednesday__c=false,
                            Thursday__c=false, Friday__c=true,Saturday__c=false,Sunday__c =false),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c=  dt1.time(),
                            EndTime__c= dt1.addHours(4).time().addMinutes(30) , Monday__c=false, Tuesday__c=true,Wednesday__c=false,
                            Thursday__c=false, 	Friday__c=false,Saturday__c=false,Sunday__c =false ),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c= dt2.time(),
                            EndTime__c=dt2.addHours(4).time().addMinutes(30), Monday__c=true, Tuesday__c= false,Wednesday__c= false,
                            Thursday__c=false, 	Friday__c=false,Saturday__c=false,Sunday__c =false )
        };
        insert xcsDeskListItem;
       
        // ################################# Create Event Data test ####################################
        List<Event> listEvent = new List<Event>{
            new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dt.date() , DurationInMinutes=4,  ActivityDateTime= dt.addMinutes(4), Customer__c =listAccountCustomer[0].Id ),
            new Event(Desk__c=xcsDeskList[1].Id, ActivityDate=dt1.date(), DurationInMinutes=4, ActivityDateTime= dt1.addMinutes(3), Customer__c= listAccountCustomer[1].Id ),
            new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() ,DurationInMinutes=4, ActivityDateTime= dt2.addMinutes(2), Customer__c=listAccountCustomer[1].Id )
        };
        
        insert listEvent;

        // ######################## Product2 Data #######################################################
        Product2 prodotto = new Product2(Name='prodotto1',Livello__c = 2);
        insert prodotto;
    }
   
   @isTest
   static void appuntamentoPostTest(){

        String jsonRequete = '{"societa":"Compass","utenteEsterno":"","utenteInterno":"","codFiliale":"22",\n'+
                                ' "data":"20190820","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
                                ' "nome":"Antonio","cognome":"Rizzo","sesso":"", "localitaNascita":"","provinciaNascita":"",\n'+
                                ' "capResidenza":"54100","dataNascita":"","privacyExtcommoffer":"0","privacyInterncommoffer":"1",\n'+
                                ' "privacyOtherservice":"0","privacyProfilazione":"0","tipoOccupazione":"2;1","contactID":"",\n'+
                                ' "email":"69antoninorizzo@gmail.com","cellulare":"3315437111","codiceFiscale":"RZZNNN69B25F158O"\n'+
                                ' },"datiMediaUTM":{"mediacode":"4389","utmDate":"2019081200"	},"prodottoLvl1":"2","prodottoLvl2":"prodottoLvl2"} ';
        List<Event> eventList = [SELECT Id FROM Event WHERE Customer__r.Codice_Fiscale__c ='4477' AND Stato_Azione__c !='Non presentato/Annullato'];
        System.debug('********** Liste event '+eventList);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response = new RestResponse();
        req.requestURI ='/services/apexrest/Appuntamento/*';
        req.requestBody = Blob.valueOf(jsonRequete);
        RestContext.request = req;
        RestContext.response = response;
        AppuntamentoService.appuntamento();
        System.debug(' ************************** response '+response);
        System.assertEquals(200, response.statusCode, '#### pass ###');
        Test.stopTest();
   }
   @isTest
   static void appuntamentoModificaPut(){
       //00U0Q000002IMXZUA4
       List<Event> eventList = [SELECT Id FROM Event];
       String idEvent = String.valueOf(eventList[0].Id) ;
       String jsonRequest = '{"codFiliale":"22","codiceFiscale":"447", "oppID": "'+idEvent +'","ora":"06:30","data":"20190816"}';
       System.debug(eventList[0].Id);
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();
       req.requestURI ='/services/apexrest/Appuntamento';
       req.requestBody = Blob.valueOf(jsonRequest);
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoService.appuntamentoModifica(); 
       System.debug(' ************************** response '+response);
       System.assertEquals(200, response.statusCode, '#### pass ###');
       Test.stopTest();
   }

   @isTest
   static void appuntamentoCercatest(){
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();
       req.requestURI ='/services/apexrest/Appuntamento/RZZNNN658O';
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoService.appuntamentoCerca();
       System.debug('######### response ######### '+response);
       Test.stopTest();
   }

   @isTest
   static void getOccupazioneValuetest(){
       Test.startTest();
        List<SelectOption> listSelect = AppuntamentoDomain.getOccupazioneValue();
       
        for(SelectOption sele : listSelect){
            System.debug('############# getValue ###### '+sele.getValue());
            if(sele.getValue() == '2'){
              System.debug(' ############### '+sele);
               break;
            }
          
        }
       Test.stopTest();
   }
}