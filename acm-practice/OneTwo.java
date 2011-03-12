
public class OneTwo {
	
	public static void main(String[] args) {
		int maxEnd = 20;
		
		Decimal[] ds = trace(maxEnd);
		
		for (int i=0; i<=maxEnd; i++) {
			System.out.printf("%d: %s\n", i, ds[i]);
		}
	}
	
	static Decimal[] trace(int maxEnd)
	{
		Decimal[] out = new Decimal[maxEnd+1];
		out[0] = new Decimal(0);
		
		Decimal stepPower = new Decimal(maxEnd);
		stepPower.digits[0] = 2;
		
		Decimal stepExponent = new Decimal(1);
		stepExponent.digits[0] = 1;
		
		Decimal nextStepPower = null;
		Decimal nextStepExponent = null;
		
		Decimal follow = new Decimal(maxEnd);
		follow.digits[0] = 2;
		
		Decimal exponent = new Decimal(1);
		exponent.digits[0] = 1;
		
		for (int end=1; end<=maxEnd; end++) {
			
			// Find it
			
			System.out.printf("Searching %d\n", end);
			System.out.printf("stepPower = %s\n", stepPower);
			System.out.printf("stepExponent = %s\n", stepExponent);
			
			for (int i=0; i<10; i++) {
				if (checkEnd(follow, end)) {
					System.out.printf("Found it at %s\n", follow);
					break;
				}
				System.out.printf("%s no\n", follow);
				
				follow.multPlace(stepPower);
				exponent.addExpand(stepExponent);
			}
			
			out[end] = exponent.copy();
			
			if (end >= maxEnd)
				break;
			
			// Step it (if needed)
			
			if (checkEnd(follow, end+1)) {
				System.out.printf("Twofor, continuing\n");
				continue;
			}
			
			System.out.printf("Now finding period\n");
			
			nextStepPower    = stepPower.copy();
			nextStepExponent = stepExponent.copy();
			
			follow.multPlace(stepPower);
			exponent.addExpand(stepExponent);
			
			for (;;) {
				if (checkEnd(follow, end)) {
					System.out.printf("Found it at %s\n", follow);
					
					break;
				}
				
				nextStepPower.multPlace(stepPower);
				nextStepExponent.addExpand(stepExponent);
				
				follow.multPlace(stepPower);
				exponent.addExpand(stepExponent);
			}
			
			stepPower = nextStepPower;
			stepExponent = nextStepExponent;
		}
		
		return out;
	}
	
	static boolean checkEnd(Decimal follow, int end) {
		for (int i=0; i<end; i++) {
			if ((follow.digits[i] != 1) && (follow.digits[i] != 2))
				return false;
		}
		
		return true;
	}
	
	static class Decimal {
		
		int size;
		int[] digits;
		
		Decimal(int _size) {
			this.size = _size;
			this.digits = new int[size];
		}
		
		Decimal copy() {
			Decimal d = new Decimal(size);
			System.arraycopy(digits, 0, d.digits, 0, size);
			
			return d;
		}
		
		public String toString() {
			String t = "";
			for (int i=size-1; i>=0; i--) {
				t += digits[i];
			}
			
			return t;
		}
		
		void expand(int newSize) {
			if (size > newSize)
				return;
			
			int[] newDigits = new int[newSize];
			
			System.arraycopy(digits, 0, newDigits, 0, digits.length);
			
			digits = newDigits;
			size = newSize;
		}
		
		void multPlace(Decimal b) {
			b.expand(size);
			
			int carry = 0;
			int out[] = new int[size];
			
			for (int k=0; k<size; k++) {
				int sum = carry;
				
				for (int i=0; i<=k; i++) {
					int j = k-i;
					
					sum += digits[i] * b.digits[j];
				}
				
				out[k] = sum % 10;
				carry  = sum / 10;
			}
			
			this.digits = out;
		}
		
		void addExpand(Decimal b) {
			expand(b.size);
			b.expand(size);
			
			int carry = 0;
			
			for (int i=0; i<size; i++) {
				int sum = b.digits[i] + digits[i] + carry;
				digits[i] = sum % 10;
				carry = sum / 10;
			}
			
			if (carry != 0) {
				expand(size+1);
				digits[size-1] = carry;
			}
		}
	}
}
