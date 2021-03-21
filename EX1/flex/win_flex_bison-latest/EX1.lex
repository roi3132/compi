%option noyywrap

%{
int counter=0;
%}

DIGIT			[0-9]
NUMBER			[1-6]
ALPHA			[a-zA-Z]
COLOR			"\""(?i:red)|"\""(?i:blue)|"\""(?i:black)
SETCOLOR		"<"(?i:text)(?i:color)"="
CLOSESYMB		">"
OPENSYMB		"<"
OPENSYMBCLOSE	"</"
OUEND			(?i:ouend)				
OUBEGIN			(?i:oubegin)
NL				(?i:nl)
HEADER			(?i:h)

%%

{ALPHA}({ALPHA}|{DIGIT})*     					fprintf(yyout, "An identifier, count=%d: %s\n", ++counter, yytext);
{OPENSYMB}{OUEND}{CLOSESYMB}					fprintf(yyout, "endML\t%s\n", yytext);
{OPENSYMB}{OUBEGIN}{CLOSESYMB}					fprintf(yyout, "startML\t%s\n", yytext);
{OPENSYMB}{NL}{CLOSESYMB}						fprintf(yyout, "newline\t%s\n", yytext);
{OPENSYMB}{HEADER}{NUMBER}{CLOSESYMB}			fprintf(yyout, "begin_heading_mark\t%s\tSize %c\n", yytext, yytext[2]);
{OPENSYMBCLOSE}{HEADER}{NUMBER}{CLOSESYMB}		fprintf(yyout, "bend_heading_mark\t%s\tSize %c\n", yytext, yytext[2]);
{OPENSYMB}"bold"{CLOSESYMB}						fprintf(yyout, "begin_bold_mark\t%s\n", yytext);
{OPENSYMBCLOSE}"bold"{CLOSESYMB}				fprintf(yyout, "end_bold_mark\t%s\n", yytext);
{OPENSYMB}"it"{CLOSESYMB}						fprintf(yyout, "italic_marks\t%s\n", yytext);
{OPENSYMBCLOSE}"it"{CLOSESYMB}					fprintf(yyout, "end_italic_marks\t%s\n", yytext);
{OPENSYMB}"!!"									fprintf(yyout, "begin_comment\t%s\n", yytext);
"!!"{CLOSESYMB}									fprintf(yyout, "end_comment\t%s\n", yytext);
{OPENSYMB}"c"{CLOSESYMB}						fprintf(yyout, "start_center\t%s\n", yytext);
{OPENSYMBCLOSE}"c"{CLOSESYMB}					fprintf(yyout, "end_center\t%s\n", yytext);
{SETCOLOR}{COLOR}{CLOSESYMB}					fprintf(yyout, "set_text_color\t%s\tColor XXX\n", yytext);
{OPENSYMB}"bln"{CLOSESYMB}						fprintf(yyout, "begin_number_bullet\t%s\n", yytext);
{OPENSYMBCLOSE}"bln"{CLOSESYMB}					fprintf(yyout, "end_number_bullet\t%s\n", yytext);
{OPENSYMB}"bl"{CLOSESYMB}						fprintf(yyout, "begin_regular_bullet\t%s\n", yytext);
{OPENSYMBCLOSE}"bl"{CLOSESYMB}					fprintf(yyout, "end_regular_bullet\t%s\n", yytext);
[ \t\n] 			{}
.       										fprintf(yyout ,"Unrecognized character!: %s\n", yytext );

%%

int main(int argc, char **argv ){
++argv, --argc;  /* skip over program name */
if ( argc > 0 )
yyin = fopen( argv[0], "r" );
else
yyin = fopen("infile.txt", "r" );


if ( argc > 1 )
yyout = fopen( argv[1], "w" );
else
yyout = fopen("outfile.txt", "w" );

fprintf(yyout, "Token \t Lexeme \t Attributes \n");

yylex();}
