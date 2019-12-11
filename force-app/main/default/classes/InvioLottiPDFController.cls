public class InvioLottiPDFController {
    @TestVisible private Case currentCase {get;set;}
    @TestVisible private final static List<String> MONTHS=new List<String>{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
    
    public List<Integer> copyCounter {get;set;}
    public String shipDate {get;set;}
    public List<String> idsOCSLotti {get;set;}
    public Integer nOfBoxes {get;set;}
    public Account idm {get;set;}
    
    public InvioLottiPDFController(ApexPages.StandardController std){
        this.currentCase = (Case)std.getRecord();
    }
    
    public void init(){
        this.copyCounter=new List<Integer>{1,2};
        this.idsOCSLotti=getIdsLotti();
        this.nOfBoxes=this.idsOCSLotti.size();
        this.shipDate=getShipDate();
        this.idm=[	SELECT name,shippingstreet,shippingpostalcode,shippingcity,shippingstate,description
					FROM Account
					where name='idm group'];
    }
    
    public List<String> getIdsLotti(){
        String id=currentCase.Id;
        List<String> res=new List<String>();
        SFALotto__c[] query=[select ocslottoid__c
							from sfalotto__c
							where CaseId__c=:id and Status__c='3'];
        for(SFALotto__c l:query){
            res.add((String)l.get('OCSLottoId__c'));
        }
        return res;
    }
    
    public String getShipDate(){
        string[] temp=Date.today().format().split('/');
        return temp[2]+'-'+temp[1]+'-'+temp[0];
    }
    
    
}