public class SchedaVerificaFilialeVisualizzatoCtrl {

    @AuraEnabled
    public static string updateLetta(String schedaFilialeId, String campo){
        Scheda_Verifica_Filiale__c scheda = new Scheda_Verifica_Filiale__c (id=schedaFilialeId);
        try{
            scheda.put(campo,true);
            update scheda;
        } catch(Exception e){
            return e.getMessage();
        }
        return null;
    }
}