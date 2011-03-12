
package foo;

import javax.annotation.processing.*;

import com.sun.mirror.apt.*;
import com.sun.mirror.declaration.*;
import com.sun.mirror.type.*;
import com.sun.mirror.util.*;

import javax.lang.model.*;
import javax.lang.model.element.*;

import java.util.*;

@SupportedAnnotationTypes(value = {"foo.Flag"})

public class FlagProcessor extends AbstractProcessor {
	
	@Override
	public boolean process(
		Set<? extends TypeElement> annots,
		RoundEnvironment roundEnv)
	{
		System.out.println(roundEnv);
		
		return true;
	}
	
}
