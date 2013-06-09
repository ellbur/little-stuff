
import java.io.*;

public class System {
    public static PrintStream out = null;
    public static InputStream in = null;
    
    public static void setOut(PrintStream _out) { System.out = _out; }
    public static void setIn(InputStream _in)  { System.in = _in; }
}

