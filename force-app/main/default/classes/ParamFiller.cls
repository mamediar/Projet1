public abstract class ParamFiller {
    
	public abstract List<Parametro> getParams();  

    public class Parametro {
        public String valore {get; set;}   
        public String variabile {get ; set;}  
    }
}