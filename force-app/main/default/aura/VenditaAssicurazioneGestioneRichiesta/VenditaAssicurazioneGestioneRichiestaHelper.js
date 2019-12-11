({
    setOptions : function(cmp) {  
        var today = new Date(); 
        
        cmp.set('v.assicurazioniPosseduteColumns', [
            {label: 'Numero Pratica OCS', fieldName: 'numPratica', type: 'Text'},
            {label: 'stato', fieldName: 'statoPratica', type: 'Text'},
            {label: 'Data caricamento', fieldName: 'dataCaricamento', type: 'Text'},
            {label: 'prodotto', fieldName: 'prodotto', type: 'Text'}                               
        ]);
        
        cmp.set('v.cartePerPagamentoColumns', [
            //{label: 'Numero Pratica', fieldName: 'numPratica', type: 'Text'},
            {label: 'Tipologia', fieldName: 'tipoPratica', type: 'Text'},
            {label: 'Stato', fieldName: 'statoPratica', type: 'Text'},
            {label: 'Prodotto', fieldName: 'prodotto', type: 'Text'},          
            {label: 'Modalità pagamento', fieldName: 'tipoPagamento', type: 'Text'},
            {label: 'Dealer', fieldName: 'venditore', type: 'Text'},
            {label: 'Canale', fieldName: 'canale', type: 'Text'}                      
        ]);
        
        cmp.set('v.cartaDatiFinanziariColumns', [
            {label: 'Numero Carta', fieldName: 'numeroPratica', type: 'Text'},
            {label: 'PAN', fieldName: 'pan', type: 'Text'},
            {label: 'Data validità', fieldName: 'dataValidita', type: 'Text'},
            {label: 'Data scadenza', fieldName: 'dataScadenza', type: 'Text'},                      
            {label: 'Stato carta', fieldName: 'statoCustom', type: 'Text'},
            {label: 'Stato rinnovo', fieldName: 'statoRinnovoCustom', type: 'Text'},          
            {label: 'Fido', fieldName: 'fidoCustom', type: 'Text'},
            {label: 'Disponibilità', fieldName: 'disponibilitaCustom', type: 'Text'},          
            {label: 'Modalità calcolo rata', fieldName: 'modCalcoloRataCustom', type: 'Text'},          
            {label: 'Percentuale', fieldName: 'pagamentoMinimoPerc', type: 'Text'},
            {label: 'Rata minima', fieldName: 'pagamentoMinimo', type: 'Text'},          
            {label: 'Prodotto', fieldName: 'desProdotto', type: 'Text'}  
        ]);
        
        cmp.set('v.movimentiViaggiantiColumns', [
            {label: 'Tipo movimento', fieldName: 'tipoMov', type: 'Text'},
            {label: 'causale', fieldName: 'causale', type: 'Text'},
            {label: 'Dare Avere', fieldName: 'dareAvere', type: 'Text'},
            {label: 'Segno Importo', fieldName: 'segnoImporto', type: 'Text'},          
            {label: 'Importo', fieldName: 'importo', type: 'Text'},
            {label: 'Categoria Merce', fieldName: 'categoriaMerc', type: 'Text'},
            {label: 'Data operazione', fieldName: 'dataOp', type: 'Text'},          
            {label: 'Data valuta', fieldName: 'dataVal', type: 'Text'},          
            {label: 'esercente', fieldName: 'esercente', type: 'Text'}   
        ]);   
        
        cmp.set('v.autorizzazioniColumns', [
            {label: 'Codazione', fieldName: 'codAzione', type: 'Text'},
            {label: 'Desazione', fieldName: 'desAzione', type: 'Text'},
            {label: 'cod esercente', fieldName: 'codEsercente', type: 'Text'},
            {label: 'des esercente', fieldName: 'desEsercente', type: 'Text'},          
            {label: 'esito', fieldName: 'esito', type: 'Text'},
            {label: 'importo', fieldName: 'importo', type: 'Text'},
            {label: 'importo segno', fieldName: 'importoSegno', type: 'Text'},
            {label: 'divisa', fieldName: 'divisa', type: 'Text'},          
            {label: 'importo divisa estera', fieldName: 'importoDivisaEstera', type: 'Text'},          
            {label: 'intermediario', fieldName: 'intermediario', type: 'Text'},
            {label: 'data', fieldName: 'data', type: 'Text'},          
            {label: 'ora', fieldName: 'ora', type: 'Text'} 
        ]);
        
        cmp.set('v.ibanPerPagamentoColumns', [
            {label: 'Numero Pratica', fieldName: 'numPratica', type: 'Text'},
            {label: 'Tipologia', fieldName: 'tipoPratica', type: 'Text'},
            {label: 'Stato', fieldName: 'statoPratica', type: 'Text'},
            {label: 'Prodotto', fieldName: 'prodotto', type: 'Text'},          
            {label: 'Modalità pagamento', fieldName: 'tipoPagamento', type: 'Text'},
            {label: 'IBAN', fieldName: 'iban', type: 'Text'}  
        ]);        
        
        cmp.set('v.assicurazioniPosseduteTodayColumns', [
            {label: 'Numero Pratica OCS', fieldName: 'numPratica', type: 'Text'},
            {label: 'Data caricamento', fieldName: 'dataCaricamento', type: 'Text'}
        ]);
        
        cmp.set('v.interestOptions', [
            {label:'Interessato', value:'interessato'},
            {label:'Non Interessato', value:'non_interessato'},
            {label:'Irreperibile', value:'irreperibile'}
        ]);
        
        cmp.set('v.optionsButtonInvio', [
            {label: 'Invio eseguito tramite Email da RGI', value: 'inviato'},
            {label: 'Invio tramite email da CRM', value: 'email'},
            {label: 'Invio tramite posta', value: 'posta'}
        ]);
        
        cmp.set('v.optionsButtonPostaEmail', [
            {label: 'Invio tramite Email', value: 'email'},
            {label: 'Invio tramite posta', value: 'posta'}
        ]);
        
        cmp.set('v.noInterestOptions', [
            {label:'Ho già assicurazione casa', value:'Ho già assicurazione casa'},
            {label:'Non risponde alle mie esigenze', value:'Non risponde alle mie esigenze'},
            {label:'Non sono interessato', value:'Non sono interessato'},
            {label:'Costo eccessivo', value:'Costo eccessivo'},
            {label:'Altro', value:'Altro'},
            {label:'Già contattato', value:'Già contattato'}
        ]);
        
        cmp.set('v.siInterest', [
            {label:'Pratica caricata', value:'Pratica caricata'},
            {label:'Inviata doc precontrattuale', value:'Inviata doc precontrattuale'} 
        ]);
        
        cmp.set('v.mezzoPagam', [
            {label:'Carta Compass', value:'cartaCompass'},
            {label:'Altra carta', value:'altraCart'},
            {label:'Addebito in conto', value:'addConto'}
        ]);
        
        cmp.set('v.freqPagam', [
            {label:'Frequenza di pagamento annuale', value:'frequenzaAnno'},
            {label:'Frequenza di pagamento mensile', value:'frequenzaMese'}
        ]);
        
        cmp.set('v.today', today.toISOString());
        cmp.set('v.scriptTelefonataStretch', 'Altri');                        
        cmp.set('v.productValue', []);
    },
    
    handleErrors : function(cmp, errorList){
        if(errorList.length > 0){
            errorList.forEach(function(elem){                                
                cmp.set(('v.' + elem.serviceName + 'Error'), elem.message);
                cmp.set(('v.' + elem.attributeName), true);
            });
            
            
            /*cmp.set('v.flagCartaDatiFinanziariError', errorList.forEach(function(elem){
                if(elem.serviceName = 'cartaDatiFinanziari'){
                    console.log('LO E');
                    cmp.set('v.cartaDatiFinanziariError', elem.message);
                    return true;
                }
                return false;
            }));*/
        }
    }
})