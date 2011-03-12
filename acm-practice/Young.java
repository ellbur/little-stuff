
import java.io.*;
import java.util.*;

public class Young {
	
	public static void main(String[] args)
		throws Throwable
	{
		Scanner sc = new Scanner(new FileInputStream("young-input"));
		
		for (;;)
		{
			int nrow = sc.nextInt();
			
			if (nrow == 0) {
				break;
			}
			
			int[] rowCounts = new int[nrow];
			
			for (int i=0; i<nrow; i++) {
				rowCounts[i] = sc.nextInt();
			}
			
			System.out.println(doCount(rowCounts));
			System.out.flush();
		}
	}
	
	static int doCount(int[] rowCounts)
	{
		int N = 0;
		for (int i=0; i<rowCounts.length; i++) {
			N += rowCounts[i];
		}
		
		// greater[i][j] is i > j
		// operating on cells.
		boolean[][] greater = new boolean[N][N];
		
		int[][] toCell = new int[rowCounts.length][];
		int cell=0;
		
		for (int r=0; r<rowCounts.length; r++) {
			toCell[r] = new int[rowCounts[r]];
			
			for (int c=0; c<rowCounts[r]; c++) {
				toCell[r][c] = cell;
				cell++;
			}
		}
		
		int[] a = new int[N];
		int[] b = new int[N];
		
		for (int r=0; r<rowCounts.length; r++) {
			for (int c=0; c<rowCounts[r]; c++) {
				
				if (c > 0) {
					greater[toCell[r][c-1]][toCell[r][c]] = true;
					a[toCell[r][c]] = toCell[r][c-1];
				}
				
				if (r > 0) {
					greater[toCell[r-1][c]][toCell[r][c]] = true;
					b[toCell[r][c]] = toCell[r-1][c];
				}
			}
		}
		
		return findGreater(N, a, b, greater);
	}
	
	static int findGreater(int N, int[] a, int[] b, boolean[][] greater) {
		
		transFlood(N, greater);
		
		boolean[] taken = new boolean[N];
		
		int[] spotsToThings = new int[N];
		int[] thingsToSpots = new int[N];
		
		Arrays.fill(spotsToThings, -1);
		Arrays.fill(thingsToSpots, -1);
		
		int[] childCounts = new int[N];
		
		Arrays.fill(childCounts, -1);
		
		findChildCounts(N, childCounts, greater);
		
		return testPoint(N,
			greater,
			a, b,
			childCounts,
			taken,
			spotsToThings,
			0
		);
	}
	
	static int testPoint(
		int N,
		boolean[][] greater,
		int[] a,
		int[] b,
		int[] childCounts,
		boolean[] taken,
		int[] spotsToThings,
		int i
	)
	{
		if (i >= N)
			return 1;
		
		int rest = childCounts[i];
		
		int start = spotsToThings[a[i]];
		if (start < spotsToThings[b[i]])
			start = spotsToThings[b[i]];
		
		if (start<0) start = 0;
		
		int stop = saveRest(taken, rest);
		
		int count = 0;
		
		for (int t=start; t<=stop; t++) {
			
			if (taken[t]) continue;
			
			spotsToThings[i] = t;
			taken[t] = true;
			
			int desc = testPoint(N, greater, a, b, childCounts, taken,
				spotsToThings, i+1);
			
			if (desc == 0)
				System.out.println("fail");
			
			count += desc;
			
			spotsToThings[i] = -1;
			taken[t] = false;
		}
		
		return count;
	}
	
	static void transFlood(int N, boolean[][] greater) {
		for (int i=0; i<N; i++) {
			transFlood(N, greater, i);
		}
	}
	
	static void transFlood(int N, boolean[][] greater, int i) {
		for (int j=0; j<N; j++) {
			if (! greater[i][j]) continue;
			
			for (int k=0; k<N; k++) {
				if (greater[j][k])
					greater[i][k] = true;
			}
		}
	}
	
	static void findChildCounts(int N, int[] childCounts, boolean[][] greater) {
		for (int i=0; i<N; i++) {
			childCounts[i] = 0;
			
			for (int j=0; j<N; j++) {
				if (greater[i][j])
					childCounts[i]++;
			}
		}
	}
	
	static int saveRest(boolean[] taken, int toSave) {
		int avalCount = 0;
		
		for (int j=taken.length-1; j>=0; j--) {
			if (!taken[j]) {
				if (avalCount >= toSave)
					return j;
				
				avalCount++;
			}
		}
		
		return -1;
	}
}
