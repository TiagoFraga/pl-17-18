%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>



/* ---------------- DADOS ---------------*/

typedef struct linguas{
	char* nome;
	struct linguas* next;
}Lista_Linguas;

typedef struct inversos{
	char* primeiro;
	char* segundo;
	struct inversos* next;
}Lista_Inversos;


typedef struct dados{
	Lista_Linguas* linguas;
	char* baseLanguage;
	Lista_Inversos* inversos;
}Lista_Dados;



/*--------------- CONCEITOS --------------- */

typedef struct termos{
	char* termo;
	struct termos* next;
}Lista_Termos;

typedef struct relacoes{
	char* id;
	Lista_Termos* termos;
	struct relacoes* next;
}Lista_Relacoes;


typedef struct conceitos{
	char* titulo;
	Lista_Relacoes* relacoes;
	struct conceitos* next;
}Lista_Conceitos;


/* ---------------- CABEÇA DO FICHEIRO ---------------*/

typedef struct doc {
	Lista_Dados* dados;
	Lista_Conceitos* conceitos;		
}Document;

Document* doc;
Lista_Relacoes* temp;
int d;


/*------------------------------*/


%}

%union {
	char* c;
	char ch;
	int n;	
}


%token<c> LINGUA TITULO ID TERMO
%type<c> Thesaurus Metadados Linguagens Base Inversos Inverso Conceitos Conceito Relacoes Relacao Termos

%%

Thesaurus : Metadados Conceitos											{asprintf(&$$, "%s : %s", $1,$2);}
		  ;

Metadados : Linguagens Base Inversos									{asprintf(&$$, "%s ; %s ; %s", $1,$2,$3);}
		  ;

Linguagens : LINGUA 													{asprintf(&$$, "%s", $1);adicionaLingua(doc,$$);}
   		   | Linguagens LINGUA 											{asprintf(&$$, "%s %s", $1,$2);d = adicionaLingua(doc,$2);}
   		   ;

Base : LINGUA 															{asprintf(&$$, "%s", $1);adicionaBaseLang(doc,$$);}
	 ;

Inversos : Inverso                       								{asprintf(&$$, "(%s)", $1);}
		 | Inversos Inverso   											{asprintf(&$$, "%s (%s)", $1,$2);}
		 ;

Inverso : ID ID															{asprintf(&$$, "%s %s", $1,$2);adicionaInverso(doc,$1,$2);}
		;

Conceitos : Conceito 													{asprintf(&$$, "%s", $1);}
		  | Conceitos Conceito  										{asprintf(&$$, "%s / %s", $1,$2);}
		  ;

Conceito : TITULO Relacoes												{asprintf(&$$, "%s %s", $1,$2);adicionaConceito(doc,$1);}
		 ;

Relacoes : Relacao														{asprintf(&$$, "%s", $1);}
		 | Relacoes Relacao												{asprintf(&$$, "%s ; %s", $1,$2);}
		 ;

Relacao : ID Termos														{asprintf(&$$, "%s : %s", $1,$2);adicionaRelacao(doc,$1);}
		;

Termos : TERMO 															{asprintf(&$$, "%s", $1);adicionaTermo(doc,$1);}
	   | Termos TERMO 													{asprintf(&$$, "%s , %s", $1,$2);adicionaTermo(doc,$2);}
	   ;






%%

#include "lex.yy.c"

int yyerror(char *s){
	printf("Erro sintatico %s\n",s);
	return 0;
}

Lista_Dados* initLista_Dados(){
	Lista_Dados* dados = malloc(sizeof(struct dados));
	dados->linguas = NULL;
	dados->baseLanguage = NULL;
	dados->inversos = NULL;
	return dados;
}

int adicionaBaseLang(Document* doc, char* base){
	Lista_Dados* dados = doc->dados;
	dados->baseLanguage = strdup(base);
	return 0;
}

int adicionaLingua(Document* doc, char* lingua){
	Lista_Dados* dados = doc->dados;
	if(dados->linguas == NULL){
		Lista_Linguas* nova = malloc(sizeof(struct linguas));
		nova->nome = strdup(lingua);
		nova->next = NULL;
		dados->linguas = nova;
		return 0;
	}else{
		Lista_Linguas* aux = dados->linguas;
		Lista_Linguas* ant;
		while(aux){
			if(strcmp(lingua,aux->nome)==0){
				return 1;
			}else{
				ant = aux;
				aux = aux->next;
			}
		}
		Lista_Linguas* nova = malloc(sizeof(struct linguas));
		nova->nome = strdup(lingua);
		nova->next = NULL;
		ant->next = nova;
	}
	return 0;
}

int adicionaInverso(Document* doc, char* primeiro, char* segundo){
	Lista_Dados* dados = doc->dados;
	if(dados->inversos == NULL){
		Lista_Inversos* nova = malloc(sizeof(struct inversos));
		nova->primeiro = strdup(primeiro);
		nova->segundo = strdup(segundo);
		nova->next = NULL;
		dados->inversos = nova;
		return 0;
	}else{
		Lista_Inversos* aux = dados->inversos;
		Lista_Inversos* ant;
		while(aux){
			if((strcmp(primeiro,aux->primeiro)==0) && (strcmp(segundo,aux->segundo)==0)){
				return 1;
			}else{
				ant = aux;
				aux = aux->next;
			}
		}
		Lista_Inversos* nova = malloc(sizeof(struct inversos));
		nova->primeiro = strdup(primeiro);
		nova->segundo = strdup(segundo);
		nova->next = NULL;
		ant->next = nova;
	}
	return 0;
}


int adicionaTermo(Document* doc, char* termo){
	if(doc->conceitos == NULL){
		Lista_Conceitos* novo_conceito = malloc(sizeof(struct conceitos));
		novo_conceito->titulo = NULL;
		novo_conceito->next = NULL;
		novo_conceito->relacoes = malloc(sizeof(struct relacoes));
		
		novo_conceito->relacoes->id = NULL;
		novo_conceito->relacoes->next = NULL;
		novo_conceito->relacoes->termos = malloc(sizeof(struct termos));
		
		novo_conceito->relacoes->termos->termo = strdup(termo);
		novo_conceito->relacoes->termos->next = NULL;
		doc->conceitos = novo_conceito;
		
		return 0;
	}else{
		Lista_Conceitos* aux = doc->conceitos;
		Lista_Conceitos* ant;
		while(aux){
			ant = aux;
			aux = aux->next;
		}

		if(ant->titulo == NULL){
			
			Lista_Relacoes* aux_relacoes = ant->relacoes;
			Lista_Relacoes* ant_relacoes;
			
			while(aux_relacoes){
				ant_relacoes = aux_relacoes;
				aux_relacoes = aux_relacoes->next;
			}
			
			if(ant_relacoes->id == NULL){
				Lista_Termos* lista = ant_relacoes->termos;
				Lista_Termos* ant_lista;
				while(lista){
					ant_lista = lista;
					lista = lista->next;
				}
				Lista_Termos* novo_termo = malloc(sizeof(struct termos));
				novo_termo->termo = strdup(termo);
				novo_termo->next=NULL;
				ant_lista->next = novo_termo;
				return 0;
			
			}else{
				Lista_Relacoes* nova_lista = malloc(sizeof(struct relacoes));
				nova_lista->id = NULL;
				nova_lista->termos = malloc(sizeof(struct termos));
				nova_lista->termos->termo = strdup(termo);
				nova_lista->termos->next = NULL;
				nova_lista->next = NULL;
				ant_relacoes->next = nova_lista;
				return 0;
			}

		}else{
			Lista_Conceitos* novo_conceito = malloc(sizeof(struct conceitos));
			novo_conceito->titulo = NULL;
			novo_conceito->next = NULL;
			novo_conceito->relacoes = malloc(sizeof(struct relacoes));
		
			novo_conceito->relacoes->id = NULL;
			novo_conceito->relacoes->next = NULL;
			novo_conceito->relacoes->termos = malloc(sizeof(struct termos));
		
			novo_conceito->relacoes->termos->termo = strdup(termo);
			novo_conceito->relacoes->termos->next = NULL;
			ant->next = novo_conceito;
			return 0;
		}
	}
	return 0;
}

int adicionaRelacao(Document* doc, char* id){
	if(doc->conceitos == NULL){
		return 1;
	}else{
		Lista_Conceitos* aux_ultimoConceito = doc->conceitos;
		Lista_Conceitos* ant_ultimoConceito;
		while(aux_ultimoConceito){
			ant_ultimoConceito = aux_ultimoConceito;
			aux_ultimoConceito = aux_ultimoConceito->next;
		}
		if(ant_ultimoConceito== NULL){
			return 1;
		}else{
			Lista_Relacoes* aux_ultimaRelacao = ant_ultimoConceito->relacoes;
			Lista_Relacoes* ant_ultimaRelacao;
			while(aux_ultimaRelacao){
				ant_ultimaRelacao = aux_ultimaRelacao;
				aux_ultimaRelacao = aux_ultimaRelacao->next;
			}
			if(ant_ultimaRelacao == NULL){
				return 1;
			}else{
				ant_ultimaRelacao->id = strdup(id);
				return 0;
			}
		}
	}
	return 0;
}

int adicionaConceito(Document* doc, char* titulo){
	if(doc->conceitos == NULL){
		return 1;
	}else{
		Lista_Conceitos* aux_ultimoConceito = doc->conceitos;
		Lista_Conceitos* ant_ultimoConceito;
		while(aux_ultimoConceito){
			ant_ultimoConceito = aux_ultimoConceito;
			aux_ultimoConceito = aux_ultimoConceito->next;
		}
		if(ant_ultimoConceito== NULL){
			return 1;
		}else{
			ant_ultimoConceito->titulo = strdup(titulo);
			int d = mergeRelacoes(ant_ultimoConceito->relacoes);
			return d;
		}
	}
	return 0;
}

int mergeRelacoes(Lista_Relacoes* relacoes){
	Lista_Relacoes* aux = relacoes->next;
	Lista_Relacoes* ant = relacoes;
	while(aux){
		if(strcmp(aux->id, ant->id)==0){
			Lista_Termos* aux_termos = ant->termos;
			Lista_Termos* ant_termos;
			while(aux_termos){
				ant_termos = aux_termos;
				aux_termos = aux_termos->next;
			}
			ant_termos->next = aux->termos;
			ant->next = aux->next;
			aux = aux->next;
		}else{
			ant = aux;
			aux = aux->next;
		}
	}
	return 0;
}

Document* initDoc(){
	Document* doc = malloc(sizeof(struct doc));
	doc->dados = initLista_Dados();
	doc->conceitos = NULL;
	return doc;
}

void imprimeDoc(Document* doc){
	int fd_conceito;
	int fd = open("tp3.html",O_CREAT|O_RDONLY|O_WRONLY,0666);
	write(fd,"<html>\n", strlen("<html>\n"));
	write(fd,"\t<body>\n", strlen("\t<body>\n"));
	write(fd,"\t\t<p> DADOS </p>\n", strlen("\t\t<p> DADOS </p>\n"));
	write(fd,"\t\t\t<ul>\n",strlen("\t\t\t<ul>\n"));
	Lista_Dados* dados = doc->dados;
	Lista_Conceitos* conceitos = doc->conceitos;
	
		Lista_Linguas* linguas = dados->linguas;
		write(fd,"\t\t\t\t<li> Linguas: ", strlen("\t\t\t\t<li> Linguas: "));
		while(linguas){
			write(fd,linguas->nome,strlen(linguas->nome));
			if(linguas->next!=NULL){
				write(fd," , ", strlen(" , "));
			}
			linguas = linguas->next;
		}
		write(fd,"</li>\n", strlen("</li>\n"));
		write(fd,"\t\t\t\t<li> Lingua Base: ",strlen("\t\t\t\t<li> Lingua Base: "));
		write(fd,dados->baseLanguage,strlen(dados->baseLanguage));
		write(fd,"</li>\n",strlen("</li>\n"));
		Lista_Inversos* inversos = dados->inversos;
		while(inversos){
			write(fd,"\t\t\t\t<li> Inverso: ",strlen("\t\t\t\t<li> Inverso: "));
			write(fd,inversos->primeiro,strlen(inversos->primeiro));
			write(fd," -> ", strlen(" -> "));
			write(fd,inversos->segundo,strlen(inversos->segundo));
			write(fd,"</li>\n", strlen("</li>\n"));
			inversos= inversos->next;
		}
	write(fd,"\t\t\t</ul>\n",strlen("\t\t\t</ul>\n"));
	write(fd,"\t\t<p> CONCEITOS </p>\n", strlen("\t\t<p> CONCEITOS </p>\n"));
	
	while(conceitos){
		char* nome = strdup(conceitos->titulo);
		char* file = strcat(nome,".html");
		fd_conceito = open(file,O_CREAT|O_RDONLY|O_WRONLY,0666);
		write(fd_conceito,"<html>\n", strlen("<html>\n"));
		write(fd_conceito,"\t<body>\n", strlen("\t<body>\n"));
		write(fd,"\t\t\t<a href=\"", strlen("\t\t\t<a href=\""));
		write(fd,file,strlen(file));
		write(fd, "\">", strlen("\">"));
		write(fd,conceitos->titulo,strlen(conceitos->titulo));
		write(fd,"</a><br>\n",strlen("</a><br>\n"));

		write(fd_conceito,"\t\t<p> ", strlen("\t\t<p> "));
		write(fd_conceito,conceitos->titulo,strlen(conceitos->titulo));
		write(fd_conceito," </p>\n",strlen(" </p>\n"));
		write(fd_conceito,"\t\t\t<ul>\n",strlen("\t\t\t<ul>\n"));

		Lista_Relacoes* relacoes = conceitos->relacoes;
		while(relacoes){

			write(fd_conceito,"\t\t\t\t<li> ",strlen("\t\t\t\t<li> "));
			write(fd_conceito,relacoes->id,strlen(relacoes->id));
			write(fd_conceito,": ",strlen(": "));
			Lista_Termos* termos = relacoes->termos;
			while(termos){
				write(fd_conceito,termos->termo, strlen(termos->termo));
				if(termos->next!=NULL){
					write(fd_conceito," , ",strlen(" , "));
				}
				termos = termos->next;
			}
			write(fd_conceito,"</li>\n", strlen("</li>\n"));
			relacoes = relacoes->next;
		}
		
		write(fd_conceito,"\t\t\t</ul>\n",strlen("\t\t\t</ul>\n"));
		write(fd_conceito,"\t</body>\n", strlen("\t</body>\n"));
		write(fd_conceito,"</html>", strlen("</html>"));
		close(fd_conceito);
		conceitos = conceitos->next;
	}

	
	write(fd,"\t</body>\n", strlen("\t</body>\n"));
	write(fd,"</html>", strlen("</html>"));
	close(fd);
}

int main(){
	doc = initDoc();
	printf("INICEI A ESTRUTURA\n");
	yyparse();
	printf("FIM DO PROCESSAMENTO\n");
	imprimeDoc(doc);
	
	return 0;
}

