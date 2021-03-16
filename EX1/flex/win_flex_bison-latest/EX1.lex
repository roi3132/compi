%option noyywrap

%{
int counter=0;
%}

DIGIT    [0-9]
NUMBER   [1-6]
ALPHA	 [a-zA-Z]
COLOR    "red" | "blue" | "black"
SETCOLOR "<text color="
CLOSESYMB ">"


%%

{ALPHA}({ALPHA}|{DIGIT})*       fprintf(yyout, "An identifier, count=%d: %s\n", ++counter, yytext);
"<ouend>"                       fprintf("endML");
"<oubegin>"                     fprintf("startML");
"<nl>"							fprintf("\n");
"<bold"                         fprintf("begin_bold_mark");
"</bold"                        fprintf("end bold mark");
"<it>"							fprintf("italic marks");
"</it" {CLOSESYMB}							fprintf("end italic marks");
"<!!"							fprintf("begin comment");
"!!>"							fprintf("end comment");
"<c>"							fprintf("start center");
"</c>"						    fprintf("end center");
{SETCOLOR} {COLOR} {CLOSESYMB}  fprintf("end center");

[ \t\n] 			{}
.       			fprintf(yyout ,"Unrecognized character!: %s\n", yytext );

%%

int main(int argc, char **argv ){
++argv, --argc;  /* skip over program name */
if ( argc > 0 )
yyin = fopen( argv[0], "r" );
else
yyin = stdin;


if ( argc > 1 )
yyout = fopen( argv[1], "w" );
else
yyout = stdout;

fprintf("Token \t Lexeme \t Attributes \n");

yylex();}
