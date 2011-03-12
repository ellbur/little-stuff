
package apply;
 
import java.lang.reflect.*;
import java.util.*;

public class Apply3 {
	
	public static void apply(String methName, Collection elem)
		throws IllegalAccessException,
		       InvocationTargetException,
			   NoSuchMethodException
	{
		for (Object obj : elem) {
			Class cl = obj.getClass();
			System.out.printf("class = %s\n", cl);
			
			Method meth = cl.getMethod(methName);
			
			meth.invoke(obj);
		}
	}
	
}
 
