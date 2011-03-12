
package foreach;
 
public class E {
	
	public A getA() {
		return new F();
	}
	
	private class F implements A {
		
		public void foo() {
			System.out.println("E.F.foo()");
		}
	}
}

