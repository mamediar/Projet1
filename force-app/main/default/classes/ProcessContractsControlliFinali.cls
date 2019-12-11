public class ProcessContractsControlliFinali 
{
	@invocableMethod
    public static List<FlagControlli> ControlliFinali (List<Input> inse)
    {
     	
        List<Contract> accolli = new List<Contract>();
        List<Contract> nonAccolli = new List<Contract>();
        SFALotto__c lot = inse[0].lotto;
        List<Contract> contratti = inse[0].contracts;
        List<FlagControlli> lres = new List<FlagControlli>();
        FlagControlli res = new FlagControlli();
        res.isAccolli = true;
        system.debug(contratti + '---------' + lot);
            for(Contract c : contratti)
            {
                system.debug('TEST-------' + c);
                if(c.FlagAccollo__c == 0)
                {
                    res.isAccolli = false;
                    nonAccolli.add(c);
                }
                else
                {
                    accolli.add(c);
                }
            }
        if(!res.isAccolli)
        {
           	system.debug('Prima CHIAMATA OCS');
            system.debug(nonAccolli);
            OCSCambioStatoFilterList listResult;
            listResult = OCSCambioStatoPraticaInvoker.multiInvoke(nonAccolli,'S');
			system.debug(listResult);
            List<ContractResult> listaOk = listResult.ListaOk;
            List<ContractResult> listaKO = listResult.ListaKO;
            system.debug(listaOK);
            system.debug('LISTAKOOOOOOOO' + listaKO);
            List<Contract> listaContrattiOK = new List<Contract>();
            List<Contract> listaUpdate = new List<Contract>();
            for(ContractResult cr: listaOK)
            {
                listaContrattiOK.add(cr.contract);
            }
            system.debug('LISTAOKKKKKKK' + listaContrattiOK);
            List<RecordType> recordTypeId = [SELECT Id FROM RecordType where DeveloperName = 'SFA_Archiviazione_Lotti' AND SobjectType = 'Case']; 
            //List<RecordType> recordTypeId = [SELECT Id FROM RecordType where DeveloperName = 'SFA_Archiviazione_Lotti_Pratiche_Smarrite' AND SobjectType = 'Case'];
            if(integer.valueof(lot.BranchId__c) >= 800 && integer.valueof(lot.BranchId__c) <= 999)
                {
                    Case caseOutsourcer = new Case();
                    List<Group> ownerId = GroupUtils.getQueueList('Ufficio_DCR_AV_PPC');
                    caseOutsourcer.Subject = 'Ricerca Contratti Mancanti';
                    caseOutsourcer.categoria_riferimento__r = new XCS_Categoria__c(External_Id__c = 'AT0062');
                    //caseOutsourcer.ActivityType__c = 'PRAMANOUT';
                    caseOutsourcer.RecordTypeId = recordTypeId[0].Id;
                    caseOutsourcer.OwnerId = ownerId[0].Id;
                    insert caseOutsourcer;
                    for(Contract c: listaContrattiOK)
                    {
                       c.Case__c = caseOutsourcer.Id;
                       c.WorkStatus__c = '404';
                       c.DataSmarrimento__c = System.today();
                       listaUpdate.add(c);
                    }
                    for(Contract c: accolli)
                    {
                       c.Case__c = caseOutsourcer.Id;
                       c.WorkStatus__c = '404';
                       c.DataSmarrimento__c = System.today();
                       listaUpdate.add(c);
                    }
                }
            else
            	{
                    Case caseContrattiMancanti = new Case();
                    Case caseAccolliMancanti = new Case();
                    String ownerWhere = 'F' + lot.BranchId__c;
                    List<Group> ownerId = GroupUtils.getQueueList(ownerWhere);
                    
                    if(accolli.size() > 0) 
                    {	
                        caseAccolliMancanti.Subject = 'Ricerca Accolli Mancanti';
                        caseAccolliMancanti.categoria_riferimento__r = new XCS_Categoria__c(External_Id__c = 'AT0095');
                        //caseAccolliMancanti.ActivityType__c = 'ACCMAN';
                        caseAccolliMancanti.RecordTypeId = recordTypeId[0].Id;
                        caseAccolliMancanti.OwnerId = ownerId[0].Id;
                        insert caseAccolliMancanti;
                        for(Contract c: accolli)
                        {
                           c.Case__c = caseAccolliMancanti.Id;
                           c.WorkStatus__c = '404';
                           c.DataSmarrimento__c = System.today();
                           listaUpdate.add(c);
                        }
                    }
                    if(listaContrattiOK.size() > 0)
                    {
                        caseContrattiMancanti.Subject = 'Ricerca Contratti Mancanti';
                        caseContrattiMancanti.categoria_riferimento__r = new XCS_Categoria__c(External_Id__c = 'AT0062');
                        //caseContrattiMancanti.ActivityType__c = 'PRAMAN';
                        caseContrattiMancanti.RecordTypeId = recordTypeId[0].Id;
                    	caseContrattiMancanti.OwnerId = ownerId[0].Id;
                        insert caseContrattiMancanti;
                        system.debug('--------' + System.today());
                        for(Contract c: listaContrattiOK)
                        {
                           c.Case__c = caseContrattiMancanti.Id;
                           c.WorkStatus__c = '404';
                           c.DataSmarrimento__c = System.today();
                           listaUpdate.add(c);
                        }
                    }
                    if(listaKO.size() > 0)
                    {
                       res.isOcsKo = true;
                       for(ContractResult cr : listaKO)
                       {
                       	res.messLisError += '-' + cr.contract.Barcode__c + '  ' + cr.response.ebavaradpv1Response.mfterr_OMSFERR_OCCURS[0].msferr_DESCRIZIONE + '\n';    
                       }
                        
                    }
                       
               }
               Update listaUpdate; 
         }
      	lres.add(res);
		return lres;
    }
     
		public class FlagControlli{
        @invocablevariable
        public boolean isAccolli;
        @invocablevariable
        public boolean isOcsKo = false;
        @invocablevariable
        public String messLisError = '';    
        }
    public class Input{
        @invocablevariable
        public List<Contract> contracts;
        @invocablevariable
        public SFALotto__C lotto;
    }
}