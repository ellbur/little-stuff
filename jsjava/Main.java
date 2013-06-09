
import java.applet.*;
import java.util.*;
import java.net.*;
import java.lang.reflect.*;
import java.io.*;
import java.nio.*;
import java.nio.channels.*;

public class Main extends Applet {
    private Deque<String> lines = new ArrayDeque<String>();
    private static int maxLines = 20;
    
    private Object win;
    private Pipe stdout, stdin;
    private PrintStream phone;
    
    public void init() {
        try {
            stdout = Pipe.open();
            stdin = Pipe.open();
            phone = new PrintStream(Channels.newOutputStream(stdin.sink()));
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        
        try {
            System.setOut(new PrintStream(
                Channels.newOutputStream(stdout.sink())));
            System.setIn(Channels.newInputStream(stdin.source()));
            System.out.println("\n");
            System.out.flush();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        
        new Thread() {public void run() { processIOOrElse(); }}.start();
        new Thread() {public void run() { Game.main(null); }}.start();
    }
    
    private void invokeCallback() {
        if (win == null)
            return;
        
        try {
            Method eval = win.getClass().getMethod("eval", String.class);
            eval.invoke(win, "callback();");
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void processIOOrElse() {
        try {
            processIO();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void processIO() throws Exception {
        stdout.source().configureBlocking(false);
        Selector selector = Selector.open();
        SelectionKey selKey = stdout.source().register(
            selector, SelectionKey.OP_READ);
        Reader reader = Channels.newReader(stdout.source(), "utf-8");
            
        CharBuffer buf = CharBuffer.allocate(1000);
        buf.clear();
        
        for (;;) {
            int timeout = 100;
            long start = java.lang.System.currentTimeMillis();
            long end = start + timeout;
            
            for (;;) {
                int left = (int)(end - java.lang.System.currentTimeMillis());
                if (left <= 0) break;
            
                foo.println("Waiting + " + left);
                selector.select(left);
                foo.println("Woke up");
                if (selKey.isReadable()) {
                    foo.println("Reading...");
                    int count = reader.read(buf);
                    foo.println("Read " + count + " chars");
                }
            }
            
            if (buf.position() > 0) {
                int size = buf.position();
                buf.position(0);
                foo.println("Acquiring " + buf.position() + " chars");
                String text = buf.subSequence(0, size).toString();
                foo.println("Feeding " + text);
                addText(text);
                buf.clear();
                invokeCallback();
            }
        }
    }
    
    PrintStream foo = java.lang.System.out;
    
    private void addText(String text) {
        String[] newLines = text.split("\\n", -1);
        int start = 0;
        
        if (lines.size() > 0 && newLines.length > 0) {
            lines.addLast(lines.removeLast() + newLines[0]);
            start = 1;
        }
        
        for (int i=start; i<newLines.length; i++) {
            lines.addLast(newLines[i]);
        }
        
        while (lines.size() > maxLines) {
            lines.removeFirst();
        }
    }
    
    public void setup(Object _win) {
        win = _win;
    }
    
    public void feed(String line) {
        int boundary = line.indexOf("++++++++++");
        line = line.substring(0, boundary);
        addText(line + "\n");
        phone.println(line);
    }
    
    public String getText() {
        String text = "";
        boolean yet = false;
        for (String line : lines) {
            if (yet) text += "\n";
            text += line;
            yet = true;
        }
        return text;
    }
}

