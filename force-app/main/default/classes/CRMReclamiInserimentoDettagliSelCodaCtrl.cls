public without sharing class CRMReclamiInserimentoDettagliSelCodaCtrl {
    public class BorisException extends Exception{ }
    //if(true) throw new BorisException('Debug');
    
    @AuraEnabled
    public static List<CodaXSocieta__mdt> getQueues(String societa, String tipo, XCS_Categoria__c categoria, Boolean delega_presente, String stageInadempimento, Boolean reclamo_completo){               
       System.debug('societa:'+societa+':tipo:'+tipo);
       if (delega_presente==null) {
            delega_presente = false;
       }
       if (reclamo_completo==null) {
            reclamo_completo = false;
       }
       if (String.isEmpty(stageInadempimento)){
            stageInadempimento='';
       }
       //Toppa inizio
        /*
        if(societa == 'MBCredit Solutions'){
            return [Select Id, MasterLabel, DeveloperName, Label, Email__c, Firma__c, Societa__c FROM CodaXSocieta__mdt Where Societa__c = 'MBCredit Solutions' AND DeveloperName in ('DN_342', 'DN_343')];
        }
      
         if(societa == 'Compass' && tipo== '4137' && categoria.External_Id__c=='4137' ){
            return [Select Id, MasterLabel, DeveloperName, Label, Email__c, Firma__c, Societa__c FROM CodaXSocieta__mdt Where Societa__c = 'Compass' and (DeveloperName = 'DN_53' or DeveloperName = 'DN_112' or DeveloperName = 'DN_52')];
        }
        */
        //Toppa Fine
        
        if(tipo== null || categoria == null ){
            List<CodaXSocieta__mdt> lista =  new List<CodaXSocieta__mdt>();
            lista.add(new CodaXSocieta__mdt(Label=' - Selezionare Coda -'));
            return lista;
        }
        String societaDecoded = 'C';
        if (societa!=null) {
            if ('Futuro'.equalsIgnoreCase(societa)) {
                societaDecoded = 'F';
            } else if ('MBCredit Solutions'.equalsIgnoreCase(societa)) {
                societaDecoded = 'R';
            }

        }
        CRM_RCL_Tipologia_Reclamo__mdt tipologia = [SELECT Id, DeveloperName, MasterLabel, Label, Descrizione__c FROM CRM_RCL_Tipologia_Reclamo__mdt where External_Id__c=:tipo And Societa__c = :societaDecoded];   
        tipo = tipologia.Descrizione__c;
        
        
        List<categ_frodi__mdt> frodeList= [Select id, Flag_Frodi__c From categ_frodi__mdt WHERE External_Id__c = :categoria.External_Id__c AND societa__c =:societa];
        Boolean isFrode = frodeList!=null && frodeList.size() > 0 && frodeList[0].Flag_Frodi__c; 
        List<categ_grave__mdt> listGrave = [SELECT Id, DeveloperName, MasterLabel, External_Id__c, Flag_Grave__c, Societa__c FROM categ_grave__mdt Where External_Id__c = :categoria.External_Id__c AND societa__c =:societa];
        Boolean isGrave = listGrave!=null && listGrave.size() >0 && listGrave[0].Flag_Grave__c;
        User us = [Select RNT_profile_id__c, UserRole.Name from user where id =: Userinfo.getUserId()];
        String profilo = us.RNT_profile_id__c;
        List<Profile_queues__mdt>  profileToQueue = [select Queues__c from profile_queues__mdt where Societa__c =: societa and id_profilo__c = :profilo];
        List<rules__mdt> rulesList = [SELECT Id, DeveloperName, Label, Label__c, Societa__c, Tipi_Associati__c, External_Id__c, MasterLabel FROM rules__mdt  where societa__c =:societa];
        
        
        
        String nomeRuolo='';
        if(us.UserRole!=null && us.UserRole.Name!= null) nomeRuolo= us.UserRole.Name;
        
        String nameRule='';
        for(rules__mdt r : rulesList){
            if(r.Tipi_Associati__c.contains(tipo)){
                if(tipo == r.Tipi_Associati__c){
                    nameRule = r.Label__c;
                    break;
                }
                else if(r.Tipi_Associati__c.contains('/')){
                    for(String s : r.Tipi_Associati__c.split('/')){
                        if(tipo == s){
                            nameRule = r.Label__c;
                            break;
                        }
                    }
                }
                if(nameRule!= null && nameRule.length() > 0) break;
            }
        }
        
        List<CodaXSocieta__mdt> listaCoda = new List<CodaXSocieta__mdt>();
        try{
             System.debug('getQueues categoria.External_Id__c:'+categoria.External_Id__c);   
            Categ_queues__mdt catCode = [SELECT Id, DeveloperName, Label, External_Id__c, Queues__c FROM categ_queues__mdt where External_Id__c =:categoria.External_Id__c];
            if(catCode.Queues__c != null) catCode.Queues__c = catCode.Queues__c.trim();
            
            for(CodaXSocieta__mdt temp : [Select Id, MasterLabel, DeveloperName, Label, Email__c, Firma__c, Societa__c FROM CodaXSocieta__mdt Where Societa__c =:societa]){
                Boolean isFlag = isVisible(temp, nameRule, societa, isGrave, Reclamo_Completo, delega_presente, catCode, categoria, stageInadempimento, tipo);
                if(isFlag) listaCoda.add(temp);
            }
        }
        catch(Exception e) {

            System.debug('getQueues Exception '+e.getMessage());   
            System.debug('getQueues Exception '+e.getStackTraceString());    
        }
        finally{
            //Toppe
             if(listaCoda.size() == 0){
                if(societa == 'Compass'){
                    if(isGrave) listaCoda.addAll([Select Id, MasterLabel, DeveloperName, Label, Email__c, Firma__c, Societa__c FROM CodaXSocieta__mdt Where DeveloperName ='DN_57']);
                }
            }
        }
        return listaCoda;
        //Boris Fine
        
    }
    
    
    public static Boolean isVisible(CodaXSocieta__mdt coda, String nameRule, String societa, Boolean isGrave, Boolean reclamo_completo, Boolean delega_presente, categ_queues__mdt catCode, XCS_Categoria__c categoria, String stage_Inadempimento, String tipo){
        System.debug('isVisible coda:'+coda.DeveloperName+':nameRule:'+nameRule+':societa:'+societa+':isGrave:'+isGrave+':reclamo_completo:'+reclamo_completo+':delega_presente:'+delega_presente+':catCode:'+catCode+':categoria:'+categoria+':tipo:'+tipo+':stage_Inadempimento:'+stage_Inadempimento);    
        /*
///////////////////////////////////////////////////////////////////////////////////////
//1. inizialmente la coda di default è visibile
///////////////////////////////////////////////////////////////////////////////////////

*/
        Boolean isVisibile = true;
        
        /*
*	2. prima verifica : - se il tipo di reclamo selezionato è riconducibiile alla regola (tab 'rules' dei file di excel di 
configurazione) AUTORITA
- se si tratta di un reclamo COMPASS
- se l'id della coda esaminata è <> 53
ALLORA
la coda viene nascosta (quindi è visibile solo se l'id della coda esaminata è 53)
*/
        
        if(nameRule == 'AUTORITA' && societa == 'Compass'){
            if(coda.DeveloperName != 'DN_53') {
                 isVisibile=false;
                 System.debug('prima verifica (1):'+isVisibile);  
            }
        }
        
        /*
seconda verifica : - se il tipo di reclamo selezionato è riconducibiile alla regola (tab 'rules' dei file di excel di 
configurazione) ASS. RECLAMO oppure ASS. ALTRO (è implicito che si tratti solo di reclami COMPASS
dal momento che non esistono reclami FUTURO o CREDITECH associati a quelle RULES)
- se l'id della coda esaminata è <> 52 e <> 53
ALLORA
la coda viene nascosta
*/
        
        if(nameRule == 'ASS. RECLAMO' || nameRule =='ASS. ALTRO'){
            System.debug('Regola Aggiuntiva 2');
            
            if(coda.DeveloperName != 'DN_53' && coda.DeveloperName != 'DN_52') {
                isVisibile = false;
                System.debug('seconda verifica (1):'+isVisibile); 
            }
            
        }
        
        /*
4. terza verifica : - se si tratta di un reclamo relativo all' INADEMPIMENTO
- se si tratta di un reclamo COMPASS o CREDITECH
- se il reclamo è COMPLETO ed è impostato DELEGA PRESENTE :
IL RECLAMO è GRAVE COMPLETO.

- se il reclamo è GRAVE COMPLETO :
- se il reclamo è all'ultimo step di inadempimento (step2 - F&T Waiting):
La CODA ESAMINATA è visibile solo se il suo id è 52, 53, 57 (questi ID sono solo di reclami COMPASS)
- in qualsiasi altro step di inadempimento :
La CODA ESAMINATA è visibile solo se il suo id è 53, 57 (id code COMPASS)
- se il reclamo NON E' GRAVE COMPLETO :
La CODA ESAMINATA è visibile solo se il suo id è 52 (id coda COMPASS)

- indipendentemente dal fatto che il reclamo sia GRAVE COMPLETO o meno :
- se l'id della CODA ESAMINATA è 52 allora la coda è visibile.a
- se l'id della CODA ESAMINATA è 57 allora la coda è visibile.
- se l'id della CODA ESAMINATA è 53 allora la coda è nascosta.

*/
        
        if (isgrave) {
            if(societa == 'Compass' || societa == 'MBCredit Solutions'){
                //Grave completo = Delega Presente && Reclamo Completo
                System.debug('Reclamo Completo :'+Reclamo_Completo);
                System.debug('delega_presente :'+delega_presente);
                System.debug('isgrave :'+isgrave);
                Boolean graveCompleto = false;
                if(Reclamo_Completo && delega_presente){
                    graveCompleto = true;
                }
                    
                    /*
    * 	- se il reclamo è GRAVE COMPLETO :
    - se il reclamo è all'ultimo step di inadempimento (step2 - F&T Waiting):
    La CODA ESAMINATA è visibile solo se il suo id è 52, 53, 57 (questi ID sono solo di reclami COMPASS)

    */
                if (graveCompleto) {  
                    if(stage_Inadempimento=='4169'){
                        if(coda.DeveloperName != 'DN_52' &&  coda.DeveloperName != 'DN_53' && coda.DeveloperName != 'DN_57'){
                            isVisibile = false;
                            System.debug('terza verifica (1):'+isVisibile); 
                        }
                    }
                    /*
    - in qualsiasi altro step di inadempimento :
    La CODA ESAMINATA è visibile solo se il suo id è 53, 57 (id code COMPASS)

    */
                    else{
                        if(coda.DeveloperName != 'DN_53' && coda.DeveloperName != 'DN_57'){
                            isVisibile = false;
                            System.debug('terza verifica (2):'+isVisibile);  
                        }
                    }
                }                       
                //- se il reclamo NON E' GRAVE COMPLETO :               
                else{
                    // La CODA ESAMINATA è visibile solo se il suo id è 52 (id coda COMPASS)
                    if(coda.DeveloperName != 'DN_52') {
                        isVisibile=false;
                        System.debug('terza verifica (3):'+isVisibile);  
                    }
                }
                /*- indipendentemente dal fatto che il reclamo sia GRAVE COMPLETO o meno :
    - se l'id della CODA ESAMINATA è 52 allora la coda è visibile.   COMMENT *** per gestire l'ante 1/06/2011 abilito sempre IDM
    - se l'id della CODA ESAMINATA è 57 allora la coda è visibile.   COMMENT *** per i giri strani abilito anche legale
    - se l'id della CODA ESAMINATA è 53 allora la coda è nascosta.  COMMENT Modifica abilitazione centro recupero legale a gestione inadempimento
    */
                if(coda.DeveloperName == 'DN_52') {
                    isVisibile=true;
                    System.debug('terza verifica (4):'+isVisibile); 
                } 
                if(coda.DeveloperName == 'DN_57') {
                    isVisibile=true;
                    System.debug('terza verifica (5):'+isVisibile); 
                } 
                if(coda.DeveloperName == 'DN_53') {
                    isVisibile=false;
                    System.debug('terza verifica (6):'+isVisibile); 
                }
            }
        }
        
        /*
5. quarta verifica : - se NON si tratta di un reclamo relativo all'INADEMPIMENTO :
-  se per la categoria selezionata non è presente una relativa lista di id code abilitate 
(foglio di excel di configurazione, tab 'categ_queues') :
la CODA ESAMINATA è visibile

- se l'id della CODA ESAMINATA è presente negli id abilitati per la categoria del reclamo selezionata 
(foglio di excel di configurazione, tab 'categ_queues') :
la CODA ESAMINATA è visibile

- se l' id della CODA ESAMINATA NON è presente negli id ablitati per la categoria del reclamo selezionata:
la CODA ESAMINATA è nascosta

- in aggiunta, se non è stato flaggato il campo DELEGA PRESENTE allora :
- se la CODA ESAMINATA ha id uguale a 52 :
la CODA ESAMINATA è visibile
*/
        
        if(!isGrave){
            String codaTempDN = coda.DeveloperName.replace('DN_', '');
            
            if(catCode.queues__c == null || catCode.queues__c.length() == 0 ) {
                 // 1) se per la categoria selezionata non è presente una relativa lista di id code abilitate  
                isVisibile = true; 
                System.debug('quarta verifica (1):'+isVisibile); 
            } else {
                  
                if(!catCode.queues__c.contains(codaTempDN)) { 
                    //2)  l'id della CODA ESAMINATA è presente negli id abilitati per la categoria del reclamo selezionata 
                    isVisibile = false;
                     System.debug('quarta verifica (2):'+isVisibile); 
                }               
            }
            if( codaTempDN == '52' && delega_presente) {
                    //4) se non è stato flaggato il campo DELEGA PRESENTE, se la CODA ESAMINATA ha id uguale a 52
                isVisibile= true;
                 System.debug('quarta verifica (4):'+isVisibile); 
            } 
            
        }
        /*
6. quinta verifica : - se il tipo di reclamo selezionato è riconducibile alla regola 4176 (foglio di excel di configurazione,
tab 'rules') :
- se la categoria selezionata è 2037 oppure 3430 allora :
la CODA ESAMINATA è nascosta
- se la categoria selezionata è DIVERSA da 2037 e 3430 :
la CODA ESAMINATA è visibile

*/
        
        if(nameRule == 'Collector'){

            if (categoria.External_Id__c== '2037') {
                isVisibile = false;
                System.debug('quinta verifica (1):'+isVisibile);
            } else if (categoria.External_Id__c== '3430') {
                isVisibile = false;
                System.debug('quinta verifica (2):'+isVisibile);
            } else {
                isVisibile = true;
                System.debug('quinta verifica (3):'+isVisibile);
            }
        }
        
        /*
* 7. sesta verifica : - se il reclamo NON E' un reclamo FUTURO :
- se la regola riconducibile al tipo di reclamo selezionato è diversa da 5409 e diversa da 5410 :
- se l'id della CODA ESAMINATA è 112 :
- se si tratta di INADEMPIMENTO allora :
la CODA ESAMINATA è nascosta
- se NON si tratta di INADEMPIMENTOO :
la CODA ESAMINATA è visibile

*/
        
        if(societa != 'Futuro'){
            if(nameRule != 'ASS. RECLAMO' && nameRule != 'ASS. ALTRO'){
                if(coda.DeveloperName == 'DN_112'){
                    if(isGrave) {
                        isVisibile=  false;
                         System.debug('sesta verifica (1):'+isVisibile);
                    }
                    else {
                        isVisibile=true;
                        System.debug('sesta verifica (2):'+isVisibile);
                    }
                }
            }
        }
        
        /*
* 8. settima verifica : - se il tipo di reclamo selezionato NON E' riconducibile alla regola 4138 (foglio di excel di configurazione,
tab 'rules') :
- se il tipo reclamo selezionato NON E' 'ALTRO CM' e nemmeno 'ALTRO NPL' allora :
- La CODA ESAMINATA è visibile
- (SOLO PER RECLAMI CREDITECH)se l'ID della CODA ESAMINATA NON E' 342 :
-  se il tipo reclamo selezionato E' uguale a uno fra 'REPLICHE CM', 'REPLICHE NPL', 'DECISIONE NPL',
'DECISIONE CM' :
la CODA ESAMINATA viene nascosta
- (SOLO PER RECLAMI COMPASS)se l'ID della CODA ESAMINATA NON E' 53 :
- se il tipo reclamo selezionato E' uguale a uno fra 'REPLICHE', 'DECISIONE' :
la CODA ESAMINATA viene nascosta
- (SOLO PER RECLAMI FUTURO) se l'ID della CODA ESAMINATA NON E' 298 :
- se il tipo reclamo selezionato E' uguale a uno fra 'REPLICHE', 'DECISIONE' :
la CODA ESAMINATA viene nascosta

*/
        
        if(nameRule == 'ALTRO'){
            if(tipo != 'Altro' && tipo != 'Altro CM' && tipo != 'Altro NPL' ){
                isVisibile= true;
                System.debug('settima verifica (1):'+isVisibile);
                if(societa == 'MBCredit Solutions' && coda.DeveloperName!='DN_342'){
                    if(tipo == 'Repliche CM' || tipo == 'Repliche NPL' || tipo == 'DECISIONE NPL' || tipo == 'DECISIONE CM'){
                        isVisibile=false;
                         System.debug('settima verifica (2):'+isVisibile);
                    }
                }
                
                if(societa == 'COMPASS' && coda.DeveloperName != 'DN_53'){
                    if(tipo == 'Repliche' || tipo == 'Decisione') {
                        isVisibile=false;
                        System.debug('settima verifica (3):'+isVisibile);
                    }
                }
                
                if(societa == 'Futuro' && coda.DeveloperName != 'DN_298'){
                    if(tipo == 'Repliche' || tipo == 'Decisione') {
                        isVisibile=false;
                        System.debug('settima verifica (4):'+isVisibile);
                    }
                }
            }          
        }
        
        System.debug('ALLA FINE coda '+coda.developerName+' isVisibile:'+isVisibile);
        return isVisibile;
        
    }
    
    
    
    
    @AuraEnabled
    public static String getOwnerCtrl (String coda, String societa){
        coda = coda.replace('DN_', 'Q');
        return [Select id from Group where developerName =:coda].Id;
        
    }
    
    @AuraEnabled
    public static CodaXSocieta__mdt setCodaInizialeCTRL(String recordId, String societa){
        List<Group> lista = [Select developerName from Group Where Id in (Select OwnerId from Case where id =:recordId)];
        if(lista== null || lista.size() ==0) return null; 
        String coda = lista[0].developerName.replace('Q', 'DN_');
        System.debug('@@@Boris '+coda);
        
        return [select Id, developerName from CodaXSocieta__mdt where developerName =:coda];
        
    }
    /*
@AuraEnabled
public static CodaXSocieta__mdt setCodaInizialeCTRL(String recordId, String societa){
List<Group> lista = [Select developerName from Group Where Id in (Select OwnerId from Case where id =:recordId)];
if(lista== null || lista.size() ==0) return null; 
String coda = lista[0].developerName.replace('Q', 'DN_');
System.debug('@@@Boris '+coda);

List<CodaXSocieta__mdt> codaSocieta = [select Id, developerName from CodaXSocieta__mdt where developerName =:coda];
if(codaSocieta.size()>0){
return codaSocieta.get(0);
}
return null;
//return [select Id, developerName from CodaXSocieta__mdt where developerName =:coda]; 
}
*/
    
    @AuraEnabled
    public static List<String> filterQueuesByCateg(String categName,String societa){
        List<String> res = new List<String>();
        System.debug('CRMReclamiInserimentoDettagliSelCodaCtrl filterQueuesByCateg inputs: '+categName+'\n'+societa);
        categ_queues__mdt[] temp=[select DeveloperName,External_Id__c,Queues__c
                                  from categ_queues__mdt
                                  where Societa__c=:societa and External_Id__c=:categName];
        System.debug('CRMReclamiInserimentoDettagliSelCodaCtrl filterQueuesByCateg temp: '+temp);
        if(temp.size()>0){
            res=temp[0].Queues__c.split('/');
        }
        System.debug('CRMReclamiInserimentoDettagliSelCodaCtrl filterQueuesByCateg res: '+res);
        return res;
    }
    
    @AuraEnabled
    public static List<CodaXSocieta__mdt> applyRules(List<CodaXSocieta__mdt> listToFilter,String societa,String tipo,XCS_Categoria__c categoria,Boolean completo,Boolean delega,String stepInadempimento){
        System.debug('CRMReclamiInserimentoDettagliSelCodaCtrl applyRules inputs:\nlistToFilter:'+listToFilter+'\nsocieta: '+societa+'\ntipo: '+tipo+'\ncategoria: '+categoria+'\ncompleto: '+completo+'\ndelega: '+delega+'\nstepInadempimento: '+stepInadempimento);
        String utente = XCSReclamiUtils.getIdReclamiUser(Userinfo.getUserId());        
        List<rules__mdt> rules=[select DeveloperName,Label__c,External_Id__c,Tipi_Associati__c
                                from rules__mdt
                                where Societa__c=:societa];
        List<categ_grave__mdt> grave=[select Flag_Grave__c,External_Id__c 
                                      from categ_grave__mdt
                                      where Societa__c=:societa and External_Id__c=:categoria.External_Id__c];
        
        List<CodaXSocieta__mdt> allQueues = [SELECT DeveloperName,Label,Firma__c  FROM CodaXSocieta__mdt WHERE Societa__c =:societa];
        
        System.debug('CRMReclamiInserimentoDettagliSelCodaCtrl applyRules rules: '+rules);
        System.debug('CRMReclamiInserimentoDettagliSelCodaCtrl applyRules grave: '+grave);
        Map<String,Boolean> resMap=initiateMap(listToFilter,allQueues);
        for(String k:XCSReclamiRulesCodeUtils.RULES_NAMES){
            System.debug('CRMReclamiInserimentoDettagliSelCodaCtrl applyRules check regola '+k);
            if(k.equals('9b') || k.equals('10')){
                resMap=XCSReclamiRulesCodeUtils.applyRule(societa,k,resMap,checkRule(k,rules,tipo,utente,societa,categoria,completo,delega,grave,stepInadempimento));
            }
            else{
                if(checkRule(k,rules,tipo,utente,societa,categoria,completo,delega,grave,stepInadempimento)){
                    resMap=XCSReclamiRulesCodeUtils.applyRule(societa,k,resMap,true);
                }
            }
        }
        List<CodaXSocieta__mdt> res=makeResList(resMap,allQueues);
        System.debug('CRMReclamiInserimentoDettagliSelCodaCtrl applyRules res: '+res);
        return res;
    }
    
    @TestVisible
    private static Map<String,Boolean> initiateMap(List<CodaXSocieta__mdt> listToFilter, List<CodaXSocieta__mdt> allQueues){
        Map<String,Boolean> res=new Map<String,Boolean>();
        for(CodaXSocieta__mdt c:allQueues){
            res.put(c.DeveloperName,checkIfIn(c,listToFilter));
        }
        System.debug('CRMReclamiInserimentoDettagliSelCodaCtrl initiateMap: '+res);
        return res;
    }
    
    @TestVisible
    private static Boolean checkIfIn(CodaXSocieta__mdt coda, List<CodaXSocieta__mdt> listToFilter){
        Boolean res = false;
        for(CodaXSocieta__mdt c : listToFilter){
            if(c.Id.equals(coda.Id)){
                res=true;
                break;
            }
        }
        
        return res;
    }
    
    @TestVisible
    private static List<CodaXSocieta__mdt> makeResList(Map<String,Boolean> resMap, List<CodaXSocieta__mdt> allQueues){
        List<CodaXSocieta__mdt> res=new List<CodaXSocieta__mdt>();
        for(CodaXSocieta__mdt c:allQueues){
            if(resMap.get(c.DeveloperName)){
                res.add(c); 
            }
        }
        return res;
    }
    
    @TestVisible
    private static Boolean checkRule(String ruleName,List<rules__mdt> rules,String tipo,String utente,String societa,XCS_Categoria__c categoria,Boolean completo,Boolean delega,List<categ_grave__mdt> grave,String stepInadempimento){
        Boolean res=false;
        res=
            (
                ruleName.equals('1')?
                checkRule1(rules,tipo,utente):
                ruleName.equals('2')?
                checkRule2(rules,tipo,societa):
                ruleName.equals('3')?
                checkRule3(rules,tipo,societa):
                ruleName.equals('4a')?
                checkRule4a(grave,societa,completo,delega):
                ruleName.equals('4b')?
                checkRule4b(stepInadempimento):
                ruleName.equals('5')?
                checkRule5(societa,checkRule4a(grave,societa,completo,delega)):
                ruleName.equals('6')?
                checkRule6(grave,societa):
                ruleName.equals('7')?
                checkRule7(grave,societa):
                ruleName.equals('8')?
                checkRule8(grave,delega):
                ruleName.equals('9a')?
                checkRule9a(rules,tipo):
                ruleName.equals('9b')?
                checkRule9b(checkRule9a(rules,tipo),categoria.Name):
                ruleName.equals('10')?
                checkRule10(rules,tipo,grave):
                ruleName.equals('11a')?
                checkRule11a(tipo,societa):
                ruleName.equals('11b')?
                checkRule11b(checkRule11a(tipo,societa),tipo,societa):
                false
            );
        return res;
    }
    
    @TestVisible
    private static Boolean checkRulesForTipo(List<rules__mdt> rules,String tipo,List<String> namesToCheck){
        Boolean res=false;
        for(rules__mdt r:rules){
            if(namesToCheck.contains(r.Label__c)){
                List<String> tempList=r.Tipi_Associati__c.split('/');
                if(tempList.contains(tipo)){
                    res=true;
                    break;
                }
            }
        }
        return res;
    }
    
    //Si riferisce alla prima regola aggiuntiva descritta nell'analisi di Reclami Inserimento
    //se true, la data di scadenza sarà modificabile.
    @TestVisible
    private static Boolean checkRule1(List<rules__mdt> rules,String tipo,String utente){ 
        Boolean res=false;
        res=checkRulesForTipo(rules,tipo,new List<String>{'AUTORITA'});
        if(res){
            //TODO logica sull'utente
        }
        return res;
    }
    
    //seconda regola (per Compass)
    //se true, sarà visibile solo la coda Reclami – Uff. Reclami
    @TestVisible
    private static Boolean checkRule2(List<rules__mdt> rules,String tipo,String societa){
        Boolean res=false;
        if(XCSCompassConstants.COMPASS.equals(societa)){
            res=checkRulesForTipo(rules,tipo,new List<String>{'AUTORITA'});
        }
        return res;
    }
    
    //(per compass) se true, saranno visibile soltanto le code Reclami – IDM Response Staff e Reclami – Uff Reclami
    @TestVisible
    private static Boolean checkRule3(List<rules__mdt> rules,String tipo,String societa){
        Boolean res=false;
        res=checkRulesForTipo(rules,tipo,new List<String>{'ASS. RECLAMO','ASS. ALTRO'});
        return res;
    }
    
    //(no futuro) check prima parte della regola 4, se true, nel 'main' verrà controllata anche la seconda parte
    @TestVisible
    private static Boolean checkRule4a(List<categ_grave__mdt> grave,String societa,Boolean completo,Boolean delega){
        Boolean res=false;
        if(grave.size()>0 && delega != null && delega && completo != null  && completo && !societa.equals('Futuro')){
            res=true;
        }
        return res;
    }
    
    //check seconda parte della regola 4, TODO
    @TestVisible
    private static Boolean checkRule4b(String stepInadempimento){
        Boolean res=false;
        //TODO
        return res;
    }
    
    //(no futuro) check regola 5, (nega la 4a)
    @TestVisible
    private static Boolean checkRule5(String societa,Boolean rule4a){
        Boolean res=false;
        if(!XCSCompassConstants.FUTURO.equals(societa)){
            res=!rule4a;
        }
        return res;
    }
    
    //(no futuro) regola 6, se true rendo visibili: Reclami – IDM Response Staff ;Reclami – Centro Recupero Legale
    @TestVisible
    private static Boolean checkRule6(List<categ_grave__mdt> grave,String societa){
        Boolean res=false;
        if(!XCSCompassConstants.FUTURO.equals(societa) && grave.size()>0){
            res=true;
        }
        return res;
    }
    
    //(no futuro) regola 7, nascondo sempre la coda:Reclami – Uff Reclami
    @TestVisible
    private static Boolean checkRule7(List<categ_grave__mdt> grave,String societa){
        Boolean res=false;
        if(!XCSCompassConstants.FUTURO.equals(societa) && grave.size()>0){
            res=true;
        }
        return res;
    }
    
    //se true, aggiungo sempre la coda: Reclami – IDM Response Staff
    @TestVisible
    private static Boolean checkRule8(List<categ_grave__mdt> grave,Boolean delega){
        Boolean res=false;
        if(grave.size()==0 && delega!=null && delega){
            res=true;
        }
        return res;
    }
    
    @TestVisible
    private static Boolean checkRule9a(List<rules__mdt> rules,String tipo){
        Boolean res=false;
        res=checkRulesForTipo(rules,tipo,new List<String>{'COLLECTOR'});
        return res;
    }
    
    //se true, Tutte le code vengono nascoste, altrimenti son tutte visibili.
    @TestVisible
    private static Boolean checkRule9b(Boolean rule9a,String categExtName){
        Boolean res=false;
        if(rule9a){
            if(categExtName.equals('Restituzione cambiali') || categExtName.equals('Varie')){
                res=true;
            }
            else{
                res=false;
            }
        }
        return res;
    }
    
    //se true, la coda Reclami → CS Interno deve essere nascosta altrimenti deve risultare visibile.
    @TestVisible
    private static Boolean checkRule10(List<rules__mdt> rules,String tipo,List<categ_grave__mdt> grave){
        Boolean res=false;
        if(grave.size()>0){
            res=checkRulesForTipo(rules,tipo,new List<String>{'ASSICURAZIONE RECLAMO','ASSICURAZIONE ALTRO'});  
        }
        return res;
    }
    
    //Se true, vengono preventivamente annullate le regole precedenti e viene effettuato il check della parte 11b
    @TestVisible
    private static Boolean checkRule11a(String tipo,String societa){
        Boolean res=false;
        List<String> checkList=new List<String>{'Repliche CM','Repliche NPL','Decisione CM','Decisione NPL','Decisione','Repliche'};
            if(XCSCompassConstants.FUTURO.equals(societa)){
                checkList.add('Assicurazione Altro');
            }
        if(checkList.contains(tipo)){
            res=true;
        }
        return res;
    }
    
    //(creditech) se true, viene nascosta la coda Reclami Creditech - Uff. Reclami – Operatore
    //(compass) viene nascosta la coda Reclami - Uff. Reclami
    //(futuro) viene nascosta la coda Reclami Futuro - Uff. Reclami – Operatore
    @TestVisible
    private static Boolean checkRule11b(Boolean rule11a,String tipo,String societa){
        Boolean res=false;
        if(rule11a){
            if(XCSCompassConstants.MBC.equals(societa)){
                res=true;
            }
            else{
                if(new List<String>{'Repliche','Decisione'}.contains(tipo)){
                    res=true;
                }
            } 
        }
        return res;
    }
    
    @AuraEnabled
    public static String getInitialQueues(String recordId){ 
        system.debug('----------------------------------------------------------------------');
        system.debug('-- - Class Name  : CRMReclamiInserimentoDettagliSelCodaCtrl           '); 
        system.debug('-- - Method Name  : getInitialQueues                                  '); 
        
        Case c = [Select owner.name from Case where id =: recordId];
        return c.owner.name;
    }
    
    
    
}