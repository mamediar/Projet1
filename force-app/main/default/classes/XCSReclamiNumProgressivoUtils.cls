public class XCSReclamiNumProgressivoUtils {
    public static String getProgAnnAss(){
        String res='';
        XCS_Sequence_Numero_Assicurativo__c obj=new XCS_Sequence_Numero_Assicurativo__c();
        insert obj;
        res=[select Numero_Progressivo_Annuale__c from XCS_Sequence_Numero_Assicurativo__c].Numero_Progressivo_Annuale__c;
        delete obj;
        System.debug('XCSReclamiNumProgressivoUtils getProgAnnAss remainig records: '+[select Id from XCS_Sequence_Numero_Assicurativo__c]);
        System.debug('XCSReclamiNumProgressivoUtils getProgAnnAss res: '+res);
        return res;
    }
    
    public static String getNumProgRec(){
        String res='';
        XCS_Sequence_Numero_Reclamo__c obj=new XCS_Sequence_Numero_Reclamo__c();
        insert obj;
        res=[select Numero_Progressivo__c from XCS_Sequence_Numero_Reclamo__c].Numero_Progressivo__c;
        delete obj;
        System.debug('XCSReclamiNumProgressivoUtils getNumProgRec remainig records: '+[select Id from XCS_Sequence_Numero_Reclamo__c]);
        System.debug('XCSReclamiNumProgressivoUtils getNumProgRec res: '+res);
        return res;
    }
}