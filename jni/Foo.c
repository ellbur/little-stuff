
#include <jni.h>
#include "Foo.h"

#include <stdio.h>

JNIEXPORT void JNICALL Java_Foo_foo1
  (JNIEnv *env, jclass class)
{
	printf("What can we see?\n");
}

JNIEXPORT jdouble JNICALL Java_Foo_read
  (JNIEnv *env, jclass class, jstring text)
{
	const jbyte *textChars;
	double result;
	int i;
	
	textChars = (*env)->GetStringUTFChars(env, text, NULL);
	
	if (textChars == NULL)
		return 0.0;
	
	result = atof(textChars);
	printf("String is %s\n", textChars);
	printf("Result is %f\n", result);
	for (i=0; textChars[i] != '\0'; i++) {
		printf("textChars[i] = %c %d\n", textChars[i], (int) textChars[i]);
	}
	
	(*env)->ReleaseStringUTFChars(env, text, textChars);
	
	return result;
}
