public with sharing class IntegrativoPenetrazioneCnt {
/**
 * @description:get all list of intervista where Type__c='Penetrazione'
 * @date: 11/07/2019
 * @author: Aminata GUEYE
 * @params: none
 * @return: Map<String,Object>
 * @modification: Method Only for Intervista_integrativo__c
 */
   @AuraEnabled
public static Map<String,object> getAllIntervistaWithoutFilter(){
	Map<String, Object> response = new Map<String, Object>();
	Integer currentMonth = System.today().month();
	response.put('error',false);
	List <COM_Comodity_Questionario__c> customSettings = new List<COM_Comodity_Questionario__c> ();
	
	try {
		List<Intervista_integrativo__c > interiewsList = new List<Intervista_integrativo__c >();
		interiewsList   =   [SELECT LastModifiedDate,Owner.Name, COM_Num_Non_Risponde__c, COM_Num_richiamare__c, COM_Richiamare_il__c, COM_Current_Period__c, COM_Data_Esito__c, COM_Intervista_Number__c, COM_Ultimo_Esito__c, Limite_mensile__c, Note__c, Durata_Sanitarie__c, Ac_Cap__c,
		                     Ragione_Sociale_Intermediario__c, Imp_Liquidato__c, Imp_Capitale__c, Num_Rate__c, Imp_Rata__c, Ac_Telefono_Sede__c, Ac_Telefono_Cel__c, Ac_Telefono_2__c, Ac_Telefono__c, Ac_Sesso__c, Ac_Rag_Sociale_2__c, Ac_Rag_Sociale_1__c, CodiceServizio5__c, CodiceServizio4__c,
		                     CodiceServizio3__c, CodiceServizio2__c, CodiceServizio1__c, Plc_Tipo_Prodotto__c,
		                     Plc_Agente__c, Plc_Convenzionato__c, Plc_Prodotto__c, Plc_Cliente__c, Data_Liquidazione__c,
		                     Stato__c, Status__c, Type__c, Name, Id, Regione__c, Area__c, Plc_filiale__c, COM_Data_Scadenza_Recesso__c, COM_Intervista_Utile__c, COM_data_caricamento__c,
		                     Ac_Nascita_Luogo__c, Ac_Nascita_Data__c, Ac_Provincia__c, Ac_Localita__c, Ac_Indirizzo_1__c
		                     FROM Intervista_integrativo__c
		                     WHERE COM_Current_Period__c=true AND Type__c='Penetrazione'
		                                                  ORDER BY COM_Richiamare_il__c DESC NULLS LAST, Data_Liquidazione__c DESC NULLS LAST];

		response.put('data',interiewsList);
		customSettings = COM_Comodity_Questionario__c.getall().values();
		response.put('customSettings',customSettings);

		List<AggregateResult> result = [SELECT Ragione_Sociale_Intermediario__c, COUNT(Id) countConclus FROM Intervista_integrativo__c WHERE COM_Current_Period__c=true AND Type__c='Penetrazione' AND Stato__c = 'Conclusa' AND Status__c = 'Archived' GROUP BY Ragione_Sociale_Intermediario__c];

		response.put('countConclus',result);
	} catch (Exception e) {
		response.put('error',true);
		response.put('message',e.getMessage());
		response.put('cause',e.getCause());
		System.debug('message debug: '+e.getMessage());
		System.debug('Cause debug: '+e.getCause());
	}
	return response;
}

@AuraEnabled
public static Map<String,Integer> countInterviewProduct(){

	Integer currentMonth = System.today().month();
	List<String> productList = new List<String> { 'PA', 'PF', 'PP Borg', 'PP Altri' };
	Map<String,Integer> response = new Map<String,Integer>();
	Integer totalPA = 0;
	Integer conclusaPA = 0;
	Integer totalPF = 0;
	Integer conclusaPF = 0;
	Integer totalPPBorg = 0;
	Integer conclusaPPBorg = 0;
	Integer totalPPAltri = 0;
	Integer conclusaPPAltri = 0;

	try {
		response.put('PAConclusa',conclusaPA);
		response.put('PATotal', totalPA);
		response.put('PFConclusa', conclusaPF);
		response.put('PFTotal', totalPF);
		response.put('PPBorgConclusa', conclusaPPBorg);
		response.put('PPBorgTotal', totalPPBorg);
		response.put('PPAltriConclusa', conclusaPPAltri);
		response.put('PPAltriTotal', totalPPAltri);
      if (!Intervista_integrativo__c.sObjectType.getDescribe().isAccessible()) {
			throw new AuraHandledException('Non hai accesso');
		}
		List<Intervista_integrativo__c> intervistaList = [  SELECT ID,NAME,Data_Liquidazione__c,Stato__c,Plc_Prodotto__c,Plc_Tipo_Prodotto__c
		                                                    FROM Intervista_integrativo__c
		                                                    WHERE CALENDAR_MONTH(Data_Liquidazione__c) =: currentMonth AND Type__c='Penetrazione'] ;

		if (!intervistaList.isEmpty()) {
			for (Intervista_integrativo__c intervista : intervistaList) {
				for (String prod : productList) {
					if (intervista.Plc_Tipo_Prodotto__c == prod) {
						String stato = intervista.Stato__c;
						switch on intervista.Plc_Tipo_Prodotto__c {
							when 'PA' {
								totalPA++;
								//System.debug('totalPA: '+totalPA);
								response.put('PATotal', totalPA);
								if (stato == 'Conclusa') {
									conclusaPA++;
									//System.debug('conclusaPA: '+conclusaPA);
									response.put('PAConclusa', conclusaPA);
								}
								break;
							}
							when 'PF' {
								totalPF++;
								response.put('PFTotal',totalPF );
								if (stato == 'Conclusa') {
									ConclusaPF++;
									response.put('PFConclusa',ConclusaPF);
								}
								break;
							}
							when 'PP Borg' {
								totalPPBorg++;
								response.put('PPBorgTotal', totalPPBorg);
								if (stato == 'Conclusa') {
									conclusaPPBorg++;
									response.put('PPBorgConclusa', conclusaPPBorg);
								}
								break;
							}
							when 'PP Altri' {
								totalPPAltri++;
								response.put('PPAltriTotal', totalPPAltri);
								if (stato == 'Conclusa') {
									conclusaPPAltri++;
									response.put('PPAltriConclusa', conclusaPPAltri);
								}
								break;
							}
						}

					}
				}
			}
		}

	} catch (Exception e) {
		System.debug(e.getCause());
		System.debug(e.getMessage());
	}
	System.debug('countInterviewProduct>>>'+response);
	return response;
}

@AuraEnabled
public static Intervista_integrativo__c updateIntervista (Intervista_integrativo__c param){
	try {
		upsert param;
		return param;
	} catch (DmlException e) {
        String message = 'error message: '+e.getMessage();
        AuraHandledException eAura = new AuraHandledException('message');
        eAura.setMessage(message);
        throw eAura;
	}
	
}


@AuraEnabled
public static Map<String,Object> getCommodityCheck(Intervista_integrativo__c interviewObj)
{
	Map<String,Object> mapCommodityCheck=new Map<String, Object>();
	List<COM_CRMComodity_Check_Asc_Desc__c> listCOM = new List<COM_CRMComodity_Check_Asc_Desc__c>();
	List<String> listOfStringCSERV = new List<String>();
	List<String> listOfStringCSERVNotExist = new List<String>();
	mapCommodityCheck.put('error',false);
	Integer indexOfFlag = 0;
	Integer assicurazioneCount = 0;
	if (!COM_CRMComodity_Check_Asc_Desc__c.sObjectType.getDescribe().isAccessible()) {
		throw new AuraHandledException('Non hai accesso');
	}else{
		ListOfStringCSERV = getCodiceServizio(interviewObj);

		if(ListOfStringCSERV.size() > 0 )
		{
			List<String> listComCSERV = new List<String>();
			try{
				listCom = [SELECT Id,COM_CRMTipo__c,Name,
						COM_CRMDefinizione__c,
						COM_CRMflag_prod_sani_non_conn__c,
						Descrizione__c,
						COM_CRMTermini_Recesso__c,
						COM_CRMEstinzione__c
						from COM_CRMComodity_Check_Asc_Desc__c
						WHERE Name in : ListOfStringCSERV];
				for(COM_CRMComodity_Check_Asc_Desc__c comodityCheck: listCom) {
					//Check if one of the insurances does not have a non-connected company
					if (comodityCheck.COM_CRMflag_prod_sani_non_conn__c == 'S') {
						indexOfFlag++;
					}
					listComCSERV.add(comodityCheck.Name);
				}
				listOfStringCSERVNotExist = new List<String>(findDifferent(listComCSERV, ListOfStringCSERV));

			} catch (QueryException e) {
				mapCommodityCheck.put('error',true);
				mapCommodityCheck.put('message',e.getMessage());
				mapCommodityCheck.put('cause',e.getCause());
			}
		}
		mapCommodityCheck.put('index',indexOfFlag);
		mapCommodityCheck.put('listCom',listCom);
		mapCommodityCheck.put('assicurazioneCount',listCom.size());
		mapCommodityCheck.put('listOfStringCSERVNotExistCount',listOfStringCSERVNotExist.size());
		mapCommodityCheck.put('listOfStringCSERVNotExist',listOfStringCSERVNotExist);
		return mapCommodityCheck;
	}
	
}

/**
 * @description: Add Response
 * @date::01/04/2019
 * @author: Khadim Rassoul Ndeye
 * @params: respdomanda | Risposte__c
 * @return: Risposte__c
 * @modification:
 */
@AuraEnabled
public static Risposte__c addResponse(Risposte__c respdomanda){
	respdomanda.Type__c = 'Integrativo Penetrazione';
	try {
		upsert respdomanda;
		return respdomanda;
	} catch (DmlException e) {
		throw new AuraHandledException('error message: '+e.getMessage());
	}
	
}

/**
 * @description:Insert Pratica Escluso
 * @date:
 * @author: Khadim Rassoul Ndeye
 * @params: data | List<String>
 * @return: Map<String,Object>
 */
@AuraEnabled
public static Map<String,object> savePraticaEscluso(List<String> data){
	System.debug('data>>: '+data);
	Map<String, Object> response = new Map<String, Object>();
	response.put('error',false);
	List<Com_integr_crit_esclusioni__c> esclusioni = new List<Com_integr_crit_esclusioni__c>();
	if (!Com_integr_crit_esclusioni__c.sObjectType.getDescribe().IsCreateable()) {
		throw new AuraHandledException('Non hai accesso');
	}else{
		try {
			for(String item : data) {
				if(!String.isEmpty(item)){
					Com_integr_crit_esclusioni__c esclu = new Com_integr_crit_esclusioni__c();
					esclu.Codice_Pratica__c = integer.valueof(item);
					esclusioni.add(esclu);
				}
			}
			insert esclusioni;
			response.put('data',esclusioni);
		} catch (Exception e) {
			response.put('error',true);
			response.put('message',e.getMessage());
			response.put('cause',e.getCause());
			System.debug('message debug: '+e.getMessage());
			System.debug('Cause debug: '+e.getCause());
		}
		return response;
	}
}
/**
 * @description:get List CodiceServizio of intervista
 * @date:
 * @author: Khadim Rassoul Ndeye
 * @params: intervista | Intervista_integrativo__c
 * @return: List<String>
 */
private static List<String> getCodiceServizio(Intervista_integrativo__c intervista){
	// Get ApiName of Intervista_integrativo__c field
	Schema.DescribeSObjectResult describe = Intervista_integrativo__c.sObjectType.getDescribe();
	List<String>apiNames =  new list<String>();
	List<String>listOfStringCSERV = new List<String>();
	for(string apiName : describe.fields.getMap().keySet()) {
		if(apiName.contains('codiceservizio') ) {
			if( intervista.get(apiName) != null) {
				String value = String.valueof(intervista.get(apiName));
				listOfStringCSERV.add(value);
			}
		}
	}
	return listOfStringCSERV;
}
/**
 * @description:Find difference between two lists
 * @author: Khadim Rassoul Ndeye
 * @params: list1 | List<String>
 * @params: list2 | List<String>
 * @return: Set<String>
 */
private static Set<String> findDifferent(List<String> list1, List<String> list2)
{
	Set<String> differences = new Set<String>();
	differences.addAll(list1);
	//This assumes list2 doesn't not contain dupes, if it might then first convert it to a set
	for(String item : list2)         
	{
		if( !differences.add(item) ) 
		{
			differences.remove(item); 
		}
	}
	return differences;
}

}