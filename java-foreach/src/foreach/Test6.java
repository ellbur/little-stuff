
package foreach;
 
import java.util.*;

public class Test6 {
	
	public static void main(String[] args)
		throws Throwable
	{
		A a1 = new B();
		A a2 = new E().getA();
		
		apply.Apply3.apply(
			"foo",
			Arrays.asList(new Object[] { a1, a2 })
		);
		
	}
}
 
