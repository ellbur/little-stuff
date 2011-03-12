
public class Optim {
	
	public static void main(String[] args) {
		
		System.out.println(System.currentTimeMillis());
		
		double a = 2;
		
		for (int i=0; i<100000000; i++) {
			a = Math.sin(a);
		}
		
		System.out.println(System.currentTimeMillis());
		//System.out.println(a);
		
	}
	
}
