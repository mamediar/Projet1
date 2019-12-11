public class SchedaVerificaFilialeStampaPDFController {
    public List<Pratica_Scheda_Filiale__c> listaPratiche {get;set;}
    public List<Questionario_Scheda_Filiale__c > listaQuestionari {get;set;}
    public String nomeFiliale {get;set;}
    public String periodoDal {get;set;}
    public String periodoAl {get;set;}
    public String responsabileDal {get;set;}
    public Scheda_Verifica_Filiale__c scheda {get;set;}
    public String coordinatore {get;set;}
    public String internalAuditing {get;set;}
    public String dataCreazione {get;set;}
    public Boolean showListaPratiche {get;set;}
    public Boolean showIntestazioneScheda{get;set;}
    public Boolean showQuestionario{get;set;}
    public String nomePdf {get;set;}
    
    public SchedaVerificaFilialeStampaPDFController(){
        showListaPratiche = false;
        showIntestazioneScheda = false;
        
        
    }
    
    public void init(){
		
		
        String schedaFiliale = ApexPages.currentPage().getParameters().get('schedaId');
		       
        System.debug('schedafiliale--> '+schedaFiliale);
        Boolean stampaPDF = ApexPages.currentPage().getParameters().get('stampaPDF') == 'true';
        Boolean stampaPratiche = ApexPages.currentPage().getParameters().get('stampaPratiche') == 'true';
        Boolean stampaQuestionario = ApexPages.currentPage().getParameters().get('stampaQuestionario') == 'true';
        
        showIntestazioneScheda 	= stampaPDF || stampaQuestionario;
        showListaPratiche 		= stampaPratiche || stampaPDF;
        showQuestionario 		= stampaQuestionario;      
        
        List<Scheda_Verifica_Filiale__c> schede = [SELECT ID,filiale__r.Name,Periodo_dal__c,Periodo_al__c,Responsabile_Dal__c, Responsabile_Attuale__c,Responsabile_Precedente__c,Data_Coordinatore__c,Internal_Auditing__c,Considerazioni_Conclusioni__c, CreatedBy.name,Createddate
                  	FROM Scheda_Verifica_Filiale__c WHERE ID = :schedaFiliale];
        if(schede != null && schede.size()==1){
            
            scheda = schede[0];
            
            choosePDFName(scheda, ApexPages.currentPage().getParameters().get('stampaPDF') == 'true', ApexPages.currentPage().getParameters().get('stampaPratiche') == 'true',
                                   ApexPages.currentPage().getParameters().get('stampaQuestionario') == 'true');
            //INTESTAZIONE
            if(showIntestazioneScheda == true || showQuestionario == true){
                popolaIntestazioneScheda(scheda);     
            }
            //LISTA PRATICHE SEMPRE VISIBILI
            if(true){
                popolaListaPratiche(scheda);    
                
            }
            //QUESTIONARIO
            if(showQuestionario == true){
                popolaListaQuestionario(scheda); 
            }
        }
        System.debug('showIntestazioneScheda-->'+showIntestazioneScheda);
        System.debug('showListaPratiche-->'+showListaPratiche);
    }
    
    public void popolaIntestazioneScheda (Scheda_Verifica_Filiale__c scheda){
        nomeFiliale = scheda.Filiale__r.name;
        periodoDal = scheda.Periodo_dal__c!=null ? scheda.Periodo_dal__c.format() :'';      
        periodoAl = scheda.Periodo_al__c!=null? scheda.Periodo_al__c.format() : ''; 
        responsabileDal = scheda.Responsabile_Dal__c!=null? scheda.Responsabile_Dal__c.format() : ''; 
        coordinatore = scheda.Data_Coordinatore__c!=null? scheda.Data_Coordinatore__c.year() +'_'+scheda.Data_Coordinatore__c.month() :'';
        internalAuditing = scheda.Internal_Auditing__c!=null? scheda.Internal_Auditing__c.year() +'_'+scheda.Internal_Auditing__c.month() :'';
        dataCreazione = scheda.Responsabile_Dal__c!=null?scheda.Responsabile_Dal__c.format():'';
    }
    
    public void popolaListaPratiche (Scheda_Verifica_Filiale__c scheda){
     	listaPratiche = [select Id,  Scheda_Verifica_Filiale__c, Canale__c, Cod_Cliente__c, Data_Liquidazione__c, Finanziato__c, Intermediario__c, Numero_Pratica__c, Procedura__c, Prodotto__c, Ragione_Sociale__c, Tipo_Prodotto__c, toLabel(Tipologia__c)
                                                FROM Pratica_Scheda_Filiale__c  
                                                WHERE Scheda_Verifica_Filiale__c=:scheda.ID];
        showListaPratiche = listaPratiche.size()>0;   
    }
    
    public void popolaListaQuestionario (Scheda_Verifica_Filiale__c scheda){
        listaQuestionari = [select Argomento__c, Esito_controllo_Attuale__c, Evidenze_Precedenti__c, Index__c, Note_DR__c, Note_commento_generale__c, Nuova_Scadenza__c, Richiesta_Modifica__c, Rif__c,Tipologia__c , Sezione__c  
                            	from Questionario_Scheda_Filiale__c 
                           		where Scheda_Verifica_Filiale__c=:scheda.ID order by Index__c asc];
        
    }
    
    public void choosePDFName (Scheda_Verifica_Filiale__c scheda, Boolean stampaPDF, Boolean stampaPratiche, Boolean stampaQuestionario){
        String periodoDal = '';
        if(stampaPDF == true){
            if(scheda.Periodo_dal__c!=null)
            	periodoDal = scheda.Periodo_dal__c.month() + '_' + scheda.Periodo_dal__c.year();
           nomePdf = 'SchedaVisita_'+scheda.Filiale__r.Name.replace(' ','_')+'_'+periodoDal+'.pdf';
        } else {
            if(stampaPratiche == true){
                String day = string.valueOf(system.now().day());
                String month = string.valueOf(system.now().month());
                String hour = string.valueOf(system.now().hour());
                String minute = string.valueOf(system.now().minute());
                String second = string.valueOf(system.now().second());
                String year = string.valueOf(system.now().year());
                  
                String strTime = day+'_'+month+'_'+year+'_'+hour+'_'+minute+'_'+second ;
           		nomePdf = 'ElencoPraticheUsed_'+scheda.Filiale__r.Name.replace(' ','_')+'_'+strTime;
            } else {
               if(stampaQuestionario == true){
           			if(scheda.Periodo_dal__c!=null)
            			periodoDal = scheda.Periodo_dal__c.month() + '_' + scheda.Periodo_dal__c.year();
           			nomePdf = 'SchedaVisita_'+scheda.Filiale__r.Name.replace(' ','_')+'_'+periodoDal+'.pdf';
                    }else{
                        nomePdf = 'error.pdf';    
                    }    
            }      
        }
        
        Apexpages.currentPage().getHeaders().put( 'content-disposition', 'inline; filename='+nomePdf+'.pdf' );
    }

}