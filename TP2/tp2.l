%{
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

typedef struct array{
	char* tag;
	struct array* next;
}Array;

typedef struct lista{
	char* principal;
	struct array* filho;
	struct lista* next;
}Lista;

typedef struct doc {
	Lista* tag_principal;		
}Document;


Array* newSecundaryTag(char* nome){
	Array* nodo = malloc(sizeof(struct array));
	nodo->tag = strdup(nome);
	nodo->next = NULL;

	return nodo;
}


Lista* newPrincipalNode(char* nome){
	Lista* lista = malloc(sizeof(struct lista));
	lista->principal = strdup(nome);
	lista->filho = NULL;
	lista->next=NULL;

	return lista;
}

Document* initDoc(){
	Document* doc = malloc(sizeof(struct doc));
	doc->tag_principal = NULL;
	return doc;
}


int adicionaPrincipalNode(Document* doc,char* nome){
	Lista* lista = doc->tag_principal;
	if(lista == NULL){
		Lista* nova = newPrincipalNode(nome);
		doc->tag_principal = nova;
		return 0;
	}else{
		Lista* ant;
		while(lista){
			if(strcmp(lista->principal,nome)==0){
				return 1;
			}
			ant = lista;
			lista = lista->next;
		}
		Lista* nova = newPrincipalNode(nome);
		ant->next = nova;
		return 0;
	}
}


int adicionaSecudaryNode(Document* doc, char* principal, char* nome){
	Lista* lista = doc->tag_principal;
	while(lista){
		if(strcmp(lista->principal,principal)){
			Array* array = lista->filho;
			if(array==NULL){
				Array* novo = newSecundaryTag(nome);
				lista->filho = novo;
				return 0;
			}else{
				Array* ant;
				while(array){
					if(strcmp(array->tag, nome)){
						return 1;
					}
					ant = array;
					array = array->next;
				}
				Array* novo = newSecundaryTag(nome);
				ant->next = novo;
				return 0;
			}
		}
	}
	return 1;
}

int verificaPrincipal(Document* doc, char* nome){
	Lista* lista = doc->tag_principal;
	if(lista == NULL){
		return 1;
	}else{
		while(lista){
			if(strcmp(lista->principal, nome)==0){
				return 0;
			}
			lista = lista->next;
		}
	}
	return 1;
}

int verificaSecundario(Document* doc, char* principal, char* nome){
	Lista* lista = doc->tag_principal;
	if(lista == NULL){
		return 1;
	}else{
		while(lista){
			if(strcmp(lista->principal,principal)){
				Array* array = lista->filho;
				if(array==NULL){
					return 1;
				}else{
					while(array){
						if(strcmp(array->tag, nome)){
							return 0;
						}
						array = array->next;
					}
				}
			}
			lista = lista->next;
		}
	}
	return 1;
}


Document* doc;



%}




%%

\<.*?[!=?].*\>		{;}
\<.*\>				{
						printf("PUTAS:%s\n",yytext);
					}

.|\n 				{}






%%

int yywrap(){
	return 1;
}

int main(){
	doc = initDoc();
	yylex();
	return 0;
}