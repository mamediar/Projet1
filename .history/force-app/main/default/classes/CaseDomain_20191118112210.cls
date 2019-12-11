/**
* @author ADIOP abdoulaye.diop@compass.com.dev
* @date  13/11/2019
* @description
**/
global with sharing class CaseDomain { 

    static final String CONTATTO_NON_ESEGUITO = 'CONTATTO NON ESEGUITO';
    static final String CONTATTO_ESEGUITO = 'CONTATTO ESEGUITO';
    static final String NUMERO_INESISTENTE = 'NUMERO INESISTENTE';
    static final String CLIENTE_NON_TROVATO = 'CLIENTE NON TROVATO';
    static final String CLIENTE_NON_INTERESSATO = 'CLIENTE NON INTERESSATO';
    static final String CONFERMA_VECCHIO_RECAPITO = 'CONFERMA VECCHIO RECAPITO';    
    static final String CONFERMA_NUOVO_RECAPITO = 'CONFERMA NUOVO RECAPITO';
    static final String INVIO_LINK_RIPRESA_BOZZA = 'INVIO LINK RIPRESA BOZZA';
    static final String NESSUNA_ALTRA_AZIONE = 'NESSUNA ALTRA AZIONE';
    static final String NON_INTERESSATO = 'NON INTERESSATO';
    static final String DISCONOSCE_LA_PRATICA  = 'DISCONOSCE LA PRATICA';
    static final String FISSA_APPUNTAMENTO  = 'FISSA APPUNTAMENTO';
    static final String CHIEDE_DI_ESSERE_RICHIAMATO  = 'CHIEDE DI ESSERE RICHIAMATO';
    static final String CARICHERA_LA_DOCUMENTAZIONE = 'Caricherà la documentazione';
    static final String HA_GIA_CARICATO_LA_DOCUMENTAZIONE = 'Ha già caricato la documentazione';
    static final String FIRMERA_IL_CONTRATTO = 'Firmerà il contratto';
    static final String HA_GIA_FIRMATO_IL_CONTRATTO = 'Ha già firmato il contratto';
    static final String INBOUND_ASSISTENZA = 'INBOUND ASSISTENZA';
    static final String INVIO_DEM_RICARICA_PRATICA = 'INVIO DEM RICARICA PRATICA';
    static final String DISCORDANZA_CELLULARE_ESEGUITA = 'DISCORDANZA CELLULARE ESEGUITA';
    static final String IDENTITA_NON_CONFERMATA = 'Identità non confermata';
    static final String RICHIESTA_INFO_GENERICHE_SUL_CARICO = 'RICHIESTA INFO GENERICHE SUL CARICO';

    static final List<String> codesQueue = new List<String>{'Q330', 'Q331', 'Q332'};
    public static Integer tentativo = 3;
    public static Boolean isResolved = false;
    
    /**
     * @Author ADIOP
     * @date  04/06/2019
     * @description Method get a developerName(code) in queue
     * @param String ownerId, the owner of the case
     **/
    global with sharing class Assembly {
        Case caseObject;
        String code; 
        String firstLevel;
        String secondLevel;
        String thirdLevel;
        Boolean showLinkEvo;

        global Assembly(){}

        global Assembly(Case caseObject, String code, String firstLevel, String secondLevel, 
                            String thirdLevel, Boolean showLinkEvo){
            this.caseObject = caseObject;
            this.code = code;
            this.firstLevel = firstLevel;
            this.secondLevel = secondLevel;
            this.thirdLevel = thirdLevel;
            this.showLinkEvo = showLinkEvo;
        }

        global String getEtat(String developerName){
            if (CaseService.checkCaseInQueue(this.caseObject.OwnerId)) {
                switch on developerName {
                    //Discordanza cellulare E-commerce
                    when 'Q337' {
                        Id profileId = UserInfo.getProfileId();
                        String profileName = [Select Id, Name from Profile where Id=:profileId].Name;
                        system.debug('#l ProfileName '+ profileName);
                        if (profileName == 'RTC') {
                            if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == RICHIESTA_INFO_GENERICHE_SUL_CARICO) {
                                    return '10';
                                } else if (this.secondLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA ) {
                                    return '114';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    return '100';
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    return '100';
                                } else {
                                    return '10';
                                }
                            }
                            return '10';
                        }

                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                if(this.showLinkEvo){                                
                                    return '100';
                                }
                                return '101';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '102';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == CONFERMA_VECCHIO_RECAPITO) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    // si esce dalla coda
                                    return '104';
                                }
                            } else if (this.secondLevel.toUpperCase() == CONFERMA_NUOVO_RECAPITO) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                }                    
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '105';                  
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            }
                        }
                    }
                    /*Abbandono web PP * Abbandono non forzoso PP * Abbandono forzoso PP */
                    when 'Q330', 'Q331', 'Q332' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {                                
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '108';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {                          
                                return '103';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {                            
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == FISSA_APPUNTAMENTO) {
                                // opens page to contact center operator of request appointment.
                                return '111';
                            }
                        }
                    }
                    // Abbandono PP Partners
                    when 'Q375' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '108';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                return '103';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == FISSA_APPUNTAMENTO) {
                                return '116';
                            }
                        }
                    }
                    // Anomalie Pre Sic PP
                    when 'Q339' {
                        // if anomalie  review         
                        // Nel caso sia presente una discordanza Cellulare
                        if (this.caseObject.Is_Discordanza_Cellulare__c) {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    isResolved = true;
                                    return '100';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    isResolved = true;
                                    return '102';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CONFERMA_VECCHIO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        isResolved = true;
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        isResolved = true;
                                        return '104';
                                    }
                                } else if (this.secondLevel.toUpperCase() == CONFERMA_NUOVO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        isResolved = true;
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        isResolved = true;
                                        return '104';
                                    }
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    isResolved = true;
                                    return '105'; 
                                    // à ajouter dans la liste                  
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    isResolved = true;
                                    return '106';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    isResolved = true;
                                    return '111';
                                }
                            }
                        } // Nel caso siano presenti solo anomalie documentali (senza discordanza cellulare)
                        else {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    return '109';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    return '119';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        return '104';
                                    } else if (this.thirdLevel == '') {
                                        System.debug('#l 113');
                                        return '113';
                                    }
                                } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    return '107';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    return '111';
                                }
                            }
                        }
                        return '10';
                    }
                    // Anomalie Post Sic PP (à revoir thirdlevel == cliente non trovato)
                    when 'Q340' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                return '109';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '119';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                } else if (this.thirdLevel == '') {
                                    return '113';
                                }
                            } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                return '104';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                return '111';
                            }
                        }
                    }
                    // Sollecito Contratto
                    when 'Q377' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                return '109';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '119';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == FIRMERA_IL_CONTRATTO.toUpperCase()) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                } else if (this.thirdLevel == '') {
                                    return '112';
                                }
                            } else if (this.secondLevel.toUpperCase() == HA_GIA_FIRMATO_IL_CONTRATTO.toUpperCase()) {
                                return '104';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                return '111';
                            }
                        }
                    }
                    // Anomalie PP Partners // Anomalie
                    when 'Q376' {
                        // if anomalie  review
                        // Nel caso sia presente una discordanza Cellulare
                        if (this.caseObject.Is_Discordanza_Cellulare__c) {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    isResolved = true;
                                    return '100';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    isResolved = true;
                                    return '102';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CONFERMA_VECCHIO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        isResolved = true;
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        isResolved = true;
                                        return '104';
                                    }
                                } else if (this.secondLevel.toUpperCase() == CONFERMA_NUOVO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        isResolved = true;
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        isResolved = true;
                                        return '104';
                                    }
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    isResolved = true;
                                    return '105'; 
                                    // à ajouter dans la liste                  
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    isResolved = true;
                                    return '106';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    isResolved = true;
                                    return '111';
                                } else if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    if (this.thirdLevel == '') {
                                        return '113';
                                    }
                                }
                            }
                        } // Nel caso siano presenti solo anomalie documentali (senza discordanza cellulare)
                        else {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    return '109';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    return '119';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        return '104';
                                    } else if (this.thirdLevel == '') {
                                        return '113';
                                    }
                                } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    return '107';
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    return '106';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    return '111';
                                }
                            }
                        }
                        return '10'; 
                    }
                    // default queue
                    when 'Q525' {
                        if (this.firstLevel.toUpperCase() == INBOUND_ASSISTENZA) {
                            if (this.secondLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                return '103';
                            } else if (this.secondLevel.toUpperCase() == INVIO_DEM_RICARICA_PRATICA) {
                                return 'review';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            }
                        }
                    }
                    // Abbandono E-commerce
                    when 'Q336' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {                            
                                return '109';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '108';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {                        
                            if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                } else if (this.thirdLevel == '') {
                                    return '113';
                                }
                            } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                return '104';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                return '111';
                            }
                        }
                    }
                    // CODA ANOMALIE Doc. E-commerce
                    when 'Q338' {
                        // if anomalie  review
                        // Nel caso sia presente una discordanza Cellulare
                        if (this.caseObject.Is_Discordanza_Cellulare__c) {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    return '10';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    return '108';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CONFERMA_VECCHIO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        return '104';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        return '104';
                                    }
                                } else if (this.secondLevel.toUpperCase() == CONFERMA_NUOVO_RECAPITO) {                                    
                                    return '120';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    return '110';                 
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    return '100';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    return '111';
                                    // review
                                } else if (this.secondLevel.toUpperCase() == IDENTITA_NON_CONFERMATA.toUpperCase()) {
                                    return '105';
                                }
                            }
                        } else {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    return '119';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    return '104';
                                }
                            }
                        }
                        return '10';
                    }
                    // Sollecito Contratto PP Partners
                    when 'Q341' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                return '109';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '119';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == FIRMERA_IL_CONTRATTO.toUpperCase()) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                } else if (this.thirdLevel == '') {
                                    return '113';
                                }
                            } else if (this.secondLevel.toUpperCase() == HA_GIA_FIRMATO_IL_CONTRATTO.toUpperCase()) {
                                return '104';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                return '111';
                            }
                        }
                    }
                    when else {
                        return '10';
                    }
                }
            }
            return '10';
        }
    }

    /**
     * @Author ADIOP
     * @date  06/06/2019
     * @description 
     **/
    global interface CaseStateInterface {
        Map<String, Object> action(CaseDomain.CaseContext caseContext);
    }

    /**
     * @Author ADIOP
     * @date  06/06/2019
     * @description 
     **/
    global with sharing class CaseContext {
        private CaseStateInterface caseStateInterface {get; set;} 
        private Case caseObject {get; set;}
        private String developerName {get; set;}
        private Boolean showLinkEvo{get; set;}

        global void setState(CaseStateInterface caseStateInterface) {
            this.caseStateInterface = caseStateInterface;
        }
        
        global CaseContext(Case caseObject, String developerName, Boolean showLinkEvo){
            //this.caseStateInterface = caseStateInterface;
            this.caseObject = caseObject;
            this.developerName = developerName;
            this.showLinkEvo = showLinkEvo;
        }

        public Map<String, Object> action(){
            return caseStateInterface.action(this);
        }
    }

    // for state 100
    global with sharing class ContattoNonEseguitoContext1 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>(); 
            response.put('linkevo', caseContext.showLinkEvo);
            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);            
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    // for state 102
    global with sharing class ContattoNonEseguitoContext2 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            Decimal cmpt = caseContext.caseObject.Tentativo__c;
            /*if (cmpt == null) {
                cmpt = 1;
            } else {
                cmpt++;
            }
            caseContext.caseObject.Tentativo__c = cmpt;
            */                          
            if (cmpt == tentativo) {
                String developerName = caseContext.developerName;
                caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
                response.put('linkevo', caseContext.showLinkEvo);
            }
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    // for state 103
    global with sharing class ContattoNonEseguitoContext3 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
            response.put('case', caseContext.caseObject);
            response.put('linkevo', caseContext.showLinkEvo);
            return response;
        }
    }

    // for state 104
    global with sharing class ContattoNonEseguitoContext4 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);     
            response.put('case', caseContext.caseObject);
            response.put('linkevo', caseContext.showLinkEvo);
            return response;
        }
    }

    // for 
    global with sharing class ContattoNonEseguitoContext5 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>(); 
            response.put('linkevo', caseContext.showLinkEvo);
            //Decimal cmpt = caseContext.caseObject.Tentativo__c;
            /*if (cmpt == null) {
                cmpt = 1;
            } else {
                cmpt++;
            } */                         
           //caseContext.caseObject.Tentativo__c = cmpt;
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    //for status '106'; 
    global with sharing class ContattoNonEseguitoContext6 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);         
            response.put('linkevo', caseContext.showLinkEvo);
            response.put('case', caseContext.caseObject);
            /*
              Viene poi inviata una mail di segnalazione all’ufficio 
              CompassAffari : compassaffari@compass.it.
             */
            return response;
        }
    }

    // for status
    global with sharing class ContattoNonEseguitoContext7 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            Decimal cmpt = caseContext.caseObject.Tentativo__c;
            /*if (cmpt == null) {
                cmpt = 1;
            } else {
                cmpt++;
            }*/                          
            if (cmpt == tentativo) {
                String developerName = caseContext.developerName;
                caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
                response.put('linkevo', caseContext.showLinkEvo);
            }
            //caseContext.caseObject.Tentativo__c = cmpt;
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    // for status 119
    global with sharing class ContattoNonEseguitoContext8 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            Decimal cmpt = caseContext.caseObject.Tentativo__c;
            /*if (cmpt == null) {
                cmpt = 1;
            } else {
                cmpt++;
            }
            caseContext.caseObject.Tentativo__c = cmpt;
            */                       
            if (cmpt == tentativo) {                
                String developerName = caseContext.developerName;
                caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
                response.put('linkevo', caseContext.showLinkEvo);               
            }
            
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    // for state 113
    global with sharing class ContattoNonEseguitoContext9 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();

            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
            response.put('linkevo', caseContext.showLinkEvo);
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    /**
     * @author ADIOP
     * @date 14/11/2019
     * @description change Case Owner
     * @param String developerName the code of the queue
     * @param Case caseObject
     **/
    public static Case changeOwner(Case caseObject, String developerName){
        if (developerName != '') {
            Group gr = CaseService.getQueue(developerName);
            if (gr != null) {
                caseObject.Tentativo__c = null;
                caseObject.OwnerId = gr.Id;
            }
            if (developerName == 'Q524') {
                caseObject.Status = 'Closed';
            }
        }
        return  caseObject;
    }

    /**
     * @author ADIOP
     * @date 30/09/2019
     * @description handle send email dem
     * @param String developerName the name of the queue
     **/
    @future
    public static void mailDem(String dem, Id idCase, String subject, String replyTo, String fromAddress){

        try {            
            Case caseObject = [SELECT Id, RO_Link_Bozza__c, CaseNumber, AccountId, (SELECT Id, codice_Anomalia__c, Codice_Documento__c, 
                descrizione_Documento__c FROM Anomalie_Doc__r) FROM Case WHERE Id=:idCase];
            Contact contact = [Select Email	, Id, FirstName, LastName, DEM_Param_7__c, DEM_Param_8__c, DEM_Param_9__c From Contact WHERE AccountId =:caseObject.AccountId LIMIT 1];
            Account account = [SELECT Id, FirstName, LastName, PersonEmail FROM Account WHERE Id =:caseObject.AccountId LIMIT 1];
            String personName = account.FirstName+' '+account.LastName;
            String nameTemplate = 'DEM' + dem;
            EmailTemplate template = [SELECT Id, HtmlValue, Body  FROM EmailTemplate WHERE Name =:nameTemplate];
            List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            try {
                OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'donotreply@compass.it']; //:fromAddress
                mail.setOrgWideEmailAddressId(owea.Id);
            } catch (Exception e) {
                mail.setSenderDisplayName(fromAddress);
                System.debug('error '+ e.getMessage() + ' '+ e.getStackTraceString());
            }
            mail.setReplyTo('donotreply@compass.it'); //replyTo
            mail.setToAddresses(new String[] {account.PersonEmail, 'mbousso93@gmail.com'});  // ,  account.PersonEmail 'moustapha.diop@lynxspa.com', 'layepythagore.91@gmail.com'
            mail.setTemplateID(template.Id);
            mail.setSaveAsActivity(true);
            mail.setSubject(subject);
            
            String htmlBody = template.HtmlValue;
            String plainBody = template.Body;
            switch on nameTemplate {
                // DEMAbbandonoWEBPreSecci
                when 'DEM2059'{
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', personName);
                    subject = subject.replace('{!Contact.FirstName}', personName);
                    mail.setSubject(subject);
                }
                // DEMAbbandonoWEBPostSecci
                when 'DEM2060'{
                    System.debug('link bozza '+caseObject.RO_Link_Bozza__c);
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', personName);                
                    htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    subject = subject.replace('{!first_name}', personName);
                    mail.setSubject(subject);
                }
                //DEMAbbandonoForz
                when 'DEM2062'{
                    htmlBody = htmlBody.replace('{!first_name}', personName);
                    subject = subject.replace('{!first_name}', personName);
                    mail.setSubject(subject);
                }
                // DEMAnomalieContratto_DS
                when 'DEM2069' {
                    htmlBody = htmlBody.replace('[first_name]', personName);
                    htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    if (caseObject.CaseNumber != null) {
                    htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    } 
                }
                // DEMAnomalieDoc_DS
                when 'DEM2068' {
                    if (personName != null) {
                        htmlBody = htmlBody.replace('{!first_name}', personName);
                    }
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    if (caseObject.Anomalie_Doc__r != null) {
                        String param7 = '';
                        for(Anomalie_Doc__c anomalie : caseObject.Anomalie_Doc__r){
                            param7+= '<p>'+anomalie.codice_Anomalia__c+ ' '+ anomalie.Codice_Documento__c+ ' '+ anomalie.descrizione_Documento__c + '</p> </br>';                            
                        }
                        htmlBody = htmlBody.replace('{!param7}', param7);
                    } 
                }
                // DEMRassicuraCliente_DS
                when 'DEM2725' {
                    htmlBody = plainBody.replace('{!Contact.FirstName}', personName);
                }
                // DEMAnomalieContratto_PP_CB
                when 'DEM2555' {
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace   ('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    //htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    if (caseObject.CaseNumber != null) {
                    htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    }
                }
                // Abbandono E-commerce
                when 'DEM2070' {
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                    if (caseObject.CaseNumber != null) {
                    htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    }
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace   ('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    if (contact.DEM_Param_9__c != null) {
                        htmlBody = htmlBody.replace   ('{!param9}', contact.DEM_Param_9__c);
                    }
                }
                // DEMAnomalieDoc_PP_CB  
                when 'DEM2554' {
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                    htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    }
                }
                // DEMRipresaBozzaEcommerce
                when 'DEM2071' {
                    htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', account.FirstName);
                    htmlBody = htmlBody.replace('{!Contact.LastName}', account.LastName);
                }
                // Anomali Documentalie E-commerce
                when 'DEM2072' {
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);   
                    }
                    if (caseObject.Anomalie_Doc__r != null) {
                        String param7 = '';
                        for(Anomalie_Doc__c anomalie : caseObject.Anomalie_Doc__r){
                            param7+= '<p>'+anomalie.codice_Anomalia__c+ ' '+ anomalie.Codice_Documento__c+ ' '+ anomalie.descrizione_Documento__c + '</p> </br>';                            
                        }
                        htmlBody = htmlBody.replace('{!param7}', param7);
                    }
                }           
                // DEMRipresaBozza_PP_CB
                when 'DEM2553' {
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    } 
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace   ('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                //  Non trovato anomalie pre sic PP
                when 'DEM2064' {
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    } 
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', personName);
                    subject = subject.replace('{!first_name}', personName);
                    mail.setSubject(subject);
                }
                // Non trovato anomalie post sic PP
                when 'DEM2065' {
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    } 
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', personName);
                    subject = subject.replace('{!first_name}', personName);
                    mail.setSubject(subject);
                }
                //
                when 'DEM2566' {
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEM “Non trovato firma contratto PP” DEMNonTrovatoFirmaContratto_PP_MPS
                when 'DEM2565' {
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEM “Non trovato firma contratto PP” DEMNonTrovatoFirmaContratto_PP_CB
                when 'DEM2557' {
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    }
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEM “Non trovato anomalie PP Partners” 
                when 'DEM2556' {
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    }
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEM “Non trovato anomalie PP Partners” 
                when 'DEM2564' {
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    }
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // Numero inesistente firma contratto PP Partners
                when 'DEM2558' {
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    }
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // Cliente non trovato E-commerce
                when 'DEM2073' {
                    // '{!param_localita_fil}'
                    if (contact.DEM_Param_9__c != null) {
                        htmlBody = htmlBody.replace('{!param9}', contact.DEM_Param_9__c);
                    }
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEMRipresaBozza_PP_MPS
                when 'DEM2061' {
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    }
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEMRipresaBozza_DS
                when 'DEM2063' {
                    if (caseObject.CaseNumber != null) {
                        htmlBody = htmlBody.replace('{!param7}', caseObject.CaseNumber);
                    }
                    if (caseObject.RO_Link_Bozza__c != null) {
                        htmlBody = htmlBody.replace('{!param8}', caseObject.RO_Link_Bozza__c);
                    }
                    subject = subject.replace('{!first_name}', personName);
                    mail.setSubject(subject);
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', personName);
                }
                when else {}
            }        
            mail.setHtmlBody(htmlBody);
            allMsg.add(mail);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(allMsg);            
        } catch (Exception ex) {
            System.debug('#l sendTemplatedEmail error. ' + ex.getMessage());
        }
    }

    /**
     * @author ADIOP
     * @date 03/10/2019
     * @description send email dem
     * @param String developerName the name of the queue
     **/
    public static void sendEmailDem(String developerName, Id idCase, String state) {
        try {
            Case caseObject = [SELECT Id, RO_Vecchio_Cellulare__c, Tentativo__c, Product__r.DEMNonTrovatoFirmaContratto__c, 
                Product__r.DEMNonTrovatoAnomalie__c, Product__r.DEMNumeroInesistenteContratto__c, Product__r.DEMRipresaBozza__c  FROM Case WHERE Id=:idCase];
            String nameDEM = 'Inviata mail : ';
            switch on developerName {
                // Discordanza cellulare E-commerce
                when 'Q337' {
                    mailDem('2071', idCase, 'Ripresa Bozza E-commerce', 'noreply@compass.it', 'noreply@compass.it');
                    nameDEM = nameDEM + ' DEMRipresaBozzaEcommerce (2071)';
                } 
                // Abbandono web PP
                when 'Q330' {
                    //noreplay@compass.it
                    //mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento ', 'PrestitoonlineCheBanca@compass.it', 'Compass Banca S.p.A.');
                    mailDem('2561', idCase, 'MPS prestito online: segui l\' andamento del tuo finanziamento', 'richiesta@compass.it', 'richiesta@compass.it');
                    nameDEM = nameDEM + ' DEMRipresaBozza_PP_MPS (2561)';
                } 
                // Abbandono non forzoso PP
                when 'Q331' {
                    //mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento ', 'PrestitoonlineCheBanca@compass.it', 'Compass Banca S.p.A.');
                    mailDem('2561', idCase, 'MPS prestito online: segui l\' andamento del tuo finanziamento', 'richiesta@compass.it', 'richiesta@compass.it');
                    nameDEM = nameDEM + ' DEMRipresaBozza_PP_MPS (2561)';
                } 
                // Abbandono forzoso PP
                when 'Q332' {
                    //mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento', 'PrestitoonlineCheBanca@compass.it', 'Compass Banca S.p.A.');
                    mailDem('2561', idCase, 'MPS prestito online: segui l\' andamento del tuo finanziamento', 'richiesta@compass.it', 'richiesta@compass.it');
                    nameDEM = nameDEM + ' DEMRipresaBozza_PP_MPS (2561)';
                } 
                // Abbandono PP Partners
                when 'Q375' {
                    mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento', 'noreplay@compass.it', 'PrestitoonlineCheBanca@compass.it');
                    nameDEM = nameDEM + ' DEMRipresaBozza_PP_CB (2553)';
                } 
                // Anomalie Pre Sic PP
                when 'Q339' {
                    if (caseObject.RO_Vecchio_Cellulare__c != null) {
                        //mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento', 'PrestitoonlineCheBanca@compass.it', 'Compass Banca S.P.A.');
                        mailDem('2561', idCase, 'MPS prestito online: segui l\' andamento del tuo finanziamento', 'richiesta@compass.it', 'richiesta@compass.it');
                        nameDEM = nameDEM + ' DEMRipresaBozza_PP_MPS (2561)';
                    } else {
                        if (state == '109') {
                            mailDem('2064', idCase, '{!first_name}, abbiamo ancora bisogno di te!', 'richiesta@compass.it', 'Compass Banca S.P.A.');
                            nameDEM = nameDEM + ' DEMNonTrovatoAnomaliePreSIC_DS (2064)';
                        } else {
                            //mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento ', 'PrestitoonlineCheBanca@compass.it', 'Compass Banca S.P.A.');
                            mailDem('2561', idCase, 'MPS prestito online: segui l\' andamento del tuo finanziamento', 'richiesta@compass.it', 'richiesta@compass.it');
                            nameDEM = nameDEM + ' DEMRipresaBozza_PP_MPS (2561)';
                        }
                    }
                }
                // Anomalie Post Sic PP
                when 'Q340' {
                    if (state == '109' || state == '119') {
                        mailDem('2065', idCase, '{!first_name}, abbiamo ancora bisogno di te!', 'richiesta@compass.it', 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMNonTrovatoAnomaliePostSIC_DS (2065)';
                    } else {
                        mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento', 'noreplay@compass.it', 'PrestitoonlineCheBanca@compass.it');
                        nameDEM = nameDEM + ' DEMRipresaBozza_PP_CB (2553)';
                    }
                }
                // Sollecito Contratto
                when 'Q377' {
                    if (state == '109') {
                        mailDem('2566', idCase, 'MPS prestito online: il tuo contratto è pronto per essere firmato!', 'richiesta@compass.it', 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMNumeroInesistenteContratto_PP_MPS (2566)';
                    } else if (state == '119') {
                        mailDem(caseObject.Product__r.DEMNonTrovatoFirmaContratto__c, idCase, 'MPS prestito online: il tuo contratto è pronto per essere firmato!', 
                            'richiesta@compass.it', 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMNonTrovatoFirmaContratto ('+ caseObject.Product__r.DEMNonTrovatoFirmaContratto__c+')';
                    }
                }
                // Anomalie PP Partners
                when 'Q376' {
                    if (state == '103') {
                        mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento ', 'noreplay@compass.it', 'PrestitoonlineCheBanca@compass.it');
                        nameDEM = nameDEM + ' DEMRipresaBozza_PP_CB (2553)';
                    } else if (state == '109' || state == '119') {
                        System.debug('#l caseObject.Product__r.DEMNonTrovatoAnomalie__c '+ caseObject.Product__r.DEMNonTrovatoAnomalie__c);
                        String dem = caseObject.Product__r.DEMNonTrovatoAnomalie__c;
                        if (dem == '2556') {
                            mailDem('2556', idCase, 'Prestito online CheBanca!:richiesta con anomalie', 'noreplay@compass.it', 'Compass Banca S.P.A.');
                            nameDEM = nameDEM + ' DEMNonTrovatoAnomalieDoc_PP_CB (2556)';
                        } else {
                            mailDem('2564', idCase, 'MPS prestito online:abbiamo bisogno ancora di te!', 'richiesta@compass.it', 'Compass Banca S.P.A.');
                            nameDEM = nameDEM + ' DEMNonTrovatoAnomalieDoc_PP_MPS (2564)';
                        }
                    }
                }
                // Sollecito Contratto PP Parteners
                when 'Q341' {
                    System.debug('#l Product__r.DEMNumeroInesistenteContratto__c '+ caseObject.Product__r.DEMNumeroInesistenteContratto__c);
                    if (state == '119') {
                        mailDem(caseObject.Product__r.DEMNonTrovatoFirmaContratto__c, idCase, 'MPS prestito online: il tuo contratto è pronto per essere firmato!', 
                            'richiesta@compass.it', 'Compass Banca S.P.A.');
                        // nameDEM = nameDEM + ' DEMNonTrovatoAnomalieDoc_PP_MPS (2564)';
                    } else if (state == '109') {
                        mailDem('2558', idCase, 'Prestito Online CheBanca!:firma il contratto', 'richiesta@compass.it', 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMNumeroInesistenteContratto_PP_CB (2558)';
                    } else if (state == '103') {
                        //noreplay@compass.it
                        mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento ', 'noreplay@compass.it', 'PrestitoonlineCheBanca@compass.it');
                        nameDEM = nameDEM + ' DEMRipresaBozza_PP_CB (2553)';
                    }
                }
                // Abbandono E-commerce
                when 'Q336' {
                    if (state == '103') {
                        mailDem('2071', idCase, 'Ripresa Bozza E-commerce', 'noreply@compass.it', 'noreply@compass.it');
                        nameDEM = nameDEM + ' DEMRipresaBozzaEcommerce (2071)';
                    } else  {
                        mailDem('2073', idCase, 'Cliente non trovato E-commerce', 'noreply@compass.it', 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMClienteNonTrovatoEcommerce (2073)';
                    }
                }
                // Anomali Documentalie E-commerce
                when 'Q338' {
                    mailDem('2072', idCase, 'Anomalie Doc. E-commerce', 'richiesta@compass.it', 'richiesta@compass.it');
                }
                // Nessuna Coda
                when 'Q525' {
                    // state 103
                    mailDem(caseObject.Product__r.DEMRipresaBozza__c, idCase, '{!first_name} segui la tua pratica di Prestito Online Compass', 'richiesta@compass.it', 'richiesta@compass.it');
                    nameDEM = nameDEM + ' DEMRipresaBozza__c ('+ caseObject.Product__r.DEMRipresaBozza__c+')';
                }
                when else {}
            }
            System.debug('#l nameDem '+ nameDEM);
            createNote(nameDEM, caseObject);
        } catch (Exception e) {
            System.debug('#l message '+ e.getCause() + ' '+ e.getMessage());
        }
    }

    /**
     * @author ADIOP
     * @date 12/10/2019
     * @description 
     * @param String Integer numeroDiOreLavoro
     **/
    public static String getCronExp(Integer numeroDiOreLavoro){        
        Datetime dateExecution = System.now().addHours(numeroDiOreLavoro);
        String cronExp =  '30 '+ dateExecution.minute()+ ' '+ dateExecution.hour() +' '+ dateExecution.day()+ ' '+ dateExecution.month()+ ' ?';
        return cronExp;
    }

    /**
     * @author ADIOP
     * @date 12/10/2019
     * @description 
     * @param Set<Id> ids
     * @param String developerName
     **/
    public static void  ricicliEsiti(Set<Id> ids, String developerName){
        try {
            //RicicliLimiteTemporel__c rlt = [SELECT Fea__c, Cartaceo__c, NumeroRicicli__c FROM RicicliLimiteTemporel__c WHERE Name =:developerName];
            XCS_CompassParameters__c rlt = [SELECT Fea__c, NumeroRicicli__c FROM XCS_CompassParameters__c WHERE Name =:developerName];
            System.debug('#l ### rlt ### '+ JSON.serialize(rlt));
            if (rlt != null) {
                Integer fea =  Integer.valueOf(rlt.Fea__c);                 
                String cronExp =  getCronExp(fea);
                RicicliPerEsitiSchedulable rPES = new RicicliPerEsitiSchedulable(ids, developerName, Integer.valueOf(rlt.NumeroRicicli__c), fea);
                String jobName = cronExp+ '-'+Math.random();
                String jobId = System.schedule(jobName , cronExp, rPES);
                System.debug('#l jobId '+ jobId);
            }
        } catch (Exception e) {
            System.debug('#l message '+ e.getCause() +' '+ e.getMessage()+ ' '+ e.getLineNumber());
        }
    }

    /**
     * @author SANA BADJI
     * @date 09/11/2019
     * @description 
     * @param String title
     * @param String body
     * @param String idcase
     **/
    public static FeedItem  createFeeditem(String title, String body, Id idCase){
        FeedItem feeditem = new FeedItem();
        feeditem.ParentId = idCase;
        feeditem.Body =body;
        feeditem.Title =title;
        try {
            insert feeditem;
            System.debug('FeedItem Created Successfully '+feeditem);
            ContentDocumentLink clnk = new ContentDocumentLink();
            clnk.ContentDocumentId = feeditem.Id;
            System.debug('ContentDocumentLink Created Successfully '+clnk);
        } catch (Exception e) {
             System.debug('error insert FeedItem '+e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber());
        }
        return feeditem;         
    }

    /***************************************************
     * @author Madicke BALDE
     * @description
     * @param  nameDEM
      *@param Case 
    ****************************************************/
    public static void createNote(String nameDEM,  Case c){
        String email = 'nessuna email';
        String anomaliesCase ;
        String linkBozza = 'nessuna email';
         Map<String, Object> caseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
         if(caseMap.keySet().contains('Account')){
             System.debug('################## accoutMap tes '+caseMap.get('Account'));
            // Account acc = (Account) caseMap.get('Account');
             Map<String, Object> accountMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseMap.get('Account')));
             if(accountMap.keySet().contains('PersonEmail')){
                email = (String) accountMap.get('PersonEmail');
             }

         }
         if(caseMap.keySet().contains('RO_Link_Bozza__c') ){
           linkBozza = (String) caseMap.get('RO_Link_Bozza__c');
         }
         if(caseMap.keySet().contains('Anomalie_Doc__r')){
           List<Anomalie_Doc__c> anomalies = (List<Anomalie_Doc__c>) caseMap.get('Anomalie_Doc__r');
           for(Anomalie_Doc__c anomalie : anomalies){
               anomaliesCase +=' '+ anomalie.descrizione_Documento__c;
           }

         }
         anomaliesCase = (String.isEmpty(anomaliesCase))?'nessuna Anomalie':anomaliesCase;
         System.debug('######## create Anomalie '+anomaliesCase);
        String body = 'a:'+email+'\n'+
                        'Link Bozza :'+linkBozza+'\n'+
                        'Anomalie DOC:'+anomaliesCase;
        createFeeditem(nameDEM,body,c.Id );
    }
}