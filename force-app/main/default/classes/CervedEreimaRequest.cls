public class CervedEreimaRequest extends OCSRequest {

	public String parameterValue;

	public CervedEreimaRequest(String valore) {
		parameterValue = valore;
	}

	public override Map<String, String> getParametri() {
		Map<String, String> parametri = new Map<String, String>();
		parametri.put('Parameter', parameterValue);
		return parametri;
    }
}