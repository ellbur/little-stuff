import java.io.*;

public class IO
{
	private static BufferedReader kb =
		new BufferedReader(new InputStreamReader(System.in));

	public static String readString()
	{
		while (true) {
			try {
				return kb.readLine();
			} catch (IOException e) {
				// should never happen
			}
		}
	}

	public static int readInt()
	{
		while (true) {
			try {
				String s = kb.readLine();
				return Integer.parseInt(s);
			} catch (NumberFormatException e) {
				System.out.print("That is not an integer.  Enter again: ");
			} catch (IOException e) {
				// should never happen
			}
		}
	}

	public static double readDouble()
	{
		while (true) {
			try {
				String s = kb.readLine();
				return Double.parseDouble(s);
			} catch (NumberFormatException e) {
				System.out.print("That is not a number.  Enter again: ");
			} catch (IOException e) {
				// should never happen
			}
		}
	}

	public static char readChar()
	{
		String s = null;

		try {
			s = kb.readLine();
		} catch (IOException e) {
			// should never happen
		}

		while (s.length() != 1) {
			System.out.print("That is not a single character.  Enter again: ");
			try {
				s = kb.readLine();
			} catch (IOException e) {
				// should never happen
			}
		}

		return s.charAt(0);
	}

        public static boolean readBoolean()
        {
                String s = null;
 
                while (true) {
                        try {
                                s = kb.readLine();
                        } catch (IOException e) {
                                // should never happen
                        }
 
                        if (s.equalsIgnoreCase("yes") ||
			    s.equalsIgnoreCase("y") ||
			    s.equalsIgnoreCase("true") ||
			    s.equalsIgnoreCase("t")) {
                                return true;
                        } else if (s.equalsIgnoreCase("no") ||
			           s.equalsIgnoreCase("n") ||
			           s.equalsIgnoreCase("false") ||
			           s.equalsIgnoreCase("f")) {
                                return false;
                        } else {
                                System.out.print("Enter \"yes\" or \"no\": ");
                        }
                }
        }

	public static void outputStringAnswer(String s)
	{
		System.out.println("RESULT: \"" + s + "\"");
	}

	public static void outputIntAnswer(int i)
	{
		System.out.println("RESULT: " + i);
	}

	public static void outputDoubleAnswer(double d)
	{
		System.out.println("RESULT: " + d);
	}

	public static void outputCharAnswer(char c)
	{
		System.out.println("RESULT: '" + c + "'");
	}

	public static void outputBooleanAnswer(boolean b)
	{
		System.out.println("RESULT: " + b);
	}

	public static void reportBadInput()
	{
		System.out.println("User entered bad input.");
	}
}
