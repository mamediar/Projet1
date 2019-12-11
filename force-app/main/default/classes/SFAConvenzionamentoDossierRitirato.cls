@RestResource(urlMapping='/RitiroDossier/*')
//::  /services/apexrest/RitiroDossier/dossierRitiratoDaIDM
global with sharing class SFAConvenzionamentoDossierRitirato {  
	
    public static final String modalitaRitiroPostaCompass='PostaCompass';
    public static final String modalitaRitiroSmistamento='Smistamento';
    
    
    @HttpPost
    global static esitoChiamata creazioneAttivitaSegnalazioneDealer(InputChiamata req) {
        esitoChiamata resp = new esitoChiamata(); 
		String titleNote;

        try{ 
            List<Dossier__c> dossier=[SELECT Id, IdAttivita__c FROM Dossier__c WHERE BarCode__c =:req.barCode];
            if(dossier.size()>0){
                if(req.modalitaRitiro==modalitaRitiroPostaCompass){
                    XCSNoteUtils.postANote(dossier[0].IdAttivita__c,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_DOSSIER_RITIROIDM_POSTA);
                } else if(req.modalitaRitiro==modalitaRitiroSmistamento){
                    XCSNoteUtils.postANote(dossier[0].IdAttivita__c,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_DOSSIER_RITIROIDM_SMISTAMENTO); 
                } else {
                    resp.error=1;
                    resp.message='Modalità ritiro errata.';
                }
            } else {
                resp.error=1;
                resp.message='Attività non trovata.';                
            }
            System.debug('Error riga 197:: '+resp.error);
        }catch (Exception ex) {
            System.debug('***riga 202');
            resp.message=ex.getMessage();
            resp.error=1;  
            System.debug('Error riga 204:: '+resp.error);
        }

        return resp;
    }
    
    
    global class InputChiamata {
        global String barCode;
        global String modalitaRitiro;   //può valere solo i seguenti due valori: "PostaCompass" oppure "Smistamento"
    }    
    
    
    
    global class esitoChiamata{
        global Integer error;
        global String message;
    }
    
    
    
}