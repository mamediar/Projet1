@isTest
public class SFAPratIrregFlagsForFILIALECntrollerTest {
    @isTest
    public static void checkUncheckFlagTest(){
        
        Case cPadre = New Case();
        cPadre.ActivityType__c = 'SFA_PRAIRRPARENT';
        cPadre.Status='Closed';
        insert cPadre; 
        
        Case cFiglio = New Case();
        cFiglio.ActivityType__c = 'SFA_PRAIRR';
        cFiglio.Status='Closed';
        cFiglio.ParentId=cPadre.Id;
        insert cFiglio;        
        
        SFA_PraticaIrregolare__c P = new SFA_PraticaIrregolare__c();
        P.EsitoCaricamento__c = 'Pratica caricata';
        P.ActivityId__c=cFiglio.Id;
        //p.IdElaborazione__c = c.id;
        P.Name = 'pratica_uno';
        P.CodiceDealer__c = 'd';
        P.CodicePv__c = 's';
        P.CodiceStatoDealer__c = 's';
        P.RagioneSociale__c = 'rag';
        P.NumeroPratica__c = '123';
        P.CodiceStatoPratica__c = '50';
        P.Dipendenza__c = 'm';
        P.Status__c = 'Pratica - da Gestire';        
        insert P;
        
        SFAPraticheIrregFlagsForFILIALECntroller.checkFlagTargaTelaio((String)P.id);
        SFAPraticheIrregFlagsForFILIALECntroller.uncheckFlagTargaTelaio((String)P.id);
        SFAPraticheIrregFlagsForFILIALECntroller.checkFlagModuloInterazione((String)P.id);
        SFAPraticheIrregFlagsForFILIALECntroller.uncheckFlagModuloInterazione((String)P.id);
        SFAPraticheIrregFlagsForFILIALECntroller.getFlags((String)P.id);

    }

}