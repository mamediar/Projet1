trigger SchedaVerificaFilialeTrigger on Scheda_Verifica_Filiale__c 
                                                                    (before insert, 
                                                                    after insert, 
                                                                    before update, 
                                                                    after update, 
                                                                    before delete, 
                                                                    after delete, 
                                                                    after undelete) {
    System.debug('______SchedaVerificaFilialeTrigger____START');
    new SchedaVerificaFilialeHandler().run();
    System.debug('______SchedaVerificaFilialeTrigger____DONE');
}