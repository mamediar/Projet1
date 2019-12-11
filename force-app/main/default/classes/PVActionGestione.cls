/**
 * @File Name          : PVActionGestione.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 15/10/2019, 15:37:05
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-17 15:30:15   Andrea Vanelli     Initial Version
**/
public without sharing abstract class PVActionGestione {

	static final String Status_PV_Da_Processare = 'PV_Da_Processare';


	private static boolean isValid(PVForm form){
		return true;
	}
	public static void saveUtil(PVForm form, Case theCase, String note){
		if(isValid(form)) {
            // 
			if (form.newStatus == 'Closed') {
				theCase.Status = Status_PV_Da_Processare;	
			} else {
	            theCase.Status = form.newStatus;
			}

			//system.debug('****   theCaseSalvato aaaaaaaaaaaaa : ' + theCase);
			upsert theCase;
			if(theCase.Id != null) {
				system.debug('****   theCase : ' + theCase.Id);
				system.debug('****   note : ' + note);
                postANotePV(theCase.Id,'Nota PostVendita',note);
				// AV TODO le note OCS ???
				/**
				                    List<String> parametriTemplateNota = preparaParametriTemplateNotaCommon(form,theCase,notaSpecificaPV);
				   String note=buildBodyPostVendita(parametriTemplateNota,form.categoriaPV.XCS_Template__r.Body__c);
				   postANotePV(theCase.Id,'Nota PostVendita',note);
				   note=buildHeadAndFoot(theCase.Id,parametriTemplateNota,form.categoriaPV.XCS_Template__r.Body__c,form.categoriaPV.Name);
				   XCS_Messaggio__c xcs_messaggio = preparaMessaggioOCSCommon(form,note);
				   insert xcs_messaggio;
				 */
				//inserimento allegati
				/*
				for(Attachment allegato : form.attachmentList) {
					allegato.Body = EncodingUtil.base64Decode(allegato.Body + '');
					allegato.ParentId = theCase.Id;
					insert allegato;
				} */
			}
		}
	}

	public static String loggaException(Exception e){
		system.debug('-- ERRORE PVAction: ' + e.getMessage());
		system.debug(e.getStackTraceString());
		system.debug('-- FINE ERRORE PVAction--');
		return e.getMessage();
	}

	public static void gestisciException(String messaggio_errore){
		throw new AuraHandledException('Si è verificato un errore: ' + messaggio_errore);
	}

	public static void postANotePV(String recordId,String title,String body){
		system.debug('****   body : ' + body);
		//sabrina: se body è null va in Eccezione, sistemato
		//if (!body.equals('')) {
		if (String.isNotEmpty(body)) {
			String formattedBody = body.replaceAll('<br>','\n');
			XCSChatterUtils.postMessagePV(recordId, formattedBody);

		}
	}
}