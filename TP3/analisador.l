%option noyywrap

%x COMENTARIO LANGUAGE INV RELACOES SN

%%
<INITIAL>{
\#								{BEGIN COMENTARIO;}
\%lang[a-zA-Z]+?				{BEGIN LANGUAGE;}
\%baselang						{BEGIN LANGUAGE;}
\%inv[a-zA-Z]+?					{BEGIN INV;}
[a-z]+							{ yylval.c = strdup(yytext); return TITULO;}
SN								{ yylval.c = strdup(yytext); BEGIN SN; return ID;}
[A-Z]+							{ yylval.c = strdup(yytext); BEGIN RELACOES; return ID;}
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
<RELACOES>{
	[A-Za-z]+[ ]?[a-z]+			{yylval.c = strdup(yytext);return TERMO;}
	\,							{;}
	\n 							{BEGIN INITIAL;}
}
<SN>{
	.*							{yylval.c = strdup(yytext); return TERMO;}
	\n 							{BEGIN INITIAL;}
}





%%




