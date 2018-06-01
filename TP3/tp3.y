%{
#include <stdio.h>
	
%}

%union {
	char* c;
	char ch;
	int n;	
}


%token<c> LINGUA TITULO LANG ID GEN STR TER 

%type<c> Thesaurus Metadados Conceitos Linguagens Base Inversos Inverso Conceito Derivados Generico Nota Termos Termo 

%%

Thesaurus : Metadados  Conceitos 										{printf("1\n");}
		  ;

Metadados : Linguagens Base Inversos									{printf("Metadados: \n", $1,$2,$3);}
		  ;

Linguagens : LINGUA 													{asprintf(&$$, "%s", $1);printf("LINGUA: %s\n",$1);}
   		   | Linguagens LINGUA 											{asprintf(&$$, "%s %s", $1,$2);printf("Linguagens: %s %s\n",$1,$2);}
   		   ;

Base : LINGUA 															{asprintf(&$$, "%s", $1);printf("Base: %s\n", $1);}
	 ;

Inversos : Inverso                       								{asprintf(&$$, "%s", $1);printf("Inversos: %s\n",$1);}
		 | Inversos Inverso   											{printf("8\n");}
		 ;

Inverso : ID ID															{asprintf(&$$, "%s %s", $1,$2);printf("Inverso: %s %s\n", $1,$2);}
		;


Conceitos : Conceito 													{printf("3\n");}
		  | Conceitos Conceito  										{printf("4\n");}
		  ;


Conceito : TITULO LINGUA Derivados Generico Nota 						{printf("9\n");}
		 ;


Derivados : ID Termos 													{printf("10\n");}
	      ;

Termos : Termo 															{printf("11\n");}
	   | Termos ',' Termo 												{printf("12\n");} 
	   ;

Termo : TER 															{printf("13\n");}
	  ;

Generico : ID GEN  														{printf("14\n");}
		 ;

Nota : ID STR 															{printf("NOTAS: %s %s", $1, $2);}
	 ;



%%

#include "lex.yy.c"

int yyerror(char *s){
	printf("Erro sintatico %s\n",s);
	return 0;
}

int main(){
	yyparse();
	return 0;
}

