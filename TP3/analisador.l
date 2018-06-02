%option noyywrap

%x COMENTARIO LANGUAGE INV LANGU NT

%%
<INITIAL>{
\#								{BEGIN COMENTARIO;}
\%lang[a-zA-Z]+?				{BEGIN LANGUAGE;}
\%baselang						{BEGIN LANGUAGE;}
\%inv[a-zA-Z]+?					{BEGIN INV;}
[a-z]+							{ yylval.c = strdup(yytext); return TITULO;}
PT								{
									BEGIN LANGU;
									yylval.c = strdup(yytext);
									return LINGUA;
								} 
EN								{
									BEGIN LANGU;
									yylval.c = strdup(yytext);
									return LINGUA;

								}
NT.*							{;}
BT.*							{;}
SN.*							{;}
.|\n							{;} 
}
<COMENTARIO>{
	.							{;}
	\n							{BEGIN INITIAL;}
}
<LANGUAGE>{
	[A-Z]{2}					{yylval.c = strdup(yytext); return LINGUA;}
	\n							{BEGIN INITIAL;}
}
<INV>{
	[A-Z]+[\_]?[A-Z]+			{yylval.c = strdup(yytext); return ID;}
	\n							{BEGIN INITIAL;}
}
<LANGU>{
	[a-zA-Z]+					{yylval.c = strdup(yytext); return TRAD;}
	\n 							{BEGIN INITIAL;}
}
<NT>{
	[a-zA-Z]+					{yylval.c = strdup(yytext);return TER;}
	\, 							{;}
	\n 							{BEGIN INITIAL;}
}




%%




