@isTest
public class SFACaseListControllerTest {  
    @isTest
    public static void getCasesTest(){
        //Creo il case per il test
        Case c = new Case();
        c.Status = 'New';
        insert c;
        
        //Creo le liste per il test
        List<String> lista = new List<String>();
        lista.add('New');
        lista.add('Closed');
        List<String> listaNull = null;
        
        //Testo la prima condizione
        SFACaseListController.getCases('Status',lista,c.id);        
        //Testo la seconda condizione  
        SFACaseListController.getCases('Status',lista,null);
        //Testo la terza condizione
        SFACaseListController.getCases('Status',listaNull,c.id);    
        
    }
    
}