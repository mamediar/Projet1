/**
 * @File Name          : PV3257VariazioneModInvioECController.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 18/10/2019, 17:18:47
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/10/2019   Federico Negro     Initial Version
**/
({
    //valorizza il campo email su carta con quanto presente nel campo email su anagrafica
    copiaMailAnagrafica: function (cmp) {
        if (cmp.get("v.PVForm.cliente.email") != null && cmp.get("v.infoCartaData.emailCarta") != null) {
            cmp.set("v.infoCartaData.emailCarta", cmp.get("v.PVForm.cliente.email"));
        }
    }
});