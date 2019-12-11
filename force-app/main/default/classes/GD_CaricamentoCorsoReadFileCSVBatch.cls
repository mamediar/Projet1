public class GD_CaricamentoCorsoReadFileCSVBatch implements Queueable{
    
    public List<IVASS_Dealer_courses_Iscritti__c> listaDealer;
    public static List<IVASS_Dealer_courses_Iscritti__c> listInOut;
    public static List<IVASS_Dealer_courses_Iscritti__c> listInError = new List<IVASS_Dealer_courses_Iscritti__c>();
    public String [] file;
    public List<String> fields;
    public IVASS_Dealer_Courses__c dealerCorso;
    
    public GD_CaricamentoCorsoReadFileCSVBatch(String fileData,List<String> fields,  IVASS_Dealer_Courses__c dealerCorso) {
        this.file = new String[]{};
        this.file = fileData.split('\n');          
        this.fields=fields;       
        this.dealerCorso = dealerCorso;
        System.debug(' constructor of GD_CaricamentoCorsoReadFileCSVBatch');     
    }
    
    public void execute(QueueableContext  context) {
        System.debug(' function execute');
        List<IVASS_Dealer_courses_Iscritti__c> myList = new List<IVASS_Dealer_courses_Iscritti__c>();
        IVASS_Dealer_courses_Iscritti__c obj;
        for (Integer i=1;i<this.file.size();i++){
           try{
                String[] inputvalues = new String[]{};
                    System.debug('Lettura line: '+i +' : '+this.file[i]);
                inputvalues = this.file[i].split(';');
                System.debug('size inputvalues : '+inputvalues.size());
                System.debug('inputvalues : '+inputvalues);
                obj = new IVASS_Dealer_courses_Iscritti__c();
                //obj.Area__c = inputvalues[1];
                obj.Codice_Fiscale__c = inputvalues[9] ;
                obj.Codice_Intermediario__c = inputvalues[2];
                obj.Cognome__c = inputvalues[7];
                System.debug('dealerCorso : '+dealerCorso);
                obj.Corso__c = dealerCorso.Id;
                System.debug('Data_Iscrizione__c before convert : '+inputvalues[11]);
                String[] dateValues = inputvalues[11].split('/');
                System.debug('date '+dateValues);
                obj.Data_Iscrizione__c = date.newinstance(Integer.valueof(dateValues[2]),Integer.valueof(dateValues[1]),Integer.valueof(dateValues[0])) ;
                  System.debug('Data_Iscrizione__c after convert : '+ obj.Data_Iscrizione__c);
                // find Dealer for the object
                System.debug('inputvalues[3] : '+inputvalues[3]);
                Account dealer=null;
                dealer=  [SELECT Id , Name FROM Account WHERE RecordType.Name = 'Dealer' AND  OCS_External_Id__c =: inputvalues[3] Limit 1];
                System.debug('Dealer__c : '+ dealer);
                if(dealer!= NULL)
                obj.Dealer__c = dealer.Id;
                
                //find Referente__c for the object
                System.debug('inputvalues[6] : '+inputvalues[6]);
                Account referente=new Account();
                
                referente=   [SELECT Id , Name , Branch__c , OCS_External_Id__c FROM Account  WHERE RecordType.Name = 'Person Account' AND OCS_External_Id__c =: inputvalues[6]  Limit 1];
                obj.Referente__c = referente.Id;
                System.debug('referente : '+ referente);
                
                obj.Nome__c = inputvalues[8];
                obj.Note__c = inputvalues[18];
                obj.Note_x_Outsourcer__c = inputvalues[0];
                //find Filiale__c for the object
                Account filiale = new Account();
                
                filiale=   [SELECT Id , Name , Branch__c FROM Account  WHERE RecordType.Name = 'Dealer' AND OCS_External_Id__c =: inputvalues[2] Limit 1 ];
                
                //obj.Filiale__c = filiale.Id;
                System.debug('filiale : '+ filiale);
                
                obj.Ragione_Sociale__c = inputvalues[4];
                obj.Regione__c = inputvalues[0];
                myList.add(obj);
            }catch(Exception e){
                System.debug('Message exception :'+e.getMessage());   
                System.debug('Cause exception : '+e.getCause());   
                System.debug('Line Number exception : '+e.getLineNumber());   
                System.debug('Trace exception : '+e.getStackTraceString());  
                listInError.add(obj);
            }  
        }
        System.debug('la liste : '+myList);
        listaDealer = myList;
        //insertList();
    }

  public void finish(QueueableContext  context) {
      System.debug('start to method finish');
  }
     public void insertList() {
         System.debug('Start insertList');
         try{
            if(this.listaDealer.size()<=200)
                insert listaDealer;
            else {
                List<IVASS_Dealer_courses_Iscritti__c> t = new List<IVASS_Dealer_courses_Iscritti__c>();
                for(Integer i=0; i<listaDealer.size();i++) {
                    if(i>0 && math.mod(i,200)==0) {
                        insert t;
                        t = new List<IVASS_Dealer_courses_Iscritti__c>();
                    }
                    else {
                        t.add(listaDealer.get(i));
                    }
                }
                if(t.size()>0) 
                    insert t;
            }
         }catch(Exception e){
                System.debug('Message exception :'+e.getMessage());   
                System.debug('Cause exception : '+e.getCause());   
                System.debug('Line Number exception : '+e.getLineNumber());   
                System.debug('Trace exception : '+e.getStackTraceString());   
            } 
          System.debug('End insertList');   
        }
}