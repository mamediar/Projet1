//----------------------------------------------------------------------
    //-- - Author       : SANA BADJI
    //-- - Date         : 23/09/2019
    //-- - Class  : GUA_GestionCampagnaCntTest
    //-- - Modify by: Aminata GUEYE | Date: 16/10/19
    //----------------------------------------------------------------------
@isTest
public class GUA_GestionCampagnaCntTest {
   
    
     @TestSetup
    static void makeData(){
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        
        List<Campaign> campaigns = new List<Campaign>{
        new Campaign(StartDate= Date.today(),UAF_DatiAggiuntivi__c='Sana,Diop,Ba',
        EndDate=Date.today(),
        UAF_Script__c='ff', Name='Campagna-New',RecordTypeId=recordType),
        new Campaign(StartDate=Date.today(),UAF_DatiAggiuntivi__c='Balde,Camara,Balde',
        EndDate=Date.today(),UAF_Script__c='test', Name='Campagna',RecordTypeId=recordType)
        };
        insert campaigns;

    }

    @isTest
    static void getCampaigntest(){
        Test.startTest();
        String pageSize='10';
        String pageNumber='20';
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        List<Campaign> campaigns=GUA_GestionCampagnaCnt.getCampaign(pageSize,pageNumber);
        System.debug('campaigns '+campaigns);
        System.assertEquals(0, campaigns.size(), 'campaigns.size()==0');

        Test.stopTest();
    }
     @isTest
    static void getCampaignintlimitstest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        Integer intlimits=1;
        List<Campaign> campaigns=GUA_GestionCampagnaCnt.getCampaignLimit(intlimits);
        System.debug('campaigns '+campaigns);
         System.assertEquals(1, campaigns.size(), 'campaigns.size()==2');

        Test.stopTest();

    }
         @isTest
    static void getCampaignintlimitsEqualZerotest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        Integer intlimits=0;
        List<Campaign> campaigns=GUA_GestionCampagnaCnt.getCampaignLimit(intlimits);
        System.debug('campaigns '+campaigns);
         System.assertEquals(2, campaigns.size(), 'campaigns.size()==2');

        Test.stopTest();

    }


    @isTest
    static void getCampaignbyNametest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        String name='Campagna-New';
        List<Campaign> campaigns=GUA_GestionCampagnaCnt.getCampaignbyName(name);
        System.debug('campaigns '+campaigns);
         System.assertEquals(1, campaigns.size(), 'campaigns.size()==2');

        Test.stopTest();

    }

    @isTest
    static void getCampaignByIDtest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        list<Campaign> Ids =[SELECT Id FROM Campaign];
        String campID= Ids[0].id;
        List<Campaign> campaigns=GUA_GestionCampagnaCnt.getCampaignByID(campID);
       
        System.debug('campaigns '+campaigns);
         System.assertEquals(1, campaigns.size(), 'campaigns.size()==1');

        Test.stopTest();

    }

     @isTest
    static void saveCampaigntest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        Campaign campaign= new Campaign(StartDate= Date.today(),UAF_DatiAggiuntivi__c='Sana,Diop,Ba',
        EndDate=Date.today(),
        UAF_Script__c='ff', Name='Campagna-New',RecordTypeId=recordType);
        Campaign campaigns=GUA_GestionCampagnaCnt.saveCampaign(campaign);
        System.debug('campaigns '+campaigns);
         System.assert(campaigns!=null, 'campaigns!=null');

        Test.stopTest();

    }

    
     @isTest
    static void saveCampaignExceptiontest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        Campaign campaign= new Campaign();
         System.debug('saveCampaignExceptiontest '+campaign);
        Campaign campaigns=GUA_GestionCampagnaCnt.saveCampaign(campaign);
        System.debug('campaigns '+campaigns);
         //System.assert(campaigns==null, 'campaigns==null');

        Test.stopTest();

    }

    
     @isTest
    static void updateCampaigntest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
       List<Campaign> campaigns = 
         [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                        UAF_DatiAggiuntivi__c 
                    FROM Campaign Where RecordTypeId =:recordType];
        String datiAggiuntivi= campaigns[0].UAF_DatiAggiuntivi__c;
       GUA_GestionCampagnaCnt.updateCampaign(campaigns,datiAggiuntivi);
        System.debug('campaigns '+campaigns);
        System.assertEquals(2, campaigns.size(), 'campaigns.size()==2');

        Test.stopTest();
    }

    
    
     @isTest
    static void updateCampaignExceptiontest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
       List<Campaign> campaigns = new List<Campaign> () ;
        System.debug('updateCampaignExceptiontest '+campaigns);
       GUA_GestionCampagnaCnt.updateCampaign(campaigns,null);
        System.debug('campaigns '+campaigns);
        System.assertEquals(0, campaigns.size(), 'campaigns.size()==2');
        Test.stopTest();
    }

      @isTest
    static void deleteCampaignstest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
       List<Campaign> campaigns = 
         [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                        UAF_DatiAggiuntivi__c 
                    FROM Campaign Where RecordTypeId =:recordType];
       GUA_GestionCampagnaCnt.deleteCampaigns(campaigns[0].Id);
        System.debug('campaigns '+campaigns);
        System.assertEquals(2, campaigns.size(), 'campaigns.size()==2');
        Test.stopTest();
    }

    
      @isTest
    static void deleteCampaignsExceptiontest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
       List<Campaign> campaigns = 
         [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                        UAF_DatiAggiuntivi__c 
                    FROM Campaign Where RecordTypeId =:recordType];
        String ids='';
       GUA_GestionCampagnaCnt.deleteCampaigns(ids);
        System.debug('campaigns '+campaigns);
        System.assertEquals(2, campaigns.size(), 'campaigns.size()==2');
        Test.stopTest();
    }
    
      @isTest
    static void getTotalCounttest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
       List<Campaign> campaigns = 
         [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                        UAF_DatiAggiuntivi__c 
                    FROM Campaign Where RecordTypeId =:recordType];

       GUA_GestionCampagnaCnt.getTotalCount();
        System.debug('campaigns '+campaigns);
        System.assertEquals(2, campaigns.size(), 'campaigns.size()==2');
        Test.stopTest();
    }
}