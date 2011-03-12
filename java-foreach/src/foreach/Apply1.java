
package foreach;
 
import java.lang.reflect.*;

public class Apply1 {
	
	public static void apply(String methName, Object ... elem)
		throws IllegalAccessException,
		       InvocationTargetException,
			   NoSuchMethodException
	{
		for (Object obj : elem) {
			Class cl = obj.getClass();
			Method meth = cl.getMethod(methName);
			
			meth.invoke(obj);
		}
	}
	
}

