public class tableScriptForCampaignController {
    @AuraEnabled
    public static List<Map<String,String>> scriptForCamapign(Id prodId,String actionCode, String codTMK, String tipoCamp) {
      return campaignUtils.listScriptInTable(prodId, actionCode, codTMK, tipoCamp);        
    }
}