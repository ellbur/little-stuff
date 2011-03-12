
package foreach;
 
public class H {
	
	public G getG() {
		return new I();
	}
	
	private class I implements G {
		
		public void foo(boolean s) {
			System.out.printf("H.I.foo(%s)\n", s);
		}
	}
}

