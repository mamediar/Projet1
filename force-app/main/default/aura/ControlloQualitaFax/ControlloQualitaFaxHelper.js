({
    setOptions : function(cmp) {
        cmp.set('v.valutazioneOptions', [
            {label:'SI', value:'SI'},
            {label:'NO', value:'NO'} 
        ]);
    },
    
    setToastTaskSuccess : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'Controllo qualità effettuato',
            type : 'success',
            message : ' '
        });
        toast.fire();        
    },
    
    setToastTaskFail : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'Attenzione! Non hai valorizzato un campo',
            type : 'error',
            message : ' '
        });
        toast.fire();        
    },
    
    setToastUpdateOwnerTask : function(cmp,event,helper){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            title : 'Sembrerebbe che hai cambiato l owner del caso...',
            type : 'error',
            message : ' '
        });
        toast.fire();        
    },
    
    checkInputData : function(cmp,event,helper){
        var bool = false;
        var identificazione = cmp.get('v.identificazioneValue');
        var operativita = cmp.get('v.operativitaValue');
        var noteOCS = cmp.get('v.noteOCSValue');
        var archiviazione = cmp.get('v.archiviazioneValue');
        var sla = cmp.get('v.slaValue');
        
        if((identificazione != null && identificazione != undefined && identificazione != '') &&
           (operativita != null && operativita != undefined && operativita != '') &&
           (noteOCS != null && noteOCS != undefined && noteOCS != '') &&
           (archiviazione != null && archiviazione != undefined && archiviazione != '') &&
           (sla != null && sla != undefined && sla != '')){
            
            bool = true;
        }
        return bool;
    }
     
})