/**
 * @File Name          : OCSRecuperaInfoSIDResponse.cls
 * @Description        :
 * @Author             : Andrea Michieli
 * @Group              :
 * @Last Modified By   : Andrea Michieli
 * @Last Modified On   : 2019-10-28 16:51:43
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-6-27 11:58:36      Andrea Michieli     Initial Version
 **/
public class OCSRecuperaInfoSIDResponse extends OCSResponse {
    @auraEnabled
	public RecuperaInfoSIDResponseDTO recuperaInfoSIDResponseResponse {get; set;}

	public OCSRecuperaInfoSIDResponse() {
		recuperaInfoSIDResponseResponse = new RecuperaInfoSIDResponseDTO();
	}

	public class RecuperaInfoSIDResponseDTO {

		public String keyN {get; set;}
        public String pind {get; set;}
        public String cellulare {get; set;}
        public String email {get; set;}
        public String modalitaInoltro {get; set;}
        public String operTelef {get; set;}
        public String attesaAttivazione {get; set;}
        public String servizioSoglia {get; set;}
    	public String dataAttSoglia {get {
									  String res = '';
									  if(!String.isBlank(dataAttSoglia) && !'0'.equalsIgnoreCase(dataAttSoglia)) {

										  res += dataAttSoglia.subString(0, 4);
										  res += dataAttSoglia.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataVarSoglia {get {
									  String res = '';
									  if(!String.isBlank(dataVarSoglia) && !'0'.equalsIgnoreCase(dataVarSoglia)) {

										  res += dataVarSoglia.subString(0, 4);
										  res += dataVarSoglia.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataDisSoglia {get {
									  String res = '';
									  if(!String.isBlank(dataDisSoglia) && !'0'.equalsIgnoreCase(dataDisSoglia)) {

										  res += dataDisSoglia.subString(0, 4);
										  res += dataDisSoglia.subString(4, 6);
									  }
									  return res;
								  } set;}
    	public String importoSoglia {get; set;}
        public String servizioAggEc {get; set;}
        public String dataAttAggEc {get {
									  String res = '';
									  if(!String.isBlank(dataAttAggEc) && !'0'.equalsIgnoreCase(dataAttAggEc)) {

										  res += dataAttAggEc.subString(0, 4);
										  res += dataAttAggEc.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataVarAggEc {get {
									  String res = '';
									  if(!String.isBlank(dataVarAggEc) && !'0'.equalsIgnoreCase(dataVarAggEc)) {

										  res += dataVarAggEc.subString(0, 4);
										  res += dataVarAggEc.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataDisAggEc {get {
									  String res = '';
									  if(!String.isBlank(dataDisAggEc) && !'0'.equalsIgnoreCase(dataDisAggEc)) {

										  res += dataDisAggEc.subString(0, 4);
										  res += dataDisAggEc.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String servizioSaldo {get; set;}
        public String dataAttSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataAttSaldo) && !'0'.equalsIgnoreCase(dataAttSaldo)) {

										  res += dataAttSaldo.subString(0, 4);
										  res += dataAttSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataVarSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataVarSaldo) && !'0'.equalsIgnoreCase(dataVarSaldo)) {

										  res += dataVarSaldo.subString(0, 4);
										  res += dataVarSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataDisSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataDisSaldo) && !'0'.equalsIgnoreCase(dataDisSaldo)) {

										  res += dataDisSaldo.subString(0, 4);
										  res += dataDisSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String frequenzaSaldo {get; set;}
        public String costoSaldo {get; set;}
        public String servAcqSaldoCm {get; set;}
        public String dataAttAcqSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataAttAcqSaldo) && !'0'.equalsIgnoreCase(dataAttAcqSaldo)) {

										  res += dataAttAcqSaldo.subString(0, 4);
										  res += dataAttAcqSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataVarAcqSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataVarAcqSaldo) && !'0'.equalsIgnoreCase(dataVarAcqSaldo)) {

										  res += dataVarAcqSaldo.subString(0, 4);
										  res += dataVarAcqSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataDisAcqSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataDisAcqSaldo) && !'0'.equalsIgnoreCase(dataDisAcqSaldo)) {

										  res += dataDisAcqSaldo.subString(0, 4);
										  res += dataDisAcqSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String servizioDisp {get; set;}
        public String dataAttDisp {get {
									  String res = '';
									  if(!String.isBlank(dataAttDisp) && !'0'.equalsIgnoreCase(dataAttDisp)) {

										  res += dataAttDisp.subString(0, 4);
										  res += dataAttDisp.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataVarDisp {get {
									  String res = '';
									  if(!String.isBlank(dataVarDisp) && !'0'.equalsIgnoreCase(dataVarDisp)) {

										  res += dataVarDisp.subString(0, 4);
										  res += dataVarDisp.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataDisDisp {get {
									  String res = '';
									  if(!String.isBlank(dataDisDisp) && !'0'.equalsIgnoreCase(dataDisDisp)) {

										  res += dataDisDisp.subString(0, 4);
										  res += dataDisDisp.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataTrasmServDisp {get {
									  String res = '';
									  if(!String.isBlank(dataTrasmServDisp) && !'0'.equalsIgnoreCase(dataTrasmServDisp)) {

										  res += dataTrasmServDisp.subString(0, 4);
										  res += dataTrasmServDisp.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String avvisoAut {get; set;}
        public String dataAttAut {get {
									  String res = '';
									  if(!String.isBlank(dataAttAut) && !'0'.equalsIgnoreCase(dataAttAut)) {

										  res += dataAttAut.subString(0, 4);
										  res += dataAttAut.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataVarAut {get {
									  String res = '';
									  if(!String.isBlank(dataVarAut) && !'0'.equalsIgnoreCase(dataVarAut)) {

										  res += dataVarAut.subString(0, 4);
										  res += dataVarAut.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataDisAut {get {
									  String res = '';
									  if(!String.isBlank(dataDisAut) && !'0'.equalsIgnoreCase(dataDisAut)) {

										  res += dataDisAut.subString(0, 4);
										  res += dataDisAut.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String impSogliaAut {get; set;}
        public String presSogliaAut {get; set;}
        public String avvisoAutTot {get; set;}
        public String dataAttAutTot {get {
									  String res = '';
									  if(!String.isBlank(dataAttAutTot) && !'0'.equalsIgnoreCase(dataAttAutTot)) {

										  res += dataAttAutTot.subString(0, 4);
										  res += dataAttAutTot.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataVarAutTot {get {
									  String res = '';
									  if(!String.isBlank(dataVarAutTot) && !'0'.equalsIgnoreCase(dataVarAutTot)) {

										  res += dataVarAutTot.subString(0, 4);
										  res += dataVarAutTot.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataDisAutTot {get {
									  String res = '';
									  if(!String.isBlank(dataDisAutTot) && !'0'.equalsIgnoreCase(dataDisAutTot)) {

										  res += dataDisAutTot.subString(0, 4);
										  res += dataDisAutTot.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String impSogliaAutTot {get; set;}
        public String vprVariazProxRata {get; set;}
        public String dataAttVpr {get {
									  String res = '';
									  if(!String.isBlank(dataAttVpr) && !'0'.equalsIgnoreCase(dataAttVpr)) {

										  res += dataAttVpr.subString(0, 4);
										  res += dataAttVpr.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataVarVpr {get {
									  String res = '';
									  if(!String.isBlank(dataVarVpr) && !'0'.equalsIgnoreCase(dataVarVpr)) {

										  res += dataVarVpr.subString(0, 4);
										  res += dataVarVpr.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String dataDisVpr {get {
									  String res = '';
									  if(!String.isBlank(dataDisVpr) && !'0'.equalsIgnoreCase(dataDisVpr)) {

										  res += dataDisVpr.subString(0, 4);
										  res += dataDisVpr.subString(4, 6);
									  }
									  return res;
								  } set;}
        public String protCampServizio {get; set;}
        public String protCampDataAtt {get; set;}
        public String protCampDataVar {get; set;}
        public String protCampDataDis {get; set;}
        public String risPrincServizio {get; set;}
        public String risPrincDataAtt {get; set;}
        public String risPrincDataVar {get; set;}
        public String risPrincDataDis {get; set;}
        public String bloccoServizio {get; set;}
        public String bloccoDataAtt {get; set;}
        public String bloccoDataVar {get; set;}
        public String bloccoDataDis {get; set;}
        public String catbopteDescrizione {get; set;}

	}
		
}