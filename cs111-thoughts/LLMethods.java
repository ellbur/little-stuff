
public class LLMethods {
	
	public static <T> boolean hasCycle(LLNode<T> head) {
		
		LLNode<LLNode<T>> seen = null;
		
		LLNode<T> ptr = head;
		while (ptr != null) {
			if (contains(seen, ptr))
				return true;
			
			seen = prepend(seen, ptr);
			ptr = ptr.next;
		}
		
		return false;
	}
	
	public static <T> boolean contains(LLNode<T> head, T item) {
		LLNode<T> ptr = head;
		while (ptr != null) {
			
			if (ptr.object.equals(item))
				return true;
			
			ptr = ptr.next;
		}
		
		return false;
	}
	
	public static <T> LLNode<LLNode<T>> subsets(LLNode<T> head, int k) {
		
		if (k == 0) {
			return new LLNode<LLNode<T>>();
		}
		else if (head == null) {
			return null;
		}
		
		LLNode<LLNode<T>> sink = null;
		
		LLNode<T> start = head;
		while (start != null) {
			
			LLNode<LLNode<T>> rest = subsets(start.next, k-1);
			while (rest != null) {
				
				LLNode<T> aug = prepend(rest.object, start.object);
				sink = prepend(sink, aug);
				
				rest = rest.next;
			}
			
			start = start.next;
		}
		
		return sink;
	}
	
	public static <T> LLNode<T> reverse1(LLNode<T> head) {
		
		LLNode<T> sink = null;
		
		LLNode<T> ptr = head;
		while (ptr != null) {
			
			sink = prepend(sink, ptr.object);
			
			ptr = ptr.next;
		}
		
		return sink;
	}
	
	public static <T> LLNode<T> reverse2(LLNode<T> head) {
		
		LLNode<T> sink = null;
		
		LLNode<T> ptr = head;
		while (ptr != null) {
			LLNode next = ptr.next;
			
			ptr.next = sink;
			sink = ptr;
			
			ptr = next;
		}
		
		return sink;
	}
	
	public static <T> void print(LLNode<T> head) {
		
		LLNode<T> ptr = head;
		while (ptr != null) {
			
			System.out.print(ptr.object);
			if (head.next != null)
				System.out.print(" ");
			
			ptr = ptr.next;
		}
		
		System.out.println();
	}
	
	public static <T> LLNode<T> prepend(LLNode<T> head, T object) {
		LLNode<T> n = new LLNode<T>();
		n.object = object;
		n.next   = head;
		
		return n;
	}
}

