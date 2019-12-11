/**
 * @File Name          : PV3267VariazioneIndirizzi.cls
 * @Description        : 
 * @Author             : Raffaele Prudenzano
 * @Group              : 
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 11/11/2019, 10:01:02
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/11/2019   Raffaele Prudenzano     Initial Version
**/

public with sharing class PV3267VariazioneIndirizzi {
    public PV3267VariazioneIndirizzi() {
    }


    @AuraEnabled
	public static List<OCSRecuperaIndirizziClienteResponse.IndirizzoDTO> doRecuperaIndirizziCliente(String codCliente){
    OCSRecuperaIndirizziClienteResponse res = OCSRecuperaIndirizziClienteInvoker.callRecIndirizzi(codCliente);
		return res.recuperaIndirizziClienteResponse.elencoIndirizzi;
	}

}