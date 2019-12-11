/**
 * @File Name          : PV1768RipristinoRIDGestione.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 29/10/2019, 14:30:05
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    31/7/2019, 18:10:55   sabrina vitali     Initial Version
**/
public class PV1768RipristinoRIDGestione  extends PVActionGestione {
	public class PV1768RipristinoRIDGestioneForm extends PVForm {
        @AuraEnabled
        public String esito{get;set;}
	}

	public PV1768RipristinoRIDGestione() {
	}
    
    @AuraEnabled
	public static void saveCase(PV1768RipristinoRIDGestioneForm form, Case theCase){
		String messaggio_errore = '';
        system.debug('form' + form);        
		try{
			theCase.pv_esito_poste__c = form.esito;				
		    saveUtil(form, theCase, creaNote(form,theCase));
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	private static String creaNote(PV1768RipristinoRIDGestioneForm form, Case theCase) {
        String nota = form.note + '\n';

        if(!String.isBlank(form.esito)){
            nota += 'Esito BO : ' + form.esito;
        }
		return nota; 
	}

}