public class ArchiviazioneLottiPDFController {
    @TestVisible private Case currentCase {get;set;}
    @TestVisible private String ocsIdLotto;
    @TestVisible private final static Integer COLUMNNUMBER=6;
    @TestVisible private final static List<String> MONTHS=new List<String>{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
    public String shipDate {get;set;}
    public String lotBarcode {get;set;}
    public String idLotto {get;set;}
    public List<Integer> copyCounter {get;set;}
    public Integer liquidati {get;set;}
    public Integer respintiRitiratiStornati {get;set;}
    public Integer tot{get;set;}
    public List<List<String>> idLiquidati{get;set;}
    public List<List<String>> idResRitStor{get;set;}
    
    public ArchiviazioneLottiPDFController(ApexPages.StandardController std){
        this.currentCase = (Case)std.getRecord();
    }
    public void init(){
        this.copyCounter=new List<Integer>();
        this.copyCounter.add(1);
        this.copyCounter.add(2);
        this.idLotto=this.currentCase.SFALotto__c;
        
        SFALotto__c[] sfaLot=[select OCSLottoId__c,LotBarcode__c
                          from SFALotto__c
                          where id = :idLotto];
        this.ocsIdLotto=sfaLot!=null?(String)(sfaLot[0].get('OCSLottoId__c')):' ';
        this.lotBarcode=sfaLot!=null?(String)(sfaLot[0].get('LotBarcode__c')):' ';
        
        this.shipDate=getShipDate();
        
        AggregateResult[] queryResultNum=[SELECT count(Id), Status
                          from Contract 
                          where SFALotto__r.OCSLottoId__c= :ocsIdLotto
                          group by Status];
        Contract[] queryLiquidati=[SELECT ContractNumber__c
                                         from Contract
                                         where SFALotto__r.OCSLottoId__c= :ocsIdLotto and Status='LI'];
        Contract[] queryResRitStor=[SELECT ContractNumber__c
                                         from Contract
                                         where SFALotto__r.OCSLottoId__c= :ocsIdLotto 
                                         and Status!='LI'];
        
        this.idResRitStor=this.getIdResRitStor(queryResRitStor);
        this.idLiquidati=this.getIdLiquidati(queryLiquidati);
        this.liquidati=this.getLiquidati(queryResultNum);
        this.respintiRitiratiStornati=this.getRespintiRitiratiStornati(queryResultNum);
        this.tot=this.liquidati+this.respintiRitiratiStornati;
    }
    
    public String getShipDate(){
        SFALotto__c[] s=[select ShippingDate__c
					from SFALotto__c
					where OCSLottoId__c= :ocsIdLotto];
        String res = (s[0].get('ShippingDate__c')!=null ? s[0].get('ShippingDate__c').toString() : ' ');
        
        String[] temp=res.split(' ');
        for(Integer i=0;i<MONTHS.size();i++){
            if(s[0].get('ShippingDate__c')==null){
                break;
            }
            if(temp[1].equalsIgnoreCase(MONTHS[i])){
                temp[1]=(i+1)+'';
                break;
            }
        }
        res=s[0].get('ShippingDate__c')==null?' ':temp[5]+'-'+temp[1]+'-'+temp[2];
        return res;
    }
    
    public List<List<String>> getIdLiquidati(Contract[] dati){
        List<List<String>> res=new List<List<String>>();
        List<String> temp=new List<String>();
        Integer i=0;
        for(Contract c:dati){
            if(Math.mod(i, COLUMNNUMBER)==0){
                temp=new List<String>();
            }
            temp.add((String)c.get('ContractNumber__c'));
            if(Math.mod(i, COLUMNNUMBER)==COLUMNNUMBER-1 || i==dati.size()-1){
                res.add(temp);
            }
            i++;
        }
        return res;
    }
    
    public List<List<String>> getIdResRitStor(Contract[] dati){
        List<List<String>> res=new List<List<String>>();
        List<String> temp=new List<String>();
        Integer i=0;
        for(Contract c:dati){
            if(Math.mod(i, COLUMNNUMBER)==0){
                temp=new List<String>();
            }
            temp.add((String)c.get('ContractNumber__c'));
            if(Math.mod(i,COLUMNNUMBER)==COLUMNNUMBER-1 || i==dati.size()-1){
                res.add(temp);
            }
            i++;
        }
        return res;
    }
    
    public Integer getLiquidati(AggregateResult[] queryResult){
        Integer res=0;
        for(AggregateResult ar:queryResult){
            if(((String)ar.get('Status')).equals('LI')){
                res=((Integer)ar.get('expr0'));
            }
        }
        return res;
    }
    
    public Integer getRespintiRitiratiStornati(AggregateResult[] queryResult){
        Integer res=0;
        for(AggregateResult ar:queryResult){
            if(!((String)ar.get('Status')).equals('LI')){
                res+=(Integer)ar.get('expr0');
            }
        }
        return res;
    }
}