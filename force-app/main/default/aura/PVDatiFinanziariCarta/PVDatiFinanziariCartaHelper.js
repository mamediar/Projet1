({
	Init : function(cmp,event,helper) {
        console.log("dati carta: " + cmp.get("v.cartaDatiFinanziariData.emettitore"));            
        console.log("dati carta: " + JSON.stringify(cmp.get("v.cartaDatiFinanziariData")));            
	},
})