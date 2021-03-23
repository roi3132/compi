%option noyywrap

%{
int counter=0;
%}

DIGIT					[0-9]
NUMBER				[1-6]
STRING				[^<>]+[^<>(!!>)]
ALPHA					[a-zA-Z]
SETCOLOR			"<"(?i:text)" "(?i:color)"="\"((?i:red)|(?i:blue)|(?i:green))\"">"
CLOSESYMB			">"
OPENSYMB			"<"
OPENSYMBCLOSE	"</"
OUEND					(?i:ouend)				
OUBEGIN				(?i:oubegin)
NL						(?i:nl)
HEADER				(?i:h)
BOLD					(?i:bold)
ITALIC				(?i:it)
CENTER				(?i:c)
BLN						(?i:bln)
BL						(?i:bl)

%%

{OPENSYMB}{OUEND}{CLOSESYMB}										fprintf(yyout, "endML\t\t\t\t%s\n", yytext);
{OPENSYMB}{OUBEGIN}{CLOSESYMB}									fprintf(yyout, "startML\t\t\t\t%s\n", yytext);
{OPENSYMB}{NL}{CLOSESYMB}												fprintf(yyout, "newline\t\t\t\t%s\n", yytext);
{OPENSYMB}{HEADER}{NUMBER}{CLOSESYMB}						fprintf(yyout, "begin_heading_mark\t\t%s\tSize %c\n", yytext, yytext[2]);
{OPENSYMBCLOSE}{HEADER}{NUMBER}{CLOSESYMB}			fprintf(yyout, "bend_heading_mark\t\t%s\tSize %c\n", yytext, yytext[3]);
{OPENSYMB}{BOLD}{CLOSESYMB}											fprintf(yyout, "begin_bold_mark\t\t\t%s\n", yytext);
{OPENSYMBCLOSE}{BOLD}{CLOSESYMB}								fprintf(yyout, "end_bold_mark\t\t\t%s\n", yytext);
{OPENSYMB}{ITALIC}{CLOSESYMB}										fprintf(yyout, "italic_marks\t\t\t%s\n", yytext);
{OPENSYMBCLOSE}{ITALIC}{CLOSESYMB}							fprintf(yyout, "end_italic_marks\t\t%s\n", yytext);
{OPENSYMB}"!!"																	fprintf(yyout, "begin_comment\t\t\t%s\n", yytext);
"!!"{CLOSESYMB}																	fprintf(yyout, "end_comment\t\t\t%s\n", yytext);
{OPENSYMB}{CENTER}{CLOSESYMB}										fprintf(yyout, "start_center\t\t\t%s\n", yytext);
{OPENSYMBCLOSE}{CENTER}{CLOSESYMB}							fprintf(yyout, "end_center\t\t\t%s\n", yytext);
{SETCOLOR}																			fprintf(yyout, "set_text_color\t\t\t%s\tColor ", yytext);for(int i=13;i<yyleng-2;i++){fprintf(yyout, "%c", yytext[i]);}fprintf(yyout,"\n");
{OPENSYMB}{BLN}{CLOSESYMB}											fprintf(yyout, "begin_number_bullet\t\t%s\n", yytext);
{OPENSYMBCLOSE}{BLN}{CLOSESYMB}									fprintf(yyout, "end_number_bullet\t\t%s\n", yytext);
{OPENSYMB}{BL}{CLOSESYMB}												fprintf(yyout, "begin_regular_bullet\t\t%s\n", yytext);
{OPENSYMBCLOSE}{BL}{CLOSESYMB}									fprintf(yyout, "end_regular_bullet\t\t%s\n", yytext);
{STRING}																				fprintf(yyout, "string\t\t\t\t%s\n", yytext);
{ALPHA}({ALPHA}|{DIGIT})*												fprintf(yyout, "An identifier, count=%d: %s\n", ++counter, yytext);
[ \t\n] 			{}
.       										fprintf(yyout ,"Unrecognized character!: %s\n", yytext );

%%
#define _CRT_SECCURE_NO_WARNING

int main(int argc, char **argv ){
++argv, --argc;  /* skip over program name */
if ( argc > 0 )
yyin = fopen( argv[0], "r" );
else
yyin = fopen("infile.txt", "r" );
//yyout = stdin;


if ( argc > 1 )
yyout = fopen( argv[1], "w" );
else
yyout = fopen("outfile.txt", "w" );
//yyout = stdout;
fprintf(yyout, "Token \t\t\t\t Lexeme \t\t Attributes \n");

yylex();}
