
import java.io.*;

public class Foo {
	
	static {
		String path = new File("./Foo.so").getAbsolutePath();
		System.load(path);
	}
	
	native static void foo1();
	native static double read(String text);
	
	public static void main(String[] args) {
		foo1();
		System.out.println(read("12.3"));
	}
}

