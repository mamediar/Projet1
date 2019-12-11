({
	doInit : function(cmp, event, helper) {
		var mydate = new Date();
        cmp.set('v.annoCor', mydate.getFullYear());
        cmp.set('v.meseCor', mydate.getMonth());

	},
    
    recuperaEstrattoConto: function(cmp, event, helper){
		helper.recuperaEstrattoConto(cmp, event, helper);
	}
})