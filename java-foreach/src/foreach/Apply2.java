
package foreach;
 
import java.lang.reflect.*;
import java.util.*;

public class Apply2 {
	
	public static <T> void apply(String methName, Collection<T> elem, Object ... args)
		throws IllegalAccessException,
		       InvocationTargetException,
			   NoSuchMethodException
	{
		for (Object obj : elem) {
			Class cl = obj.getClass();
			System.out.printf("class = %s\n", cl);
			
			Method[] methods = cl.getMethods();
			Method meth = null;
			
			System.out.println(Arrays.asList(methods));
			
			for (Method maybe : methods) {
				if (maybe.getName().equals(methName)) {
					meth = maybe;
					break;
				}
			}
			if (meth == null) {
				throw new NoSuchMethodException(methName);
			}
			
			meth.invoke(obj, args);
		}
	}
	
}
 
