//----------------------------------------------------------------------
    //-- - Author       : Aminata GUEYE
    //-- - Date         : 14/10/2019
    //-- - Class  : GUA_AnnullaChiamateOutboundTest
    //----------------------------------------------------------------------
@isTest
public class GUA_AnnullaChiamateOutboundTest {
    public List<Case> casList = new List<Case>();
    public List<Case> delRec = new List<Case>();
     @TestSetup
    static void makeData(){
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        
        List<Campaign> campaigns = new List<Campaign>{
        new Campaign(StartDate= Date.today(),UAF_DatiAggiuntivi__c='Aminata,Diop,Ba',
        EndDate=Date.today(),
        UAF_Script__c='ff', Name='Campagna-Neuf',RecordTypeId=recordType),
        new Campaign(StartDate=Date.today(),UAF_DatiAggiuntivi__c='Gueye,Dia,Gueye',
        EndDate=Date.today(),UAF_Script__c='test', Name='Campagna',RecordTypeId=recordType)
        };
        insert campaigns;
        Case cas = new Case(CodiceDealer__c='400000',CampaignId__c=campaigns[0].Id);
        insert cas;
    }

    
    @isTest
    static void getCampNametest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        
        Map<String, Object> campaigns=GUA_AnnullaChiamateOutboundCnt.getCampName();
        System.debug('campaigns '+campaigns);
        System.assertEquals(2, campaigns.size(), 'campaigns.size()==2');
        Test.stopTest();
    }
    @isTest
    static void fetchCasetest(){
        Test.startTest();
        String codi='400000';
        String campagna='Campagna-Neuf';
        List<Case> cases=GUA_AnnullaChiamateOutboundCnt.fetchCase(codi,campagna);
         System.debug('cases '+cases);
         System.assertEquals(1, cases.size(), 'cases.size()==1');

        Test.stopTest();
    }
    @isTest
    static void delSlctRectest(){
        Test.startTest();
        GUA_AnnullaChiamateOutboundCnt clc = new GUA_AnnullaChiamateOutboundCnt();
        List<String> slctRec=new list<String>{'00167318','Campagna-Ma','417768','15032009'};
        clc.delRec = [SELECT Id FROM Case WHERE Id IN: slctRec ];
         List<Case> cases=GUA_AnnullaChiamateOutboundCnt.delSlctRec(slctRec);
         System.debug('cases '+cases);
        Test.stopTest();
        
    }
}