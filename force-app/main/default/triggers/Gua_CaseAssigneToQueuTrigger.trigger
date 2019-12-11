/**
 * @File Name          : Gua_QueueAssigmentCnt
 * @Description        : Assigne case to a queue after update or insert in unita affari
 * @Author             : Abdoulaye DIOP (AD)
 * @CreatedDate        : 09/11/2019
**/
trigger Gua_CaseAssigneToQueuTrigger on Case (after insert, after Update) {
    if (Gua_Service.handleRunOnce()) {
        if (trigger.isAfter) {
            if (trigger.isInsert || trigger.isUpdate) {
                List<Case> casesToUpDate = new List<Case>();
                List<Case> caseToQ281 = new List<Case>();
                List<Case> caseToQ285 = new List<Case>();
                List<Case> caseToQ286 = new List<Case>();
                List<Case> caseToQ287 = new List<Case>();
                Id recordtypeId = Gua_Service.getRecordTypeId('GUA_Contact', 'Case');
                List<Case> cases = [SELECT Id, OwnerId, Account.OCSAreaId__c FROM Case WHERE RecordtypeId =: recordtypeId AND Id IN :Trigger.new];
                List<GUA_Queue_Assigment__c> queueAssignements = [SELECT Id, Q281__c, Q285__c, Q286__c, Q287__c, IsActive__c FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];

                if (!queueAssignements.isEmpty()) {
                    if (queueAssignements.size() == 1) {
                        List<String> q281List = new List<String>();
                        List<String> q285List = new List<String>();
                        List<String> q286List = new List<String>();
                        List<String> q287List = new List<String>();
                        GUA_Queue_Assigment__c queueAssignement = queueAssignements[0];
                        Map<String, Object> queueAssignementMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(queueAssignement));
                        Set<String> queueAssigkey = queueAssignementMap.keySet();
                        if (queueAssigkey.contains('Q281__c')) {
                            q281List =  ((String) queueAssignementMap.get('Q281__c')).split(';');
                        }
                        if (queueAssigkey.contains('Q285__c')) {
                            q285List = ((String) queueAssignementMap.get('Q285__c')).split(';');
                        }
                        if (queueAssigkey.contains('Q286__c')) {
                            q286List = ((String) queueAssignementMap.get('Q286__c')).split(';');
                        }
                        if (queueAssigkey.contains('Q287__c')) {
                            q287List = ((String) queueAssignementMap.get('Q287__c')).split(';');
                        }
                        for (Case c : cases) {
                            Map<String, Object> caseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
                            System.debug('#l caseMap '+ JSON.serialize(caseMap));
                            if (caseMap.keySet().contains('Account')) {
                                System.debug('#l Account '+ JSON.serialize(caseMap.get('Account')));
                                //Account acc = (Account) caseMap.get('Account');
                                Map<String, Object> accMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseMap.get('Account')));
                                if (accMap.keySet().contains('OCSAreaId__c')) {
                                    String OCSAreadId = String.valueOf(accMap.get('OCSAreaId__c'));
                                    if (q281List.contains(OCSAreadId)) {
                                        caseToQ281.add(c);
                                    } else if(q285List.contains(OCSAreadId)) {
                                        caseToQ285.add(c);
                                    } else if(q286List.contains(OCSAreadId)) {
                                        caseToQ286.add(c);
                                    } else if(q287List.contains(OCSAreadId)) {
                                        caseToQ287.add(c);
                                    }
                                }
                            }
                        }
                        List<Group> groupes = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN ('Q281', 'Q285', 'Q286', 'Q287') Order BY DeveloperName];
                        Map<String, Id> groupeMap = new Map<String, Id>();
                        for (Group gr : groupes) {
                            groupeMap.put(gr.DeveloperName, gr.Id);
                        }
                        System.debug('#l groupeMap keySet '+ groupeMap.keySet());
                        System.debug('#l groupeMap '+ JSON.serialize(groupeMap));
                        
                        if (!q281List.isEmpty()) {
                            if (groupeMap.keySet().contains('Q281')) {
                                for (Case c : caseToQ281) {
                                    c.OwnerId = groupeMap.get('Q281');
                                    casesToUpDate.add(c);
                                }
                            }                        
                        }
                        if (!q285List.isEmpty()) {
                            if (groupeMap.keySet().contains('Q285')) {
                                for (Case c : caseToQ285) {
                                    c.OwnerId = groupeMap.get('Q285');
                                    casesToUpDate.add(c);
                                }
                            }                        
                        }
                        if (!q286List.isEmpty()) {
                            if (groupeMap.keySet().contains('Q286')) {
                                for (Case c : caseToQ286) {
                                    c.OwnerId = groupeMap.get('Q286');
                                    casesToUpDate.add(c);
                                }
                            }
                        }
                        if (!q287List.isEmpty()) {
                            if (groupeMap.keySet().contains('Q287')) {
                                for (Case c : caseToQ287) {
                                    c.OwnerId = groupeMap.get('Q287');
                                    casesToUpDate.add(c);
                                }
                            }
                        }
                        if (casesToUpDate.size() >= 1) {
                            try {
                                update casesToUpDate;
                                System.debug('#l cases '+ JSON.serialize(casesToUpDate));
                            } catch (Exception e) {
                                System.debug('#l error '+ e.getCause() + ' '+ e.getMessage());
                            }
                        } else {
                            System.debug('#l nothing to do');
                        }
                    }
                }           
            }
        }
    }
}