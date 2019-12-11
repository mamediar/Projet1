/**
 * @File Name          : PV1760CopiaContrattoGestione.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-20 12:23:00
 * @Modification Log   :
 * Ver       Date            Author                         Modification
 * 1.0    2019-9-19   Lorenzo Marzocchi     Initial Version
 **/
public without sharing class PV1760CopiaContrattoGestione extends PVActionGestione {

	public class PV1760CopiaContrattoGestioneForm extends PVForm {

	}

	public class ComunicazioniOCSListDTO {
		@AuraEnabled public String Tipologia {get; set;}
		@AuraEnabled public String Codice {get; set;}
	}

	@AuraEnabled
	public static void saveCase(PV1760CopiaContrattoGestioneForm form, Case theCase){
		String messaggio_errore = '';

		try{
			system.debug(form);
			String note = creaNote(form, theCase);
			saveUtil(form, theCase, note);
		}catch(Exception e) {                    messaggio_errore = loggaException(e);          }finally{                       if(messaggio_errore != '') {                                                    gestisciException(messaggio_errore);                    }}
	}

	private static String creaNote(PVForm myform, Case theCase) {
		return '';
	}
}