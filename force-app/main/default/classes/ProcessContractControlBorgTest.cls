@isTest
public class ProcessContractControlBorgTest {
    @testSetup
    static void setup()
    {
     	SFALotto__c lotto1 = new SFALotto__c();
     	lotto1.Name = 'TEST';
        lotto1.BranchId__c = '700';
        lotto1.OCSLottoId__c = '50000';
        insert lotto1;
        Contract con1 = new Contract();
        Contract con2 = new Contract();
        Account acc = new Account();
        acc.Name = 'FOSCOLO';
        insert acc;

        con1.SFALotto__c = lotto1.id;
        con1.AccountId = acc.Id;
        con1.ContractNumber__c = '000000000001';
        con1.Procedure__c = 'CO';
        con2.SFALotto__c = lotto1.id;
        con2.AccountId = acc.Id;
        con2.ContractNumber__c = '000000000002';
        con2.Procedure__c = 'CO';
        insert con1 ;
        insert con2 ;
        SFA_Lot_anomaly__c LotAnomaly = new SFA_Lot_anomaly__c();
        LotAnomaly.Barcode_cover__c = 'CO000000000005';
        LotAnomaly.Barcode_contract__c = 'CO000000000001';
        LotAnomaly.isCancelled__c = false;
        LotAnomaly.Ocs_lot_id__c = '700';
        insert LotAnomaly ;
    }

    @isTest
    static void AllYes()
    {
        SFALotto__c lot = [select id,OCSLottoId__c from SFALotto__c where Name ='TEST'];
        List<ProcessContractControlBorg.Input> listInp = new List<ProcessContractControlBorg.Input>();
        ProcessContractControlBorg.Input inp = new ProcessContractControlBorg.Input();
        List<ProcessContractControlBorg.FlagControlli> listControlli ;
        inp.q1 = 'SI';
        inp.q2 = 'SI';
		    inp.q3 = 'SI';
        inp.contratto = [select id, q_folder__c,q_sign__c,q_contract__c,SFALotto__c,WorkStatus__c,Barcode__c from Contract where Barcode__c = 'CO000000000001'];
        inp.oldBarcode = 'CO000000000001';
        inp.contractBarcode = 'CO000000000001';
        inp.lotto = lot;
        listInp.add(inp);
        listControlli = ProcessContractControlBorg.ControlliBorg(listInp);
        system.assert(listControlli[0].checkSeeMessagge == false);
        List<SFA_Lot_anomaly__c> anomalytest = [select id,isCancelled__c from SFA_Lot_anomaly__c where Barcode_contract__c = :inp.oldBarcode ];
        system.assert(anomalytest[0].isCancelled__c == true);
    }
    @isTest
    static void FirstNo()
    {
        SFALotto__c lot = [select id,BranchId__c,OCSLottoId__c from SFALotto__c where Name ='TEST'];
        List<ProcessContractControlBorg.Input> listInp = new List<ProcessContractControlBorg.Input>();
        ProcessContractControlBorg.Input inp = new ProcessContractControlBorg.Input();
        List<ProcessContractControlBorg.FlagControlli> listControlli ;
        inp.q1 = 'NO';
        inp.q2 = 'NO';
        inp.q3 = 'NO';
        inp.contratto = [select id, q_folder__c,q_sign__c,q_contract__c,SFALotto__c,WorkStatus__c,Barcode__c from Contract where Barcode__c = 'CO000000000001'];
        inp.oldBarcode = 'CO000000000001';
        inp.contractBarcode = '';
        inp.lotto = lot;
        listInp.add(inp);
        listControlli = ProcessContractControlBorg.ControlliBorg(listInp);
        system.assert(listControlli[0].checkSeeMessagge == true);
        List<SFA_Lot_anomaly__c> anomalytest = [select id,isCancelled__c from SFA_Lot_anomaly__c where Barcode_cover__c = :inp.oldBarcode ];
        system.assert(anomalytest[0].isCancelled__c == false);
		    system.assert(listControlli[0].message.length() > 0);

    }
    @isTest
    static void SecondNo()
    {
        SFALotto__c lot = [select id,BranchId__c,OCSLottoId__c from SFALotto__c where Name ='TEST'];
        List<ProcessContractControlBorg.Input> listInp = new List<ProcessContractControlBorg.Input>();
        ProcessContractControlBorg.Input inp = new ProcessContractControlBorg.Input();
        List<ProcessContractControlBorg.FlagControlli> listControlli ;
        inp.q1 = 'SI';
        inp.q2 = 'NO';
	     	inp.q3 = 'NO';
        inp.contratto = [select id, q_folder__c,q_sign__c,q_contract__c,SFALotto__c,WorkStatus__c,Barcode__c from Contract where Barcode__c = 'CO000000000001'];
        inp.oldBarcode = 'CO000000000001';
        inp.contractBarcode = 'CO000000000005';
        inp.lotto = lot;
        listInp.add(inp);
        listControlli = ProcessContractControlBorg.ControlliBorg(listInp);
        system.assert(listControlli[0].checkSeeMessagge == true);
        system.assert(listControlli[0].message.length() > 0);
        List<SFA_Lot_anomaly__c> anomalytest = [select id,isCancelled__c from SFA_Lot_anomaly__c where Barcode_cover__c = :inp.oldBarcode ];
        system.assert(anomalytest[0].isCancelled__c == false);

    }
    @isTest
    static void ThirdNo()
    {
        SFALotto__c lot = [select id,BranchId__c,OCSLottoId__c from SFALotto__c where Name ='TEST'];
        List<ProcessContractControlBorg.Input> listInp = new List<ProcessContractControlBorg.Input>();
        ProcessContractControlBorg.Input inp = new ProcessContractControlBorg.Input();
        List<ProcessContractControlBorg.FlagControlli> listControlli ;
        inp.q1 = 'SI';
        inp.q2 = 'SI';
	     	inp.q3 = 'NO';
        inp.contratto = [select id, q_folder__c,q_sign__c,q_contract__c,SFALotto__c,WorkStatus__c,Barcode__c from Contract where Barcode__c = 'CO000000000001'];
        inp.oldBarcode = 'CO000000000001';
        inp.contractBarcode = 'CO000000000005';
        inp.lotto = lot;
        listInp.add(inp);
        listControlli = ProcessContractControlBorg.ControlliBorg(listInp);
        system.assert(listControlli[0].checkSeeMessagge == false);
        system.assert(listControlli[0].message.length() == 0);
        List<SFA_Lot_anomaly__c> anomalytest = [select id,isCancelled__c from SFA_Lot_anomaly__c where Barcode_cover__c = :inp.oldBarcode AND Barcode_contract__c = :inp.contractBarcode];
        system.assert(anomalytest[0].isCancelled__c == true);

    }
}