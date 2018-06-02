%option noyywrap

%x COMENTARIO LANGUAGE INV LANGU NT BT SN

%%
<INITIAL>{
\#								{BEGIN COMENTARIO;}
\%lang[a-zA-Z]+?				{BEGIN LANGUAGE;}
\%baselang						{BEGIN LANGUAGE;}
\%inv[a-zA-Z]+?					{BEGIN INV;}
[a-z]+							{ yylval.c = strdup(yytext); return TITULO;}
[A-Z]+[_]?[A-Z]+                {
									if((strcmp("PT",yytext)==0)||(strcmp("EN",yytext)==0)){
										BEGIN LANGU;
										yylval.c = strdup(yytext);
										return ID;  
									}
									else if(strcmp("NT",yytext)==0){
										BEGIN NT;
										yylval.c = strdup(yytext);
										return ID;
									}
									else if(strcmp("BT",yytext)==0){
										BEGIN BT;
										yylval.c = strdup(yytext);
										return ID;
									}else if(strcmp("SN",yytext)==0){
										BEGIN SN;
										yylval.c = strdup(yytext);
										return ID;
									}
								}
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
	[a-zA-Z]+					{yylval.c = strdup(yytext); return LINGUA;}
	\n 							{BEGIN INITIAL;}
}
<NT>{
	[a-zA-Z]+					{yylval.c = strdup(yytext);return TER;}
	\,							{return yytext[0];}
	\n 							{BEGIN INITIAL;}
}
<BT>{
	[a-zA-Z]+[ ]?[a-zA-Z]+		{yylval.c = strdup(yytext); return GEN;}
	\n 							{BEGIN INITIAL;}		
}
<SN>{
	.* 							{yylval.c = strdup(yytext); return STR;}
	\n 							{BEGIN INITIAL;}
}

%%




