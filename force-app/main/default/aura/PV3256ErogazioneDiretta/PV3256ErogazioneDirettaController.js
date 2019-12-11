/**
 * @File Name          : PV3256ErogazioneDirettaController.js
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-8-19 11:57:40
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-8-19 11:57:40   Lorenzo Marzocchi     Initial Version
**/
({


    //se flaggato deve mostrare la matrice dei conti CPAY
    mostraMatrixCPAY: function (cmp, event, helper) {
       helper.mostraMatrixCPAY(cmp);
    },

    selectConto: function (cmp,event,helper){
        helper.selectConto(cmp, event, helper);
    },


    calcolaCommissione: function(cmp,event,helper){
        helper.calcolaCommissione(cmp);
    },

  

})