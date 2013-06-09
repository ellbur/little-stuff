
public class Foo {
	
	static class A {
		class B {
		}
	}
	
	A a1 = new A();
	A.B b1 = a1.new B();
	
	public static void main(String[] args) {
		
	}
}

