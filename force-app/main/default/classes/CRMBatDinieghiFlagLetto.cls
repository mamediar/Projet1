global class CRMBatDinieghiFlagLetto  implements  Database.AllowsCallouts, Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){
        // query limitata a 100 records perchè WS dinieghiSDDflagLettura non puo' processare piu' di 100 dinieghi insieme
        String query = 'SELECT Id, IsSendOCS__c, Progressivo__c, ProgreMan__c ';
        query+= 'FROM Mandati_SDD__c WHERE IsProcessato__c = true AND IsSendOCS__c = false LIMIT 100000';
        return Database.getQueryLocator(query);
    }

   


    global void execute(Database.BatchableContext bc,List<Mandati_SDD__c> listMandati) {
        System.debug('CRMBatDinieghiFlagLetto executing');
        if (listMandati!=null) {
             List<OCSDinieghiSDDFlagLetturaRequest.DiniegoSDDFlagLetturaDTO> listaFlag = new List<OCSDinieghiSDDFlagLetturaRequest.DiniegoSDDFlagLetturaDTO>();
            for (Mandati_SDD__c man:listMandati) {     
                OCSDinieghiSDDFlagLetturaRequest.DiniegoSDDFlagLetturaDTO addMan = new OCSDinieghiSDDFlagLetturaRequest.DiniegoSDDFlagLetturaDTO();               
                addMan.canomanProgressivo = man.Progressivo__c;
                addMan.canomanProgreMan = man.ProgreMan__c;               
                listaFlag.add(addMan);
            }       
            
            OCSDinieghiSDDFlagLetturaRequest req=new OCSDinieghiSDDFlagLetturaRequest(listaFlag);        
            OCSDinieghiSDDFlagLetturaResponse flagRes = OCSDinieghiSDDFlagLetturaInvoker.callFlagLetturaSDD(req);
            String esitoChiamata = flagRes.dinieghiSDDFlagLetturaResponse.esito;
            String erroreCanomanProgressivo = flagRes.dinieghiSDDFlagLetturaResponse.erroreCanomanProgressivo;    
            String erroreCanomanProgreMan = flagRes.dinieghiSDDFlagLetturaResponse.erroreCanomanProgreMan;  
            if ('OK'.equals(esitoChiamata)) {
                for (Mandati_SDD__c man:listMandati) {  
                    man.IsSendOCS__c =true;
                }
                update listMandati;
            }
            
        }
    }

    global void finish(Database.BatchableContext bc){
		system.debug('-- Class Name: CRMBatDinieghiFlagLetto - Method Name: finish'); 

        CRMBatLoadDinieghi sch = new CRMBatLoadDinieghi();
        String CRON = '0 55 7 * * ?';
        if (!Test.isRunningTest()) {
            String nomeJob = 'Caricamento Dinieghi '+(system.today()+1);
            List<CronTrigger> cronTrigger = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE  CronJobDetail.Name =:nomeJob];
            if (cronTrigger==null) {
                System.Schedule(nomeJob, CRON, sch);
            }
        }

    }

}