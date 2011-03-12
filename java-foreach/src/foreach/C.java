
package foreach;
 
public class C {
	
	public static A getA() {
		return new D();
	}
	
	private static class D implements A {
		
		public void foo() {
			System.out.println("C.D.foo()");
		}
	}
}

