import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import java_cup.runtime.Scanner;
import java_cup.runtime.Symbol;
import tiger.errormsg.ErrorMsg;
import tiger.parse.Yylex;
import tiger.parse.parser;
import tiger.parse.sym;

public class CupTest {

    /**
     * @param args
     * @throws FileNotFoundException
     */
    public static void main(String[] args) throws Exception {
        String filename = "/Users/suluner/Project/Java/Tiger/src/test/java/cuptest.txt";
        ErrorMsg errorMsg = new ErrorMsg(filename);
        InputStream inp = new FileInputStream(filename);
        Scanner lexer = new Yylex(inp, errorMsg);
        parser p = new parser(lexer, errorMsg);
        try {
            Symbol s = p.parse();
            System.out.println(s);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}