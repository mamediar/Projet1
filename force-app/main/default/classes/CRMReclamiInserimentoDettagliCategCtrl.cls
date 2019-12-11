public without sharing class CRMReclamiInserimentoDettagliCategCtrl {
    @AuraEnabled
    public static Map<String,List<XCS_Categoria__c>> getCategorie(String azienda){
        String name=(azienda.equals('Compass')?'Reclami':
                    azienda.equals('Futuro')?'Reclami Futuro':
                    'Reclami Creditech');
        List<XCS_Categoria__c> lv0=[select Id,External_Id__c,Livello__c,Parent__c,Name
                                    from XCS_Categoria__c
                                    where Livello__c=0 and Name=:name];
        List<XCS_Categoria__c> lv1=[select Id,External_Id__c,Livello__c,Parent__c,Name
                                    from XCS_Categoria__c
                                    where Livello__c=1 and Parent__c in :getIdList(lv0)];
        List<XCS_Categoria__c> lv2=[select Id,External_Id__c,Livello__c,Parent__c,Name
                                    from XCS_Categoria__c
                                    where Livello__c=2 and Parent__c in :getIdList(lv1)];
        List<XCS_Categoria__c> lv3=[select Id,External_Id__c,Livello__c,Parent__c,Name
                                    from XCS_Categoria__c
                                    where Livello__c=3 and Parent__c in :getIdList(lv2)];
        List<XCS_Categoria__c> lv4=[select Id,External_Id__c,Livello__c,Parent__c,Name
                                    from XCS_Categoria__c
                                    where Livello__c=4 and Parent__c in :getIdList(lv3)];
        
        List<XCS_Categoria__c> lv5=[select Id,External_Id__c,Livello__c,Parent__c,Name
                                    from XCS_Categoria__c
                                    where Livello__c=5 and Parent__c in :getIdList(lv4)];
          List<XCS_Categoria__c> lv6=[select Id,External_Id__c,Livello__c,Parent__c,Name
                                    from XCS_Categoria__c
                                    where Livello__c=6 and Parent__c in :getIdList(lv5)];
        
        Map<String,List<XCS_Categoria__c>> res=new Map<String,List<XCS_Categoria__c>>();
        res.put('lv0',lv0);
        res.put('lv1',lv1);
        res.put('lv2',lv2);
        res.put('lv3',lv3);
        res.put('lv4',lv4);
        res.put('lv5',lv5);
         res.put('lv6',lv6);
        return res;
    }
    
    private static List<String> getIdList(List<XCS_Categoria__C> data){
        List<String> res=new List<String>();
        for(XCS_Categoria__c c:data){
            res.add(c.Id);
        }
        System.debug('CRMReclamiInserimentoDettagliCategCtrl getIdList res: '+res);
        return res;
    }
    
    @AuraEnabled
    public static Boolean getGrave(XCS_Categoria__c categ,String societa){ 
        system.debug('@@@ getGrave categ: '+categ);
        system.debug('@@@ getGrave societa: '+societa);
        return XCSReclamiUtils.getGrave(categ,societa);
    }

    @AuraEnabled
    public static List<CodaXSocieta__mdt> getValoriCoda(String societa, String tipo, XCS_Categoria__c categoria, Boolean delega_presente, String stageInadempimento, Boolean reclamo_completo){

        List<CodaXSocieta__mdt> queueToreturn = CRMReclamiInserimentoDettagliSelCodaCtrl.getQueues(societa, tipo,  categoria, delega_presente, stageInadempimento, reclamo_completo); 
        return queueToreturn; 
    }
    
    
    
    @AuraEnabled
    public static Object treeCategories(String azienda){
        Map<String, List<XCS_Categoria__c>> mappa =  getCategorie(azienda);
        Tree t = new Tree();
       
        //Aggiunta Liv0
        t.root.items = new List<Node>();
        
        t.root = new Node(mappa.get('lv0').get(0));
        
            
         //Aggiunta Liv1
       List<Node>l1 =  t.insertNodeInternal(t.root, mappa.get('lv1'));
        
        //Aggiunta Liv2
        List<Node>l2 =  t.insertListNodeInternal(l1, mappa.get('lv2'));
         //Aggiunta Liv3
        List<Node>l3 =  t.insertListNodeInternal(l2, mappa.get('lv3'));
         //Aggiunta Liv4
        List<Node>l4 =  t.insertListNodeInternal(l3, mappa.get('lv4'));
         //Aggiunta Liv5
        List<Node>l5 =  t.insertListNodeInternal(l4, mappa.get('lv5'));
        //Aggiunta Liv6 PLUS
        List<Node>l6 =  t.insertListNodeInternal(l5, mappa.get('lv6'));
        
        //Costruisco il dato
        t.root.createDato();
        for(Node n : l1) n.createDato();
        for(Node n : l2) n.createDato();
        for(Node n : l3) n.createDato();
        for(Node n : l4) n.createDato();
        for(Node n : l5) n.createDato();
        for(Node n : l6) n.createDato();
        return t.root;
        
    }
     
    @AuraEnabled
    public static XCS_Categoria__c setCategoriaCtrl(String idCateg){
        System.debug(idCateg);
        return [Select id, Name, External_id__c from XCS_Categoria__c where id=:idCateg];
        
    }
    
    public class Tree{
        @AuraEnabled
        public Node root; //Empty
        
        public Tree(String label, String value){
            root = new Node(label,  value);
        }
        
        public Tree(){
             root = new Node('- Seleziona Una Categoria -', '');
        }
        
        
        private List<Node> insertNodeInternal(Node parent, List<XCS_Categoria__c> catList){
            if(parent == null || catList == null) return null;
            List<Node> listNode = new List<Node>();
            for(XCS_Categoria__c cat: catList){
                if(parent.cat.Id == cat.Parent__c){
                    Node temp = new Node(cat);
                    parent.items.add(temp);
                    listNode.add(temp);
                }
                
            }
            return listNode;
        }
        
        private List<Node> insertListNodeInternal(List<Node> parent, List<XCS_Categoria__c> catList){
            
            List<Node> listNode = new List<Node>();
            for(Node t : parent){
                for(XCS_Categoria__c cat: catList){
                    if(t.cat.Id == cat.Parent__c){
                        Node temp = new Node(cat);
                        t.items.add(temp);
                        listNode.add(temp);
                    }
                    
                }
            }
            return listNode;
        }
    }
    
    public class Node{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Boolean expanded;
        @AuraEnabled
        public List<Node> items;
        @AuraEnabled
        public XCS_Categoria__c cat;
        
        public Node(String label, String name){
            this.label = label;
            expanded = false;
            items = new List<Node>();
        }
        
        public Node(XCS_Categoria__c cat){
            this(cat.Name, cat.External_Id__c);
            this.cat = cat;
        }
		
        public void createDato(){
            Dato d = new Dato(cat, items);
            name = JSON.serialize(d);
        }
        
    }
    
    public class Dato{
        @AuraEnabled
        public XCS_Categoria__c cat;
        @AuraEnabled
        public List<Node> nodo;
        
        public Dato(XCS_Categoria__c cat, List<Node> nodo){
            this.cat = cat;
            this.nodo = nodo;
        }
    }
    
}