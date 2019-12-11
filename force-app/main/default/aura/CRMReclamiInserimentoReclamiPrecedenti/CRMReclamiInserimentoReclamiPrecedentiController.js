({
    init:function(cmp,event,helper){
        helper.setColumns(cmp);
        helper.initHelper(cmp);
    },

    handleChange:function(cmp,event,helper){
        helper.initHelper(cmp);
    },
    
    selectReclamo:function(cmp,event,helper){
        cmp.set('v.reclamoSelezionato',event.getParam('selectedRows')[0]);
    },
    
    annulla:function(cmp,event,helper){
        cmp.set('v.reclamoSelezionato',null);
        cmp.set('v.selectedRows',[]);
    }
})