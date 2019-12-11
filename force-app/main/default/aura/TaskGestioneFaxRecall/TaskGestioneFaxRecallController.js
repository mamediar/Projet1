({
    init: function (cmp,event,helper){
        
        console.log('SONO NELL INIT DI TASKGESTIONEFAXRECALLCONTROLLER');
        console.log('RECORDID::::::::> ' +  cmp.get('v.recordIdToChild'));
        var action = cmp.get('c.getRecallMax');
        
        action.setParam('recordId', cmp.get('v.recordIdToChild'));
        action.setCallback(this,function(response){
            console.log('TaskGestioneFaxRecallController Controller.js STATE:::> ' + response.getState() );
            if(response.getState() == 'SUCCESS'){
                cmp.set('v.configRecall', response.getReturnValue());
                console.log('TaskGestioneFaxRecallController Controller.js INIT' + cmp.get('v.configRecall'));
            }
        });
        $A.enqueueAction(action);
        
    },
    
    launchRecall : function(cmp, event, helper) {
        
        if(cmp.get('v.sceltaEsito').toLowerCase() == 'recall') {
            var recallNumber = cmp.get('v.configRecall');
            console.log('recallNumber::::::::> ' + recallNumber);
            var recallCounter =  cmp.get('v.contatoreRecall');
            console.log('recallCounter::::::::> ' + recallCounter);
            var toast = $A.get('e.force:showToast');
            
            if(recallNumber && recallNumber > 0 && recallCounter < recallNumber ) {
                cmp.set('v.showRadioButton', 'true');
                console.log('SHOW RADIO BUTTON ::> ' + cmp.get('v.showRadioButton'));
                
            } else
            {
                toast.setParams({
                    title: (recallNumber > 0) ? 'Numero Massimo di Recall raggiunto' : 'Non è previsto Recall per questa attività',
                    type: 'error',
                    message: ' '
                });
                toast.fire();
                
                (recallNumber == 0) ? cmp.set('v.sceltaEsito', '') : cmp.set('v.sceltaEsito', 'ko');
            }
        } 
        else
            cmp.set('v.showRadioButton', 'false');
    },
    
    setDateTime : function(cmp,event,helper) {
        
        cmp.set('v.dataRecall', cmp.find('dataOraRecall').get('v.value'));
        console.log('DATA RECALL ::::> ' + cmp.get('v.dataRecall'));
    },
    
    dataReset : function (cmp,event,helper){
        
        if(cmp.get('v.sceltaRadioButton') == 'valoreNo'){
            cmp.set( 'v.dataRecall', null );
        }
        
    }
})