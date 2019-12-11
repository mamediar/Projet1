public class CRMRetentionPrestitiPreworkController 
{
    
    @AuraEnabled
    public static wrapObj completaAttivita(String noteUtente,String esitoCliente, String valoreCliente,String customerId,String customerEmail,String customerCellulare,boolean flagPrivacy,String fasciaOraria,List<CRMRetentionPrestitiAction.PraticheRetention> listRetention)
    {
        if(String.isBlank(customerEmail))
            customerEmail = '';
        if(String.isBlank(customerCellulare))
            customerCellulare = '';
        boolean res = true;
        boolean isAccountToUpdate = false;
        boolean retentionNonPossibile = false;
        String notePratiche = '';
        String note = '';
        List<String> listNoteValue = new List<String>();
        List<String> listOCSNoteValue = new List<String>();
        //RecordType = 
        Account cliente = AccountUtils.getAccountFromId(customerId);
        if(String.isBlank(cliente.PersonEmail))
            cliente.PersonEmail = '';
        if(String.isBlank(cliente.Telefono_Cellulare__c))
            cliente.Telefono_Cellulare__c = '';
        List<CRM_Retention__c> listRetentionToInsert = new List<CRM_Retention__c>();
        String messToast = '';
        Account a = new Account(id = customerId);
        Case c = new Case();
        if(listRetention.size() > 0 )
        {
            if(flagPrivacy != null)
            {
                if(cliente.Privacy_SMS__pc != flagPrivacy)
                {
                    a.Privacy_SMS__pc = flagPrivacy;
                    isAccountToUpdate = true;
                }
            }
            else
            {
                messToast += CaseUtils.PRIVACY_NON_SELEZIONATA;
                res = false;
            }
            if(!customerEmail.equalsIgnoreCase(cliente.PersonEmail))
            {
                if(ValidationUtils.isEmailValida(customerEmail))
                {
                    a.PersonEmail = customerEmail;
                    isAccountToUpdate = true;
                }
                else
                {
                    messToast += CRMRetentionUtil.EMAILNONCONFORME;
                    res = false;
                }
            }
            if(!customerCellulare.equalsIgnoreCase(cliente.Telefono_Cellulare__c))
            {
                if(ValidationUtils.isTelefonoValido(customerCellulare))
                {
                    a.Telefono_Cellulare__c = customerCellulare;
                    isAccountToUpdate = true;
                }
                else
                {
                    messToast += CaseUtils.TELEFONO_NON_CONFORME;
                    res = false;
                }
            }
            if(String.isNotBlank(fasciaOraria))
            {
                String[] fascia = fasciaOraria.split('\\-');
                c.CC_FasciaContattoDalle__c = integer.valueOf(fascia[0]);
                c.CC_FasciaContattoAlle__c = integer.valueOf(fascia[1]);
            }
            else
            {
                res = false;
                messToast += CRMRetentionUtil.FASCIANONSELEZIONATA;
            }
        }
        else
        {
            res = false;
            messToast = CRMRetentionUtil.NESSUNA_PRATICA_TROVATA;
        }
        if(res)
        {
            c.TentativoNum__c = 0;
            c.Type = XCSCompassConstants.CASETYPECRM;
            c.Accountid = cliente.id;
            c.product__c = Product2Util.getProductFromExternalId(Product2Util.RETENTIONPRODUCTCODE).id;
            c.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.BACKOFFICEINBOUNDCATEGORYCODE);
            c.Disposition__r = XCS_DispositionUtils.getInstanceWithExternalID(XCS_DispositionUtils.RETENTION_INSERITA); 
            c.TentativoNum__c = 0;   
            c.recordtypeid = RecordtypeUtil.getCaseRecordType(RecordtypeUtil.RETENTIONCLIENTE);
            if('BAD'.equalsIgnoreCase(esitoCliente))
            {
                c.Subject = CRMRetentionUtil.CASE_RETENTION_PRESTITI_BAD_SUBJECT;
                c.ProcessType__c = CRMRetentionUtil.CASE_RETENTION_PRESTITI_PROCESSTYPE_RETENTIONBAD;
                c.ownerId = GroupUtils.getQueue(CRMRetentionUtil.QUEUE_RETENTION_EA_BAD_NAME).id;
            }	
            else
            {
                c.Subject = CRMRetentionUtil.CASE_RETENTION_PRESTITI_SUBJECT;
                c.ProcessType__c = CRMRetentionUtil.CASE_RETENTION_PRESTITI_PROCESSTYPE_RETENTIONOK;
                c.ownerId = GroupUtils.getQueue(CRMRetentionUtil.QUEUE_RETENTION_EA_NAME).id;
            }
            For(CRMRetentionPrestitiAction.PraticheRetention obj : listRetention)
            {
                if(! 'SI'.equalsIgnoreCase(obj.partner))
                {
                    listRetentionToInsert.add(
                        new CRM_Retention__c(
                            loanType__c = obj.tipoPratica,
                            loanNumber__c = obj.numPratica,
                            loanStatus__c = obj.statoPratica,
                            loanStatusAttribute__c = obj.attributoPratica,
                            firstDueDate__c = date.valueOf(obj.dataPrimaScadenza.substring(0,4) + '-' + obj.dataPrimaScadenza.substring(4,6) + '-' + obj.dataPrimaScadenza.substring(6,8)),
                            lastDueDate__c = date.valueOf(obj.dataUltimaScadenza.substring(0,4) + '-' + obj.dataUltimaScadenza.substring(4,6) + '-' + obj.dataUltimaScadenza.substring(6,8)),
                            productCode__c = obj.codProdotto,
                            productDescription__c = obj.desProdotto,
                            repaymentMode__c = obj.modalitaPagamento,
                            financedAmount__c = Integer.valueOf(obj.importoFinanziato),
                            totalAmount__c = Integer.valueOf(obj.montante),
                            liquidDate__c = date.valueOf(obj.dataLiquidazione.substring(0,4) + '-' + obj.dataLiquidazione.substring(4,6) + '-' + obj.dataLiquidazione.substring(6,8)),
                            ExtinctionDate__c = date.valueOf(obj.dataEstinzione.substring(0,4) + '-' + obj.dataEstinzione.substring(4,6) + '-' + obj.dataEstinzione.substring(6,8)),
                            balance__c = obj.saldoPratica,    
                            selected__c = true,
                            retentionValue__c = valoreCliente,
                            Action__c = esitoCliente,
                            type__c= CRMRetentionUtil.RETENTIONTYPEREQUESTED,
                            Customer__c = customerId,
                            Source__c = obj.source
                        )); 
                    notePratiche += obj.numPratica + ',';
                }
                else
                {
                    retentionNonPossibile = true;
                    messToast = CRMRetentionUtil.PRATICA_PARTNER;
                }
            }
            if(!retentionNonPossibile)
            {
                String roleUserName = [select name from UserRole where id = :userInfo.getUserRoleId()].name;
                String aliasUser = [SELECT Alias FROM User Where Id = :userinfo.getUserId()].Alias;
                XCS_Disposition__c dispo = XCS_DispositionUtils.findDispositionByExternalID(XCS_DispositionUtils.RETENTION_INSERITA);
                listNoteValue.add(roleUserName);
                listNoteValue.add(aliasUser);
                listNoteValue.add(XCS_DispositionUtils.getParentHierarchy('', dispo ) + dispo.Name);
                listNoteValue.add(esitoCliente);
                listNoteValue.add(valoreCliente);
                listNoteValue.add(notePratiche.substring(0, notePratiche.length() - 2));
                listNoteValue.add(flagPrivacy ? 'Si' : 'No');
                listNoteValue.add(fasciaOraria);
                note = XCS_TemplateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_RETENTION_PRESTITI_PREWORK,listNoteValue);
                insert c;
                listOCSNoteValue.add(c.CaseNumber);
                listOCSNoteValue.add(note);
                listOCSNoteValue.add(noteUtente == null ? '' : noteUtente);
                for(CRM_Retention__c r : listRetentionToInsert)
                {
                    r.Case__c = c.id;
                }
                insert listRetentionToInsert;
                XCSNoteUtils.postANote(c.id,XCSNoteUtils.SYSTEM_NOTE_TITLE,note);
                if(String.isNotBlank(noteUtente))
                {
                    XCSNoteUtils.postANote(c.id,XCSNoteUtils.USER_NOTE_TITLE,noteUtente);    
                }
                OCSGestioneNoteInvoker.filtraNote(aliasUser,cliente.getCodice_Cliente__c ,'' ,'' , 'A', 'P', XCS_TemplateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_RETENTION_PRESTITI_RICHIESTA_CRM,listOCSNoteValue)); 
                messToast = XCSCompassConstants.SUCCESSO_CHIUDERE_CHIAMATA;
            }   
        } 
        return new wrapObj(res,retentionNonPossibile,messToast);
    }
    public class wrapObj
    {
        @AuraEnabled
        boolean res {get; set;}
        @AuraEnabled
        boolean retentionNonPossibile {get; set;}
        @AuraEnabled
        String messToast {get; set;}
        public wrapObj(boolean res, boolean retentionNonPossibile, String messToast)
        {
            this.res = res;
            this.retentionNonPossibile = retentionNonPossibile;
            this.messToast = messToast;
        }
    }
}