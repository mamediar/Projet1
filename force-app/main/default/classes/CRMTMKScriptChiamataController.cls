public class CRMTMKScriptChiamataController {
  public static final String EDI0C = 'EDI0C';
    @auraEnabled
    public Static User Name(){
        
        String UserID = Userinfo.getUserId();
        return [SELECT Name from User where id =:UserID];
    }
    @auraEnabled
    public Static string Script(String option, Id campa, String actioncode, String codTMK, Date startDate, Date endDate, string tipoCamp){
        List<Product2> a = [SELECT RSS_External_Id__c, Parent__c FROM Product2 where id =: campa];        
      	String scriptForCase;
        String prodottoCampaign = a[0].RSS_External_Id__c;
     	system.debug(prodottoCampaign+ ' '+actioncode+ ' '+codTMK+' '+ startDate + ' '+ endDate );
        if(tipoCamp == 'TMKPP'){
      scriptForCase = [SELECT Text__c FROM XCS_Script__c where 
      CodProdLvl2__c =:prodottoCampaign and ActionCode__c =:actioncode 
      and ActionCodelvl2__c =:codTMK and StartDate__c <=: startDate and EndDate__c >=: endDate and StartDate__c <= TODAY and EndDate__c >= TODAY limit 1].Text__c;}
        else{
           scriptForCase = [SELECT Text__c FROM XCS_Script__c where 
      CodProdLvl2__c =:prodottoCampaign and ActionCode__c =:actioncode 
       and StartDate__c <=: startDate and EndDate__c >=: endDate and StartDate__c <= TODAY and EndDate__c >= TODAY limit 1].Text__c;
        } 
        return scriptForCase;
      
    }
    @AuraEnabled
    public static String preScript(String codPromotion){
      String script;
      system.debug('codice pormo lato apex   '+codPromotion);
        if(codPromotion != EDI0C) script = XCSScriptUtil.preScript(codPromotion); 
        if(codPromotion == EDI0C) script = XCSScriptUtil.scriptEDI0C(codPromotion);   
        return script;
    }
    @AuraEnabled
    public static string dispositionControllForAccount(String idAcc, String typeRecord, List<String> mapForDisp){
      System.debug('acc id '+ idAcc + ' record type ' + typeRecord+ 'disp ' + mapForDisp);
      List<Case> casePrecedenti = [SELECT Disposition__r.External_Id__c from Case where AccountId =: idAcc 
      and LastModifiedDate >LAST_N_MONTHS:6 and CampaignId__r.RecordTypeId =:typeRecord 
      and Disposition__r.External_Id__c in:mapForDisp order by LastModifiedDate desc ];
      System.debug('disp sel '+ casePrecedenti[0].Disposition__r.External_Id__c);
      return casePrecedenti[0].Disposition__r.External_Id__c;
    }
    
}