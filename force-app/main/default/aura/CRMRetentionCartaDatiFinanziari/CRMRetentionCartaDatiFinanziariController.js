({
	init : function(cmp, event, helper) 
    {
        var datiCarta = cmp.get("v.codicePratica");
        if(!(datiCarta == null || datiCarta === undefined || datiCarta == ''))
        {
            console.log("Dentro IF DATICARTA");
            var action = cmp.get("c.getDatiFinanziari");
            action.setParams({"codiceCarta" : datiCarta });
            action.setCallback(this, function(response) 
            {
				if ( response.getState() == 'SUCCESS' ) 
                {
                	var res = response.getReturnValue();
					res.datiCartaDatiFinanziariResponse.riservaSalvadanaioFidoDivide = res.datiCartaDatiFinanziariResponse.riservaSalvadanaioFido / 100;
                    res.datiCartaDatiFinanziariResponse.riservaSalvadanaioSaldoDivide =  res.datiCartaDatiFinanziariResponse.riservaSalvadanaioSaldo / 100;
                    res.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispDivide = res.datiCartaDatiFinanziariResponse.riservaSalvadanaioDisp / 100;
                    res.datiCartaDatiFinanziariResponse.riservaSalvadanaioSconfinoDivide = res.datiCartaDatiFinanziariResponse.riservaSalvadanaioSconfino / 100;
                    res.datiCartaDatiFinanziariResponse.riservaSalvadanaioOverlimitDivide = res.datiCartaDatiFinanziariResponse.riservaSalvadanaioOverlimit / 100;
                    res.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispTeorMaxDivide = res.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispTeorMax / 100;
                    res.datiCartaDatiFinanziariResponse.riservaPrincipaleFidoDivide = res.datiCartaDatiFinanziariResponse.riservaPrincipaleFido / 100;
                    res.datiCartaDatiFinanziariResponse.riservaPrincipaleDispDivide = res.datiCartaDatiFinanziariResponse.riservaPrincipaleDisp / 100;
                    res.datiCartaDatiFinanziariResponse.riservaPrincipaleSaldoDivide = res.datiCartaDatiFinanziariResponse.riservaPrincipaleSaldo / 100;
                    res.datiCartaDatiFinanziariResponse.riservaPrincipaleSconfinoDivide = res.datiCartaDatiFinanziariResponse.riservaPrincipaleSconfino / 100;
                    res.datiCartaDatiFinanziariResponse.riservaPrincipaleOverlimitDivide = res.datiCartaDatiFinanziariResponse.riservaPrincipaleOverlimit / 100;
                    res.datiCartaDatiFinanziariResponse.riservaPrincipaleDispTeorMaxDivide = res.datiCartaDatiFinanziariResponse.riservaPrincipaleDispTeorMax / 100;
                    res.datiCartaDatiFinanziariResponse.fidoTotaleDivide = res.datiCartaDatiFinanziariResponse.fidoTotale / 100;
                    res.datiCartaDatiFinanziariResponse.dispTotaleDivide = res.datiCartaDatiFinanziariResponse.dispTotale / 100;
                    
                    cmp.set("v.cartaDatiFinanziari",res);
                    console.log("DATI CARTA : " + JSON.stringify(res));                    
                }   
            });
            $A.enqueueAction(action);
        }
	}
})