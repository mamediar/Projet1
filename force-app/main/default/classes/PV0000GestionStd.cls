/**
 * @File Name          : PV0000GestionStd.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 18/8/2019, 12:17:04
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-18 12:30:00   Andrea Vanelli     Initial Version
 **/
public class PV0000GestionStd extends PVActionGestione {

	public class PV0000GestionStdForm extends PVForm {

	}


	@AuraEnabled
	public static void saveCase(PV0000GestionStdForm form, Case theCase){
		String messaggio_errore = '';
		//form.userData.descrizioneReason = 'ciao';
		try{

			system.debug(form);
			//OCSCliente cliente = myForm.cliente;

			// modifico il case
			// se voglio forzare lo stato devo modificare form.newStatus
			String note = creaNote(form, theCase);
			saveUtil(form, theCase, note);

		}catch(Exception e) {                    messaggio_errore = loggaException(e);          }finally{                       if(messaggio_errore != '') {                                                    gestisciException(messaggio_errore);                    }}


	}

	private static String creaNote(PVForm myform, Case theCase) {
		return myForm.note;
	}


}