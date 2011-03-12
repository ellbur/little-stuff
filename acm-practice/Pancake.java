
import java.io.*;

public class Pancake {
	
	public static void main(String[] args) throws Throwable {
		
		BufferedReader br = new BufferedReader(
			new InputStreamReader(new FileInputStream("pancake-input")
		));
		
		for (;;) {
			
			String line = br.readLine();
			if (line == null)
				break;
			
			if (doLine(line))
				break;
		}
		
	}
	
	static boolean doLine(String line) {
		String[] tokens = line.split("\\s+");
		int[] nums = new int[tokens.length];
		
		for (int i=0; i<tokens.length; i++) {
			nums[i] = Integer.parseInt(tokens[i]);
		}
		
		if (nums.length == 1 && nums[0] == 0) {
			return true;
		}
		
		doLine(nums);
		
		return false;
	}
	
	static void doLine(int[] nums) {
		int len = nums[0];
		int[] stack = new int[len];
		
		for (int i=0; i<len; i++) {
			stack[i] = nums[i+1];
		}
		
		doLine(len, stack);
	}
	
	static void doLine(int len, int[] stack) {
		System.out.printf("%d ", (len-1)*2);
		
		for (int target=len; target>1; target--) {
			// find it
			
			for (int i=0; i<len; i++) {
				if (stack[i] == target) {
					System.out.printf("%d %d ", i+1, target);
					flip(stack, i+1);
					flip(stack, target);
					break;
				}
			}
		}
		
		System.out.println();
	}
	
	static void flip(int[] stack, int k) {
		for (int i=0; i<k/2; i++) {
			int t = stack[i];
			stack[i] = stack[k-i-1];
			stack[k-i-1] = t;
		}
	}
}
