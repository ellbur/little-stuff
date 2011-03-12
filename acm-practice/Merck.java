
import java.io.*;

public class Merck {
	
	public static void main(String[] args) throws Throwable {
		
		BufferedReader br = new BufferedReader(
			new InputStreamReader(new FileInputStream("merck-input")));
		
		String header = br.readLine().trim();
		int numScene = Integer.parseInt(header);
		
		for (int sc=0; sc<numScene; sc++) {
			
			int numMoves = Integer.parseInt(br.readLine().trim());
			
			Move[] moves = new Move[numMoves];
			
			for (int m=0; m<numMoves; m++) {
				String str = br.readLine();
				String[] toks = str.split("\\s+");
				
				moves[m] = new Move(
					Integer.parseInt(toks[0]),
					Integer.parseInt(toks[1])
				);
			}
			
			doScene(moves, sc);
		}
	}
	
	static void doScene(Move[] moves, int sc) {
		// Count points on the edges
		
		int E = 0;
		
		for (int i=0; i<moves.length; i++) {
			E += gcd(moves[i].dx, moves[i].dy);
		}
		
		// Count points in the interior
		
		Vex[] starts = new Vex[moves.length+1];
		starts[0] = new Vex(0, 0);
		
		int minx = 0, miny = 0, maxx = 0, maxy = 0;
		
		for (int i=1; i<moves.length+1; i++) {
			starts[i] = new Vex(
				starts[i-1].x + moves[i-1].dx,
				starts[i-1].y + moves[i-1].dy
			);
			
			if (starts[i].x < minx) minx = starts[i].x;
			if (starts[i].x > maxx) maxx = starts[i].x;
			
			if (starts[i].y < miny) miny = starts[i].y;
			if (starts[i].y > maxy) maxy = starts[i].y;
		}
		
		int I = 0;
		
		for (int x=minx-1; x<maxx+1; x++) {
			
			boolean in = false;
			boolean on = false;
			
			for (int y=miny-1; y<maxy+1; y++) {
				
				if (in && !on)
					I += 1;
				
				on = false;
				
				for (int m=0; m<moves.length; m++) {
					int x1 = starts[m].x;
					int y1 = starts[m].y;
					
					int x2 = starts[m+1].x;
					int y2 = starts[m+1].y;
					
					if (x1 > x2) {
						int t = x2;
						x2 = x1;
						x1 = t;
						
						t = y2;
						y2 = y1;
						y1 = t;
					}
					
					int h = y1*(x2-x1) + (y2-y1)*(x-x1);
					int h1 = y*(x2-x1);
					int h2 = (y+1)*(x2-x1);
					
					if (x >= x1 && x < x2 && h1 < h && h2 >= h) {
						in = !in;
					}
					if (h2 == h) {
						on = true;
					}
				}
			}
		}
		
		double A = 0.0;
		
		for (int m=0; m<moves.length; m++) {
			int u1 = starts[m].x;
			int u2 = starts[m].y;
			
			int v1 = starts[m+1].x;
			int v2 = starts[m+1].y;
			
			A += (u1*v2 - u2*v1) / 2;
		}
		
		System.out.printf("Scenarie #%d:\n%d %d %.1f\n", sc+1, I, E, A);
	}
	
	static int gcd(int a, int b) {
		a = Math.abs(a);
		b = Math.abs(b);
		
		for (int x = Math.max(a,b); x>=1; x--) {
			if (a%x == 0 && b%x == 0) return x;
		}
		return 1;
	}
	
	static class Move {
		int dx;
		int dy;
		
		Move(int _dx, int _dy) {
			this.dx = _dx;
			this.dy = _dy;
		}
	}
	
	static class Vex {
		int x;
		int y;
		
		Vex(int _x, int _y) {
			this.x = _x;
			this.y = _y;
		}
	}
	
}

