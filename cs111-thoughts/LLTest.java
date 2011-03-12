
public class LLTest {
	
	public static void main(String[] args) {
		
		LLNode a = new LLNode();
		LLNode b = new LLNode();
		LLNode c = new LLNode();
		LLNode d = new LLNode();
		
		a.next = b;
		b.next = c;
		c.next = d;
		d.next = null;
		
		System.out.println(
			LLMethods.hasCycle(a));
		
		d.next = c;
		
		System.out.println(
			LLMethods.hasCycle(a));
	}
	
}

