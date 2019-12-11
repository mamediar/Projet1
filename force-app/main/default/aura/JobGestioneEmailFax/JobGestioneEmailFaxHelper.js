({
    toastSchedulazioniAvviate : function() {
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            'title' : 'Schedulazioni avviate!',
            'type' : 'success',
            'duration' :  20000,
            'message' : 'Seguire il percorso per visualizzare le schedulazioni\n Setup > Environments > Jobs > Scheduled jobs'                   
        });                       
        toast.fire(); 
    },
    
    toastSchedulazioniNonAvviate : function() {
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            'title' : 'Attenzione! Qualcosa è andato storto...',
            'type' : 'error',
            'message' : ' '                   
        });                       
        toast.fire(); 
    },
    
    toastAlgoritmoLanciato : function() {
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            'title' : 'Smistamento Avvenuto',
            'type' : 'success',
            'message' : ' '                   
        });                       
        toast.fire(); 
    },
    
    toastAlgoritmoNonLanciato : function() {
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            'title' : 'Attenzione! Non sono riuscito a smistare!',
            'type' : 'error',
            'message' : ' '                   
        });                       
        toast.fire(); 
    }    
    
})