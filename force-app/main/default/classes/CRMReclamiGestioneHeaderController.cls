public without sharing class CRMReclamiGestioneHeaderController {
    @AuraEnabled
    public static Map<String,List<Object>> getInitValues(String societa){
       
        societa=(societa.equals('Compass')?'C':societa.equals('Futuro')?'F':'R');
        Map<String,List<Object>> res=new Map<String,List<Object>>();
        List<CRM_RCL_Tipologia_Reclamo__mdt> tipi=[select DeveloperName,Area__c,Auth__c,Descrizione__c,External_Id__c,Rule_Id__c
                                                   from CRM_RCL_Tipologia_Reclamo__mdt
                                                   where Societa__c=:societa and Visibile__c=true];
        List<String> statusList=new List<String>();
        Schema.DescribeFieldResult statusResultMod=Case.Status.getDescribe();
        List<Schema.PicklistEntry> ple=statusResultMod.getPicklistValues();
        System.debug('CRMReclamiGestioneHeaderController getInitValues ple: '+ple);
        for(Schema.PicklistEntry pickListVal:ple){
            statusList.add(pickListVal.getLabel());
        }
        res.put('tipiList',tipi);
        res.put('statusList',statusList);
        System.debug('res = ' + res);
        return res;
    }
    
    @AuraEnabled
    public static CRM_RCL_Tipologia_Reclamo__mdt getInitTipo(String idCase, String societa){
        String res = '';
        String prefisso = societa.subString(0,1);
        if('M'.equalsIgnoreCase(prefisso))
            prefisso = 'R';
         
        System.debug('prefisso = ' + prefisso);
        String extId = [Select tipo_reclamo__c from case where id =: idCase].tipo_reclamo__c;
        System.debug('numero tipo reclamo = ' + extId);
        
        List<CRM_RCL_Tipologia_Reclamo__mdt> crtr = [Select descrizione__c, external_id__c from CRM_RCL_Tipologia_Reclamo__mdt 
                                                     where external_id__c =: extId and Societa__c =: prefisso.toUpperCase()];
        System.debug('crtr = ' + crtr);
      
       
        return crtr[0];
    }
    
    @AuraEnabled
    public static boolean isDataScadenzaWritable(CRM_RCL_Tipologia_Reclamo__mdt tipo_mdt, String societa){
        String tipo = tipo_mdt.descrizione__c;
        List<rules__mdt> rules = [select DeveloperName,Label__c,External_Id__c,Tipi_Associati__c
                                  from rules__mdt
                                  where Societa__c=:societa];
        
        Boolean res = XCSReclamiUtils.checkRulesForTipo(rules,tipo,new List<String>{XCSCompassConstants.AUTORITA});
        system.debug('res da checkRulesForTipo-----> ' + res);
        //se il profilo dell’utente loggato è CUSTOMER OPERATIONS MANAGER oppure RECLAMO User oppure RECLAMO Manager
        String roleName = [select Name from UserRole where id=:UserInfo.getUserRoleId()].Name;
        if(res){
            if(roleName.equals(XCSCompassConstants.CUSTOM_OPERATION_MANAGER) || 
               roleName.equals(XCSCompassConstants.RECLAMI_MANAGER) || 
               roleName.equals(XCSCompassConstants.RECLAMI_USER) || 
//               roleName.equals(XCSCompassConstants.SYSTEM_ADMIN)){
               roleName.equals(XCSCompassConstants.ADMIN)){
                res=true;
            }
            else
                res=false;
        }
        return res;
    }
    
    @AuraEnabled
    public static List<String> loadUserGroup(){
        List<String> utenti = new List<String>();
        
        
        User currentUser = [SELECT Id, RNT_group_id__c FROM User where id =: UserInfo.getUserId()];
        if(currentUser.RNT_group_id__c != null && !''.equalsIgnoreCase(currentUser.RNT_group_id__c)){
            List<User> sameGroupUser = [SELECT Id, LastName, FirstName FROM User where RNT_group_id__c =: currentUser.RNT_group_id__c];
            for(User u : sameGroupUser) {
                String nomeCompleto = u.FirstName + ' ' + u.LastName;
                utenti.add(nomeCompleto);
            }
        }
		System.debug('utenti = ' + utenti);        
        return utenti;        
    }
    
    @AuraEnabled
    public static String getCurrentUser(String recordId){
        String utente = '';
        Case c = [Select Assegnatario__c from Case where id =: recordId];
        if(c.Assegnatario__c != null){
            User u = [Select FirstName, LastName from User where id =: c.Assegnatario__c];
            if(u != null)
                utente = u.FirstName + ' ' + u.LastName;
        }
        return utente;
        
    }
    
    @AuraEnabled
    public static void salvaReclamoGestioneHeaderApex(String recordId, String categoriaId, String reclamoCompleto,
                                                      String accessoDati, String delegaPresente, String status,
                                                      String tipo, String coda)
    {                                            
        
        
        
        Boolean reclamoCompletoB;
        Boolean accessoDatiB;
        Boolean delegaPresenteB;
        
        if('Si'.equalsIgnoreCase(reclamoCompleto)) 
            reclamoCompletoB = true;
        else
            reclamoCompletoB = false;
        
        if('Si'.equalsIgnoreCase(accessoDati)) 
            accessoDatiB = true;
        else
            accessoDatiB = false;
        
        if('Si'.equalsIgnoreCase(delegaPresente)) 
            delegaPresenteB = true;
        else
            delegaPresenteB = false;                                     
        
 		String codaDevName;
        String codaId;
        
        
        if('D'.equalsIgnoreCase(coda.substring(0,1))){
            codaDevName = 'Q'+coda.substring(3);
            
            List<Group> g = [Select id from group where type='Queue' and DeveloperName =: codaDevName];
            
            if(g.size() > 0)
                codaId = g[0].id;
        }
        
       	else            
            codaId = coda;
        
         

        
        Case c = new Case(Id = recordId,
                          Categoria_Riferimento__c = categoriaId,
                          Reclamo_Completo__c  = reclamoCompletoB,
                          Delega_Presente__c = delegaPresenteB,
                          Has_Acceso_Dati__c = accessoDatiB,
                          status = status,
                          OwnerId = codaId,
                          Tipo_Reclamo__c = tipo);
        
        update c;
    }
    
    @AuraEnabled
    public static Boolean checkAss(String recordId){
        Boolean res = false;
        Case c = [Select Tipo_Reclamo__c, Referenced_Company__c from Case where id =: recordId];
        
        List<CRM_RCL_Tipologia_Reclamo__mdt> tr = [Select Descrizione__c FROM CRM_RCL_Tipologia_Reclamo__mdt
                                                   where External_Id__c =: c.Tipo_Reclamo__c And Area__c =: c.Referenced_Company__c];
        
        if(tr.size() > 0){
            if('Assic'.equalsIgnoreCase((tr[0].descrizione__c).substring(0,5)))
                res = true;
        }
        
        return res;        
    }
    //metto dentro tutti i tipi di assicurazione
    @AuraEnabled
    public static List<String> getAss(String societa){
        List<String> tipoAssList = new List<String>();
        
        if(societa != null)
            societa = societa.substring(0,1);
        
        List<CRM_RCL_Tipologia_Reclamo__mdt> mtd = [SELECT Id, External_Id__c, Descrizione__c
                                                    FROM CRM_RCL_Tipologia_Reclamo__mdt where Societa__c =: societa];
        
        for(CRM_RCL_Tipologia_Reclamo__mdt m : mtd){
            if('ass'.equalsIgnoreCase(m.descrizione__c.substring(0,3)))
                tipoAssList.add(m.external_Id__c);
        }
        
        
        return tipoAssList;
    }

    
    @AuraEnabled
    public static Object treeCategories(String azienda){
       return  CRMReclamiInserimentoDettagliCategCtrl.treeCategories(azienda);
    }
    /*
    @AuraEnabled
    public static List<User> takeUsersFromQueue(Id codaId){
        system.debug('takeUsersFromQueue: '+ codaId);
        
        List<User> lUser = new List<User>();

        List<GroupMember> lGM = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :codaId];
        System.debug('lGM -> ' + lGM);
        List<Id> lGroup = new List<Id>();
        List<Id> lGroup2 = new List<Id>();

        if(lGM.size()>0){
            for(GroupMember gm : lGM){
                if(!lGroup.contains(gm.UserOrGroupId)){
                    lGroup.add(gm.UserOrGroupId);
                }
            }
            if(lGroup.size()>0){
                List<Group> groupRElated = [SELECT RelatedId FROM Group where id IN:lGroup];

                if(groupRElated.size()>0){
                    for(Group g : groupRElated){
                        if(!lGroup2.contains(g.RelatedId)){
                            lGroup2.add(g.RelatedId);
                        }
                    }
                    lUser = [SELECT Id, Name FROM User WHERE UserRoleId IN :lGroup2 ORDER BY Name ASC NULLS FIRST];
                }
            }
            
        }
        System.debug('lUser -> ' + lUser);
        return lUser;
    }*/
    @AuraEnabled
    public static List<User> takeUsersFromQueue(Id codaId){
        return XCSReclamiUtils.takeUsersFromQueue(codaId);
    }
    
    @AuraEnabled
    public static Case calcolaScadenzaReclamo(Id caseId, Boolean accessoDati){
        system.debug('MS_calcolaScadenzaReclamo_caseId: '+caseId);
        system.debug('MS_calcolaScadenzaReclamo_accessoDati: '+accessoDati);
        Case c = new Case();
        if(caseId!=null){
            c = [SELECT Id, Data_Ricezione__c, Scadenza_Reclamo__c FROM Case WHERE Id =: caseId]; 
            system.debug('MS_calcolaScadenzaReclamo_BEFORE_c.Scadenza_Reclamo__c: '+c.Scadenza_Reclamo__c);
            if(accessoDati){
                c.Scadenza_Reclamo__c = c.Data_Ricezione__c.addDays(12);
            }else{
                c.Scadenza_Reclamo__c = c.Data_Ricezione__c.addDays(27);
            }
            system.debug('MS_calcolaScadenzaReclamo_AFTER_c.Scadenza_Reclamo__c: '+c.Scadenza_Reclamo__c);
            update c;
        }
        return c;
    }

}