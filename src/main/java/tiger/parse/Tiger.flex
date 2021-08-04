package tiger.parse;
import tiger.errormsg.ErrorMsg;
import java_cup.runtime.Symbol;
import java_cup.runtime.Scanner;

%%

%{
    StringBuffer string = new StringBuffer();
    int count;

    private void newline() {
      errorMsg.newline(yychar);
    }

    private void err(int pos, String s) {
        errorMsg.error(pos, s);
    }

    private void err(String s) {
        err(yychar, s);
    }

    private Symbol tok(int kind, Object value) {
        return new Symbol(kind, yychar, yychar+yylength(), value);
    }

    public Yylex(java.io.InputStream s, ErrorMsg e) {
      this(s);
      errorMsg = e;
    }

    private ErrorMsg errorMsg;

%}

%eofval{
    {
	    if (yystate()==COMMENT) err("Comment symbol don't match!");
	    if (yystate()==STRING) err("String presentation error!");
	    if (yystate()==STRING1) err("String presentation error!");
        return tok(sym.EOF, null);
    }
%eofval}

LineTerminator = \r|\n|\r\n|\n\r
Identifier = [a-zA-Z][:jletterdigit:]*
DecIntegerLiteral = [0-9]+
WhiteSpace = \n|\r|\r\n|\t|\f|\n\r

%state COMMENT
%state STRING
%state STRING1

%line
%char
%cup

%%

<YYINITIAL> {
    \" {string.setLength(0);yybegin(STRING);}
    "/*" {count=1;yybegin(COMMENT);}
    "*/" {err("Comment symbol don't match!");}
    " " {}
    "," {return tok(sym.COMMA, null);}
    "/" {return tok(sym.DIVIDE,null);}
    ":" {return tok(sym.COLON,null);}
    "else" {return tok(sym.ELSE,null);}
    "do" {return tok(sym.DO,null);}
    "nil" {return tok(sym.NIL,null);}
    "|" {return tok(sym.OR,null);}
    ">" {return tok(sym.GT,null);}
    ">=" {return tok(sym.GE,null);}
    "<" {return tok(sym.LT,null);}
    "<=" {return tok(sym.LE,null);}
    "of" {return tok(sym.OF,null);}
    "-" {return tok(sym.MINUS,null);}
    "array" {return tok(sym.ARRAY,null);}
    "type" {return tok(sym.TYPE,null);}
    "for" {return tok(sym.FOR,null);}
    "to" {return tok(sym.TO,null);}
    "in" {return tok(sym.IN,null);}
    "end" {return tok(sym.END,null);}
    ":=" {return tok(sym.ASSIGN,null);}
    "." {return tok(sym.DOT,null);}
    "if" {return tok(sym.IF,null);}
    ";" {return tok(sym.SEMICOLON,null);}
    "while" {return tok(sym.WHILE,null);}
    "var" {return tok(sym.VAR,null);}
    "(" {return tok(sym.LPAREN,null);}
    ")" {return tok(sym.RPAREN,null);}
    "[" {return tok(sym.LBRACK,null);}
    "]" {return tok(sym.RBRACK,null);}
    "{" {return tok(sym.LBRACE,null);}
    "}" {return tok(sym.RBRACE,null);}
    "let" {return tok(sym.LET,null);}
    "+" {return tok(sym.PLUS,null);}
    "then" {return tok(sym.THEN,null);}
    "function" {return tok(sym.FUNCTION,null);}
    "=" {return tok(sym.EQ,null);}
    "break" {return tok(sym.BREAK,null);}
    "&" {return tok(sym.AND,null);}
    "*" {return tok(sym.TIMES,null);}
    "<>" {return tok(sym.NEQ,null);}
    {Identifier} {return tok(sym.ID,yytext());}
    {DecIntegerLiteral} {return tok(sym.INT,new Integer(yytext()));}
    {LineTerminator}	{ newline(); }
    {WhiteSpace}	{ /* do nothing */ }
    [^] {err("Illegal character < "+yytext()+" >!");}
}

<STRING> {
    \" {yybegin(YYINITIAL);return tok(sym.STRING,string.toString());}
    \\[0-9][0-9][0-9] { int tmp=Integer.parseInt(yytext().substring(1, 4));if(tmp>255) err("exceed \\ddd"); else string.append((char)tmp);}
    [^\n\t\"\\]+ {string.append(yytext());}
    \\t {string.append('\t');}
    \\n {string.append('\n');}
    \\\" {string.append('\"');}
    \\\\ {string.append('\\');}
    {LineTerminator} {err("String presentation error!");}
    \\ {yybegin(STRING1);}
}

<STRING1> {
    {WhiteSpace} {}
    " " {}
    \\ {yybegin(STRING);}
    \" {err("\\dont match");}
    [^] {string.append(yytext());}
}

<COMMENT> {
    "/*" {count++;}
    "*/" {count--;if (count==0) {yybegin(YYINITIAL);}}
    [^] {}
}
