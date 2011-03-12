
package foreach;
 
public class Test1 {
	
	public static void main(String[] args)
		throws Throwable
	{
		
		A a1 = new B();
		A a2 = new B();
		
		Apply1.apply("foo", a1, a2);
		
	}
}

