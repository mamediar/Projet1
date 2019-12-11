public class CRMTMKMasterScriptEdit {
    @AuraEnabled
    public static List<CRMTelemarketingTripletta> listScriptInMaster(String fileTMK ){
        List<CRMTelemarketingTripletta> listTrip = new List<CRMTelemarketingTripletta>();
        List<CRMTelemarketingTripletta> listTrue = new List<CRMTelemarketingTripletta>();
        List<CRMTelemarketingTripletta> listFalse = new List<CRMTelemarketingTripletta>();
        Set<CRMTelemarketingTripletta> a= XCSScriptUtil.MapTriplettaScriptForMasterCampaign(fileTMK);
        system.debug(a);
        for(CRMTelemarketingTripletta f:a){
            if(f.flag != false){
               listTrue.add(f);
            }
            else {
                listFalse.add(f);
            }
        }
        if(listFalse.size() < 1){
            return listTrue;
        }
        else{
        for(CRMTelemarketingTripletta k:listTrue){
            for(CRMTelemarketingTripletta h:listFalse){
                if(k.codiceTMK != h.codiceTMK){
                    listTrip.add(k);
                    
                }
            }
        }
        for(CRMTelemarketingTripletta u:listFalse){
            listTrip.add(u);
        }
		system.debug(listTrip);
        return listTrip;}
    }
}