
import java.util.*;
import java.io.*;
import pulsetor.display_application.*;


public class EMSAToOctave {
	
	public static void main(String[] args) throws Exception {
		
		if (args.length != 1) {
			return;
		}
		
		String filename = args[0];
		SpectrumData spectrum = new SpectrumData();
		spectrum.readFile(filename);
		
		String outputname = String.format("/tmp/spectrum-%d.txt",
			filename.hashCode());
		PrintWriter out = new PrintWriter(new FileOutputStream(outputname));
		
		out.printf("%f\n", spectrum.offset);
		out.printf("%f\n", spectrum.evPerBin);
		
		for (int i=0; i<spectrum.length; i++) {
			out.printf("%d\n", spectrum.spectrum[i]);
		}
		
		out.flush();
		out.close();
		
		System.out.printf("%s", outputname);
	}
}
