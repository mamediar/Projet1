@isTest
public class OCSRecuperaDatiPVFiltroPratInterfaceTest {
    public class OCSRecuperaDatiPVFiltroPratInterfaceTestInnerClass implements OCSRecuperaDatiPVFiltroPraticheInterface {
        public List<OCSPratica> filtraPratiche(List<OCSPratica> pratiche) {
            return null;
        }
    }
    
    @isTest
    public static void testFiltraPratiche() {
        
        OCSPratica o = new OCSPratica();
        List<OCSPratica> l = new List<OCSPratica>();
        l.add(o);
        OCSRecuperaDatiPVFiltroPratInterfaceTestInnerClass ob = new OCSRecuperaDatiPVFiltroPratInterfaceTestInnerClass();
        ob.filtraPratiche(l);
    }

}