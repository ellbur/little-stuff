
package foreach;
 
public class Test3 {
	
	public static void main(String[] args)
		throws Throwable
	{
		
		A a1 = new B();
		A a2 = new E().getA();
		
		Apply1.apply("foo", a1, a2);
	}
}
 
