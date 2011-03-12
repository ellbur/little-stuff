
package foreach;
 
public class Test2 {
	
	public static void main(String[] args)
		throws Throwable
	{
		
		A a1 = new B();
		A a2 = C.getA();
		
		Apply1.apply("foo", a1, a2);
		
	}
}
 
