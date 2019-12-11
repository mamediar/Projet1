public  class AppuntamentoListaFilialiRequest extends OCSAPIRequest {
   
    public String q {get;set;}
    public String prodotto {get;set;}
    public AppuntamentoListaFilialiRequest (){
        super();
    }
  
public AppuntamentoListaFilialiRequest(String q, String prodotto){
    super();
    this.q= q;
    this.prodotto = prodotto;
}
public override   Map<String, String> getParametri(){
      Map<String, String> parametri = new Map<String, String>();
      parametri.put('prodotto', this.prodotto);
      parametri.put('q',  this.q);
      
      return parametri;
}
}