/**
 * @File Name          : PV1772DaCustomerServAFilialeGestione.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 4/11/2019, 17:54:33
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    29/10/2019   Federico Negro     Initial Version
**/
//PV1772DaCustomerServAFilialeGestione 
public without sharing class PV1772DaCustomerServAFilialeGestione extends PVActionGestione {

	public class PV1772DaCustomerServAFilialeGestioneForm extends PVForm {
		 
	}

	@AuraEnabled
	public static void saveCase(PV1772DaCustomerServAFilialeGestioneForm form, Case theCase){
		String messaggio_errore = '';
        system.debug('form' + form);        
		
		try{
		    saveUtil(form, theCase, creaNote(form,theCase));
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	private static String creaNote(PVForm myform, Case theCase) {
		return myForm.note;
	}

    /*

    Se la richiesta viene effettuata da CS il campo codFiliale viene popolato con  il codice dell'ufficio di destinazione.
    Quando la richiesta viene fatta da batch il campo codFiliale rimane vuoto e il motore di regole reindirizza la richiesta a NumeroBlu.

    */

}