public class ProcessContractControlBorg {
    @invocableMethod
    public static List<FlagControlli> ControlliBorg (List<Input> inse)
    {
        // è stato inizializzato un nuovo oggetto per fare l'update 
        // in quanto le picklist di oggetti recupati da una query standard del flows genera errori 
        Contract contract = new Contract();
        List<FlagControlli> lres = new List<FlagControlli>();
        Input ins = new Input();
        FlagControlli res = new FlagControlli();
        system.debug('lista--------' + inse);
        ins = inse[0]; 
        system.debug('singolo------' + ins);
        if(ins.contratto.Id != null){
            ins.contratto.q_contract__c = ins.q1;
            ins.contratto.q_folder__c = ins.q2;
            ins.contratto.q_sign__c = ins.q3;
            contract.q_contract__c = ins.q1;
            contract.q_folder__c = ins.q2;
            contract.q_sign__c = ins.q3;
            contract.Id = ins.contratto.Id;
            system.debug('++++++++++++++' + ins.contratto);
            system.debug('++++++++++++++' + json.serialize(ins.contratto));   
            // system.debug('secondoStep' + ins.contratto);
        Update contract;
        }
        list<SFA_Lot_anomaly__c> listLotAnomaly = new list<SFA_Lot_anomaly__c>();
        SFA_Lot_anomaly__c lotAnomaly = new SFA_Lot_anomaly__c();
       	if(ins.q1.equals('SI') && ins.q2.equals('SI') && (ins.q3.equals('SI')|| ins.q3.equals('SI,Ma Fotocopiate')))
        {
            listLotAnomaly = [SELECT Id, Barcode_cover__c, Barcode_contract__c, isCancelled__c,Ocs_lot_id__c FROM SFA_Lot_anomaly__c where Barcode_contract__c = :ins.oldBarcode];
            for(SFA_Lot_anomaly__c f : listLotAnomaly)
            {
            	f.isCancelled__c = true;
            }
            update listLotAnomaly;
        }
		else
        {
            lotAnomaly.Barcode_cover__c = ins.oldBarcode;
            lotAnomaly.Barcode_contract__c = (ins.contractBarcode == null ? '' : ins.contractBarcode);
            lotAnomaly.Ocs_lot_id__c = ins.lotto.OCSLottoId__c ;
            lotAnomaly.isCancelled__c = false;
            insert lotAnomaly;
            if(ins.q1.equals('NO') || ins.q2.equals('NO'))
            {
                if(ins.q1.equals('NO'))
                {
                    listLotAnomaly = [SELECT Id, Barcode_cover__c,Ocs_lot_id__c, Barcode_contract__c, isCancelled__c FROM SFA_Lot_anomaly__c where Barcode_contract__c = :ins.oldBarcode AND isCancelled__c = false];
                    if(listLotAnomaly != null && listLotAnomaly.size() > 0)
                    {
                        res.checkSeeMessagge = true;
                        res.message += '-Il contratto ' + listLotAnomaly[0].Barcode_contract__c + ' è stato trovato nella cover ' + listLotAnomaly[0].Barcode_cover__c + ' del lotto ' + listLotAnomaly[0].Ocs_lot_id__c ;
                    }
                }
                
                if(ins.q2.equals('NO') && (ins.contractBarcode != null &&  ins.contractBarcode != ''))
                {
                    listLotAnomaly = [SELECT Id, Barcode_cover__c,Ocs_lot_id__c, Barcode_contract__c, isCancelled__c FROM SFA_Lot_anomaly__c where Barcode_cover__c = :ins.contractBarcode AND isCancelled__c = false];
                    if(listLotAnomaly != null && listLotAnomaly.size() > 0)
                    {
                        res.checkSeeMessagge = true;
                        res.message += '\n-la cover del contratto ' + listLotAnomaly[0].Barcode_cover__c + ' è già stata letta con il lotto ' +  listLotAnomaly[0].Ocs_lot_id__c ;
                    }
                }
            }
            else
            {
                lotAnomaly.isCancelled__c = true;
                update lotAnomaly;
            }
        }
        lres.add(res);
        return lres;
    }
     public class FlagControlli{
        @invocablevariable
        public String message = '';
        @invocablevariable
        public Boolean checkSeeMessagge = false;
        }
    public class Input{
        @invocablevariable
        public Contract contratto;
        @invocablevariable
        public String q1;
        @invocablevariable
        public String q2;
        @invocablevariable
        public String q3;
        @invocablevariable
        public String oldBarcode;
        @invocablevariable
        public String contractBarcode;
        @invocablevariable
        public SFALotto__c lotto;
    }
}