/**
 * @File Name          : PV2564AzzeramentoSpeseLista.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 16/10/2019, 14:21:35
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/8/2019, 23:01:55   Andrea Vanelli     Initial Version
**/

public class PV2564AzzeramentoSpeseLista   {

    @AuraEnabled
    public static OCSRecuperaSpeseAzzeraRecInvoker.Response recuperaSpeseAzzeramentoRecupero(String numPratica, String tipoPratica, Id caseId){
		OCSRecuperaSpeseAzzeraRecInvoker.Response res = OCSRecuperaSpeseAzzeraRecInvoker.invoke(numPratica, tipoPratica);
        if (caseId != null) {
        	// AV TODO leggere la tabella PostVendita_psv_azzer_sel (sarà da fare in gestione)
            List<OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO> elencoSpese = res.elencoSpese;

            List<psv_azzer_sel__c> speseSelezionate = [SELECT sel_id__c, cod_orig_sel__c FROM psv_azzer_sel__c WHERE codice_case__c =: caseId];   
            for (psv_azzer_sel__c spesaSelezionata : speseSelezionate) {
                for (OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO spesaOrigine : elencoSpese) {

                    // converto vecchio id con nuovo id
                    // chiamata B2bsoap per sostituire l'id
                    //spesaSelezionata.sel_id__c = nuovoID
                    // AV TODO in attesa di Ivan/Maurizio in quanto ApiRest__c non accetta il nome lungo recuperaConversioneSpeseAzzeramentoRecupero
/* codice da implementare
prendo i dati dal id creato 
        			Long prg = null;
          			  String tip = "";
			String loanType = "";
			Long pratica = null;

				loanType = selId.substring(0,2);
            	pratica = (new Long(selId.substring(2,14).trim())); 
            	prg = (new Long(selId.substring(15,19)));
                tip = selId.substring(14,15);

                dati di chiamata
                recuperaConversioneSpeseAzzeramentoRecupero
					requestDecod.setNumPratica(pratica.toString());
					requestDecod.setTipoPratica(loanType);
					requestDecod.setTipoSpesa(tip);
					requestDecod.setVecchioProgressivo(prg.toString());
*/
                    if(spesaOrigine.customID.equals(spesaSelezionata.sel_id__c)) {
                        spesaOrigine.selezioneOriginale = 'S';
                    }
                }
            }

            res.elencoSpese = elencoSpese;
        }
        return res;
    } 





}