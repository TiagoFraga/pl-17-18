%{
#include <stdio.h>
	
%}

%union {
	char* c;
	char ch;
	int n;	
}


%token<c> LINGUA TITULO ID TRAD TER GEN
%type<c> Thesaurus Metadados Linguagens Base Inversos Inverso Conceitos Conceito Traducao Derivados Derivado Termos Termo Generico

%%

Thesaurus : Metadados Conceitos											{asprintf(&$$, "%s :\n %s ", $1,$2); printf("THESAURUS -> %s\n",$$);}
		  ;

Metadados : Linguagens Base Inversos									{asprintf(&$$, "%s ; %s ; %s", $1,$2,$3);printf("Metadados: %s\n",$$);}
		  ;

Linguagens : LINGUA 													{asprintf(&$$, "%s", $1);}
   		   | Linguagens LINGUA 											{asprintf(&$$, "%s %s", $1,$2);}
   		   ;

Base : LINGUA 															{asprintf(&$$, "%s", $1);}
	 ;

Inversos : Inverso                       								{asprintf(&$$, "(%s)", $1);}
		 | Inversos Inverso   											{asprintf(&$$, "%s (%s)", $1,$2);}
		 ;

Inverso : ID ID															{asprintf(&$$, "%s %s", $1,$2);}
		;

Conceitos : Conceito 													{asprintf(&$$, "%s", $1);}
		  | Conceitos Conceito  										{asprintf(&$$, "%s / %s", $1,$2);}
		  ;

Conceito : TITULO Traducao												{asprintf(&$$, "%s %s %s", $1,$2);printf("Conceito: %s\n",$$);}
		 ;

Traducao : LINGUA TRAD 													{asprintf(&$$, "%s %s", $1,$2);}
		 ;	



%%

#include "lex.yy.c"

int yyerror(char *s){
	printf("Erro sintatico %s blblb\n",s);
	return 0;
}

int main(){
	yyparse();
	printf("FIM\n");
	return 0;
}

