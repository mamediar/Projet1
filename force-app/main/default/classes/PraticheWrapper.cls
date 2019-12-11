/**
 * @File name  :PraticheWrapper
 * @Author Madicke BALDE
 * @description Class to sort pratiche by dataCaricamento
 * @date 
 **/
global  class PraticheWrapper implements Comparable {
        public RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche;
        public PraticheWrapper(RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO prat ) {
             this.pratiche = prat;
        }

        global Integer compareTo(Object compareTo) { 
             PraticheWrapper compareToPratiche = (PraticheWrapper)compareTo;
            Integer returnValue = 0;
            if(pratiche.dataCaricamento  < compareToPratiche.pratiche.dataCaricamento){
                returnValue = 1;
            }
            else if(pratiche.dataCaricamento > compareToPratiche.pratiche.dataCaricamento){
                returnValue = -1;
            }
            return returnValue;
        }
}