/**
 * @File Name          : MdGestioneDossierController.cls
 * @Description        : This controller is created to give the MdGestioneDossier component the info it needs.
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 09/08/2019 à 11:18:28
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    08/08/2019 à 15:08:20   CISSE Ahmet     Initial Version
**/
public class MdGestioneDossierController {
	public static Map < String,
	Object > response = new Map < String, Object > ();

	@AuraEnabled
	public static Map < String, Object > getInfos(String id) {

		response.put('error', false);

		try {
			Case casex = [SELECT Id, Motivo__c, AccountId, Account.name, Account.getCodice_Cliente__c, Account.DealerPersonaRiferimento__c, Account.DealerPersonaRiferimentoCellulare__c, Account.Dealership_Code__c, Account.Last_Status__c FROM Case WHERE Id = :id];
			Dossier__c dossier = [Select Id, DataRiferimento__c, IdAttivita__c, RagioneSocialeDealer__c, CodiceOCSDealer__c, PartitaIVADealer__c, Autonomia__c FROM Dossier__c where IdAttivita__c = :id];

			if (casex != null) {
                if (casex.Motivo__c != null) {
                  response.put('Motivo__c', casex.Motivo__c);  
                }
                if (casex.Account.getCodice_Cliente__c != null) {
                  response.put('getCodice_Cliente__c', casex.Account.getCodice_Cliente__c);  
                }	
                 if (casex.Account.name != null) {
                  response.put('name', casex.Account.name);  
                }
                if (casex.Account.DealerPersonaRiferimento__c != null) {
                  response.put('DealerPersonaRiferimento__c', casex.Account.DealerPersonaRiferimento__c);  
                }		
                if (casex.Account.DealerPersonaRiferimentoCellulare__c != null) {
                  response.put('DealerPersonaRiferimentoCellulare__c', casex.Account.DealerPersonaRiferimentoCellulare__c);  
                }
                 if (casex.Account.Dealership_Code__c != null) {
                  response.put('Dealership_Code__c', casex.Account.Dealership_Code__c);  
                }	
                if (casex.Account.Last_Status__c != null) {
                  response.put('Last_Status__c', casex.Account.Last_Status__c);  
                }			
			}
			if (dossier != null) {
				if (dossier.RagioneSocialeDealer__c != null) {
					response.put('RagioneSocialeDealer__c', dossier.RagioneSocialeDealer__c);
				}
				if (dossier.CodiceOCSDealer__c != null) {
					response.put('CodiceOCSDealer__c', dossier.CodiceOCSDealer__c);
				}
				if (dossier.PartitaIVADealer__c != null) {
					response.put('PartitaIVADealer__c', dossier.PartitaIVADealer__c);
				}
				if (dossier.Autonomia__c != null) {
					response.put('Autonomia__c', dossier.Autonomia__c);
				}
				if (dossier.DataRiferimento__c != null) {
					response.put('DataRiferimento__c', dossier.DataRiferimento__c);
				}
			}

		} catch(Exception e) {
			response.put('error', true);
			System.debug('cause: ' + e.getCause());
			System.debug('Line N°: ' + e.getLineNumber());
			System.debug('message debug: ' + e.getMessage());
			System.debug('Cause debug: ' + e.getCause());
			System.debug('Line N°: ' + e.getLineNumber());
		}

		return response;

	}

}