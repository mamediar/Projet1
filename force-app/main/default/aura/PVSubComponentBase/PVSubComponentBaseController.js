/**
 * @File Name          : PVSubComponentBaseController.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-10-10 12:05:13
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    15/8/2019, 19:38:08   Andrea Vanelli     Initial Version
**/
({

    //metodo richiamato dal parent quando cambia qualcosa
    onParentChange: function (cmp, event, helper) {
        
        var params = event.getParam('arguments');
      
        if (params.whatIsChanged == 'psvSubtype') {
            helper.onSubtypeSelected(cmp, event, helper);
        } else if (params.whatIsChanged == 'psvReason') {
            helper.onReasonSelected(cmp, event, helper);
        } else if (params.whatIsChanged == 'ocsCliente') {
            helper.onClienteSelected(cmp, event, helper);
        } else if (params.whatIsChanged == 'ocsPratica') {
            helper.onPraticaSelected(cmp, event, helper);
        }
    },

    inserisciCase: function (cmp, event, helper) {
        helper.inserisciCase(cmp, event, helper);
    }
})