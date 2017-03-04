
public class Example {
    // int → String
    static String yo(int x) {
	if (x == 0)
	    return "Hello";
	else
	    return "No!!!";
    }
    
    public static void main(String[] args) {
	System.out.println(yo(0));
	System.out.println(yo(1));
    }
}
