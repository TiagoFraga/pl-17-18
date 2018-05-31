%{
#include <stdio.h>
	
}%

%union {
	char* c;
	int n;	
}

%token<c> BT NT PT EN TITULO SN TRADUCAO STR FILHO

%type<c> Programa Informacoes Metadados Conceitos Linguagens Base Inversos Lingua Inverso Conceito Relacao LangConceito FilhosConceito PaiConceito Notas Lista

%%

Programa : Informacoes
		 ;

Informacoes: Metadados ':' Conceitos 

Metadados : Linguagens ';' Base ';' Inversos ';'
		  ;

Linguagens : Lingua
		   | Linguagens Lingua
		   ;

Lingua : PT 
	   | EN
	   ;

Base : Lingua 
	 ;

Inversos : 
		 | Inverso 
		 | Inversos ',' Inverso
		 ;

Inverso : Relacao Relacao
	    ;


Relacao : BT
		| NT
		;

Conceitos : Conceito
 		  | Conceitos '-' Conceito
 		  ;

Conceito : TITULO ';' LangConceito ';' FilhosConceito ';' PaiConceito ';' Notas 
		 ;

LangConceito : Lingua TRADUCAO 
             ;


FilhosConceito : 
			   | NT Lista
			   ;

Lista : FILHO
	  | Lista ',' FILHO
	  ;


PaiConceito : 
			| BT PAI
			;

Notas : 
	  | SN STR
	  ;












%%

#include "lex.yy.c"

int yyerror(char *s){
	printf("Erro sintatico %s\n",s);
}

int main(){
	yyparse();
	return 0;
}