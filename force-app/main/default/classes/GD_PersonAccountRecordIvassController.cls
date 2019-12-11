public class GD_PersonAccountRecordIvassController {

    @AuraEnabled
     public static Map<String,Object> getPersonAccountById(Id personAccountId){
        Map<String,Object> response=new Map<String,Object>();
        response.put('error',false);
         try{
             Account personAccontObject = [SELECT Id,Name,Codice_Fiscale__c, PersonBirthdate,Note__c, Denominazione_Azienda__c FROM Account WHERE RecordType.Name = 'Person Account' AND Id = : personAccountId ];
            response.put('data',personAccontObject);
            System.debug('personAccontObject : '+personAccontObject);
        } catch(Exception e){
            response.put('error',true);
            response.put('message',e.getMessage());
            response.put('cause',e.getCause());
        }
        return response; 
     }
     @AuraEnabled
     public static Map<String,Object> getAllRisposta(){
        Map<String,Object> response=new Map<String,Object>();
        response.put('error',false);
         try{
            List<IVASS_Dealer_courses_script_risp__c> myAllRisposta = [ SELECT Id, Risposta__c FROM IVASS_Dealer_courses_script_risp__c ];
            response.put('data',myAllRisposta);
            System.debug('myAllRisposta : '+myAllRisposta);
        } catch(Exception e){
            response.put('error',true);
            response.put('message',e.getMessage());
            response.put('cause',e.getCause());
        }
        return response; 
     }

    @AuraEnabled
    public static Map<String,Object> getIscrittiByReferente(String referente){
        Map<String,Object> response = new Map<String,Object>();
        response.put('error',false);
        try{
            List<IVASS_Dealer_courses_Iscritti__c> myIscritti = [SELECT Id ,Name, Stato_Corso__c, Corso__r.Name, Referente__c, Filiale__c , Codice_Intermediario__c FROM IVASS_Dealer_courses_Iscritti__c WHERE Referente__c = : referente];
            response.put('data',myIscritti);
        }catch(QueryException e){
            System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            response.put('error',true);
        }
        return response;
    }

    @AuraEnabled
    public static Map<String,Object> getIscrittiByReferenteIsStatoNotIscritto(String referente){
         Map<String,Object> response = new Map<String,Object>();
        response.put('error',false);
        try{
            List<IVASS_Dealer_courses_Iscritti__c> myIscritti = [SELECT Id ,Name, Stato_Corso__c, Corso__r.Name, Referente__c, Filiale__c , Codice_Intermediario__c FROM IVASS_Dealer_courses_Iscritti__c WHERE Referente__c = : referente AND Stato_Corso__c <> 'ISCRITTO'];
            response.put('data',myIscritti);
        }catch(QueryException e){
            System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            response.put('error',true);
        }
        return response;
    }

    public static List<IVASS_Dealer_courses_script_option__c> getCoursesScriptOption(List<String> myCoursesAnswerGroupIdList){
        System.debug('************************* Start getCoursesScriptOption ***********************');  
         List<IVASS_Dealer_courses_script_option__c> myCoursesScriptOptionList;      
        try{
            myCoursesScriptOptionList = [SELECT ID,Name,User_question__c,answer__c
                       FROM IVASS_Dealer_courses_script_option__c
                       WHERE Name IN : myCoursesAnswerGroupIdList];
            System.debug('myCoursesScriptOptionList : '+myCoursesScriptOptionList);           
            System.debug('myCoursesScriptOptionList size : '+myCoursesScriptOptionList.size());           
        }catch(QueryException e){
             System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            return new List<IVASS_Dealer_courses_script_option__c>();
        }
        System.debug('************************* End getCoursesScriptOption ***********************');
        return myCoursesScriptOptionList;
    }

     @AuraEnabled
    public static Map<String,Object> getCoursesAnswerInTypeForMyType(String myType){
        System.debug('************************* Start getCoursesAnswerInTypeForNOCSI_ISCR ***********************');
         Map<String,Object> response = new Map<String,Object>();
         List<String> myCoursesAnswerGroupIdOptionList = new List<String>();
         List<IVASS_Dealer_courses_script_option__c> myCoursesScriptOptionList ;
        response.put('error',false);
        try{
            List<IVASS_Dealer_courses_answer_group__c> myCoursesAnswerGroupList = [SELECT Id,Type__c,Id_Option__c FROM IVASS_Dealer_courses_answer_group__c  WHERE Type__c =: myType];
            System.debug('myCoursesAnswerGroupList : '+myCoursesAnswerGroupList);
            for(IVASS_Dealer_courses_answer_group__c answer : myCoursesAnswerGroupList){
                myCoursesAnswerGroupIdOptionList.add(String.valueOf(answer.Id_Option__c));
            }
            System.debug('myCoursesAnswerGroupIdList : '+myCoursesAnswerGroupIdOptionList);
            if(myCoursesAnswerGroupIdOptionList.size()>0){
                myCoursesScriptOptionList = GD_PersonAccountRecordIvassController.getCoursesScriptOption(myCoursesAnswerGroupIdOptionList);
            }
            System.debug('myCoursesScriptOptionList : '+myCoursesScriptOptionList);
            response.put('data',myCoursesScriptOptionList);
        }catch(Exception e){
            System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            response.put('error',true);
        }
          System.debug('************************* End getCoursesAnswerInTypeForNOCSI_ISCR ***********************');
        return response;
    }

  @AuraEnabled
    public static Map<String,Object> setPersonAccount(Account account){
        System.debug('************************* Start setPersonAccount ***********************');
         Map<String,Object> response = new Map<String,Object>();
        response.put('error',false);
        try{
           update account;
           response.put('data',account);
        }catch(Exception e){
            System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            response.put('error',true);
        }
         System.debug('response : '+response);
          System.debug('************************* End setPersonAccount ***********************');
        return response;
    }
    @AuraEnabled
    public static Map<String,Object> setIsritti(IVASS_Dealer_courses_Iscritti__c iscritti){
        System.debug('************************* Start setIsritti ***********************');
         Map<String,Object> response = new Map<String,Object>();
        response.put('error',false);
        try{
           update iscritti;
           response.put('data',iscritti);
        }catch(Exception e){
            System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            response.put('error',true);
        }
         System.debug('response : '+response);
          System.debug('************************* End setIsritti ***********************');
        return response;
    }

    
  @AuraEnabled
    public static Map<String,Object> createNoteForPersonAccount(Account account,String contentNote){
        System.debug('************************* Start createNoteForPersonAccount ***********************');
        System.debug('Account : '+account.Id+' contentNote : '+contentNote);
         Map<String,Object> response = new Map<String,Object>();
        response.put('error',false);
        try{
            Note cn = new Note();
            cn.Title = 'test1';
            cn.Body = contentNote;
            cn.ParentId = account.Id;
            insert cn;
           response.put('data',cn);
        }catch(Exception e){
            System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            response.put('error',true);
        }
         System.debug('response : '+response);
          System.debug('************************* End createNoteForPersonAccount ***********************');
        return response;
    }

    @AuraEnabled
    public static Map<String,Object> getNotesByPersonAccount(Account account){
        System.debug('************************* Start getNotesByPersonAccount ***********************');
        System.debug('Account : '+account.Id);
         Map<String,Object> response = new Map<String,Object>();
        response.put('error',false);
        try{
            List<Note> notes =[SELECT Id, ParentId, Title, Body, OwnerId, LastModifiedDate, CreatedDate FROM Note];
           response.put('data',notes);
        }catch(Exception e){
            System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            response.put('error',true);
        }
         System.debug('response : '+response);
          System.debug('************************* End getNotesByPersonAccount ***********************');
        return response;
    }
     @AuraEnabled
    public static Map<String,Object> getFilialeById(Id idFiliale){
        System.debug('************************* Start getFilialeById ***********************');
        System.debug('idFiliale : '+idFiliale);
         Map<String,Object> response = new Map<String,Object>();
        response.put('error',false);
        try{
           Account myAccount  =[SELECT Id , FirstName,LastName, Name , Branch__c,BusinessEmail__c FROM Account WHERE RecordType.Name = 'Branch' AND Id =: idFiliale ];
           response.put('data',myAccount);
        }catch(Exception e){
            System.debug('Meassage : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Strace : '+e.getStackTraceString());
            response.put('error',true);
        }
         System.debug('response : '+response);
          System.debug('************************* End getFilialeById ***********************');
        return response;
    }

    
}