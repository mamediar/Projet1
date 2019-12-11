/**
 * @File Name          : PV1763VariazioneAnagraficaGestione.cls   
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              :   
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 2019-6-18 13:56:59
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-18 13:53:24   Andrea Vanelli     Initial Version
**/
public class PV1763VariazioneAnagraficaGestione extends PVActionGestione {

    //lista uffici per controllo BO
    private static final List<String> OFFICES=new List<String>{'BACK','ADMIN'};

	public class PV1763VariazioneAnagraficaForm extends PVForm {
        @AuraEnabled
        public String praticheRetrocesse{get;set;}
        @AuraEnabled
        public String carteDaRitirare{get;set;}

	}

	public PV1763VariazioneAnagraficaGestione() {

	}
    
    @AuraEnabled
	public static VarAnagCheckOutput init(Case theCase,String branch_or_office){
		String messaggio_errore = '';
        Boolean isBO = false;
        String codCliente = '';
        VarAnagCheckOutput varAnagCheckOutput = new VarAnagCheckOutput();
        varAnagCheckOutput.messaggioPrint = '';
        System.debug('branch_or_office : ' + branch_or_office);
		try{
            codCliente = CaseUtils.getOCSAccountId(theCase.Id);
            OCSCliente cliente=OCSObjectsFactory.makeClienti(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(codCliente))[0];
            OCSRecuperaTipoControparteResponse ocsRecuperaTipoControparteResponse=OCSRecuperaTipoControparteInvoker.callRecTipoContr(codCliente);
            if(ocsRecuperaTipoControparteResponse.isFIR()){
                varAnagCheckOutput.messaggioPrint = 'La variazione richiesta è una <b>variazione anagrafica</b> MA il cliente risulta essere <b>FIRMATARIO</b>';    
            }        
            //varAnagCheckOutput.isBO = [select Name from UserRole where Id=:UserInfo.getUserRoleId() and Name in ('BackOffice','BackOffice Manager','ADMIN')].size()>0?true:false;
            System.debug('branch_or_office : ' + branch_or_office);
            varAnagCheckOutput.isBO = OFFICES.contains(branch_or_office)?true:false;
            //system.debug('isBO : ' + varAnagCheckOutput.isBO);                        
            List<OCSPratica> praticheDaRetrocedere = new List<OCSPratica>();
            List<OCSPratica> carteAttive = new List<OCSPratica>();
            System.debug('varAnagCheckOutput.isBO : ' + varAnagCheckOutput.isBO);
            if(varAnagCheckOutput.isBO){
                //estraggo le pratiche da segnalare come da retrocedere
                varAnagCheckOutput.praticheDaRetrocedere = cliente.praticheDaRetrocedere();
                //verifico se la variazione riguarda nome e/o cognome per la riconsegna carte
                system.debug('CaseUtils.getFlagCarte(theCase.Id)' + CaseUtils.getFlagCarte(theCase.Id));  
                if(CaseUtils.getFlagCarte(theCase.Id)){
                    varAnagCheckOutput.carteAttive = cliente.getCarteAttive();    
                    System.debug('varAnagCheckOutput.carteAttive : ' + varAnagCheckOutput.carteAttive.size());
                }
            }
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
        return varAnagCheckOutput;

    }
    @AuraEnabled
	public static void saveCase(PV1763VariazioneAnagraficaForm form, Case theCase){
		String messaggio_errore = '';
        system.debug('form' + form);        
		try{
            //preparo il flag per direzionare il Case a filiale o chiudere
            if(String.isBlank(form.carteDaRitirare)){
                theCase.FlagCarteDaRitirare__c = false;
            }else{
                theCase.FlagCarteDaRitirare__c = true;
            }
		    saveUtil(form, theCase, creaNote(form,theCase));

		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	private static String creaNote(PV1763VariazioneAnagraficaForm form, Case theCase) {
        String nota = '';
        if(!String.isBlank(form.praticheRetrocesse)){
            nota += form.praticheRetrocesse;
        }
        if(!String.isBlank(form.carteDaRitirare)){
            nota += form.carteDaRitirare;
        }
		return nota; 
	}

    public class VarAnagCheckOutput{
        @AuraEnabled
        public Boolean isBO;
        @AuraEnabled
        public String messaggioPrint;
        @AuraEnabled
        public List<OCSPratica> praticheDaRetrocedere;
        @AuraEnabled
        public List<OCSPratica> carteAttive;
    }    


}