/**
 * @File Name          : OCSResponse.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 26/9/2019, 15:26:16
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    9/8/2019, 12:28:38   Andrea Vanelli     Initial Version
 **/
public virtual class OCSResponse extends APIResponse
{
	@AuraEnabled
	public Integer resultCode {get; set;}
	@AuraEnabled
	public String resultMessage {get; set;}

	public virtual override boolean isOK()
	{
		return this.checkIsOK();
	}

	public virtual String getMessage(){
		String res='Success';
		if(!this.checkIsOK()) {
			if(super.statusCode!=200) {
				res='Errore nella chiamata: '+super.status;
			}
			else{
				res='Errore esecuzione del servizio.'+'\n- - Codice: '+this.resultCode+'\n- - Messaggio: '+this.resultMessage;
			}
		}
		return res;
	}

	private boolean checkIsOK(){
		return super.isOK() && this.resultCode==0;
	}

	// **********************************************
	// metodi statici per convertire i dati da OCS
	// **********************************************
	public static Double setNumber(Double val) {
		try {
			return val / 100;
		} catch (Exception e) {
			return 0;
		}
	}
	public static Double getNumber(Double val, String segno) {
		try {
			if (segno.equals('-')) {
				return (val * -1);
			} else {
				return val;
			}
		} catch (Exception e) {
			return val;
		}
	}

	public static String getDate(String val) {
		try {
			String res = '';
			if(!String.isBlank(val) && !'0'.equalsIgnoreCase(val)) {
				res =  val.subString(0, 4) + '-' +  val.subString(4, 6) + '-' + val.subString(6);
			}
			return res;
		} catch (Exception e) {
			return val;
		}
	}


	// getDealerCode
	public static String getDealerCode(String puntoVendita, String convenzionato, String subAgente, String agente) {

		String sDealer = '';
		if(puntoVendita != null && !puntoVendita.equals('0'))
		{
			sDealer = puntoVendita;
		}
		else if(convenzionato != null && !convenzionato.equals('0'))
		{
			sDealer = convenzionato;
		}
		else if(subAgente != null && !subAgente.equals('0'))
		{
			sDealer = subAgente;
		}
		else if(agente != null && !agente.equals('0'))
		{
			sDealer = agente;
		}
		return sDealer;

	}





	// obsoleta
	public static String normalizeNumber(String val) {
		Decimal d;
		try {
//            d = Decimal.valueOf(String.valueOf(o));
			return String.valueOf(Double.valueOf(val)/100);
		} catch (TypeException e) {
			return '0';
			// In a controller you might add the exception message e.g. "Invalid decimal: abc"
		}
	}




}