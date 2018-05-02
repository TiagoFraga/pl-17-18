%{
#include <stdlib.h>
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
		
		if(strcmp(lista->principal,principal)==0){
			
			Array* array = lista->filho;
			if(array==NULL){
				Array* novo = newSecundaryTag(nome);
				lista->filho = novo;

				return 0;
			}else{

				Array* ant;
				while(array){
					if(strcmp(array->tag, nome)==0){
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


		lista = lista->next;
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
			if(strcmp(lista->principal,principal)==0){
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

int imprimeLista(Document* doc){
	int fd = open("graph.dot",O_CREAT|O_WRONLY,0666);
	write(fd,"digraph tp2{",strlen("digraph tp2{"));
	write(fd,"\n",1);
	Lista* lista = doc->tag_principal;
	while(lista){
		Array* array = lista->filho;
		while(array){
			write(fd,lista->principal,strlen(lista->principal));
			write(fd,"->",strlen("->"));
			write(fd,array->tag,strlen(array->tag));
			write(fd,"\n",1);
			array = array->next;
		}
		lista = lista->next;
	}
	write(fd,"}",1);
	close(fd);
	return 0;
}


Document* doc;
char* hierarquia[20];
int nivel;
char* tag;



%}

%x TAG FECHO_TAG TAG_QUANDO


%%

<INITIAL>{
[a-zA-Z0-9]+									{;}
\<[?].*[?]\>									{;}
\<[!].*\>										{;}
\<quando.*\/									{BEGIN TAG_QUANDO;}
\<obs\/\>										{;}
\<												{BEGIN TAG;}
\<\/											{BEGIN FECHO_TAG;}
}
<TAG>{
[a-zA-Z0-9]+									{tag = strdup(yytext);}
[a-zA-Z0-9]+?[_][a-zA-Z0-9]+					{tag = strdup(yytext);}
[ ].*[=].*\> 									{	
													printf("TAG_ATRIBUICAO: -> %s\n",tag );
													hierarquia[nivel] = strdup(tag);
													nivel++;
													adicionaPrincipalNode(doc,tag);
													BEGIN INITIAL;
												}
\>												{
													if(strcmp(tag,"obs")==0 || strcmp(tag,"pai")==0 || strcmp(tag,"mae")==0  ){
														BEGIN INITIAL;
													}else{
														printf("TAG_C_FILHO: -> %s\n",tag );
														hierarquia[nivel] = strdup(tag);
														nivel++;
														adicionaPrincipalNode(doc,tag);
														BEGIN INITIAL;
													}
												}
\>.*\<\/.*\>									{
													printf("TAG_S_FILHO: -> %s\n",tag );
													adicionaSecudaryNode(doc,hierarquia[nivel-1],tag);
													BEGIN INITIAL;
												}
}
<FECHO_TAG>{
[a-zA-Z0-9]+									{tag = strdup(yytext);}
[a-zA-Z0-9]+?[_][a-zA-Z0-9]+					{tag = strdup(yytext);}	
\>												{
													if(strcmp(tag,"obs")==0){
														BEGIN INITIAL;
													}else{
														printf("FECHO_TAG: -> %s\n", tag);
														nivel--;
														free(hierarquia[nivel]);
														if(nivel!=0){
															adicionaSecudaryNode(doc,hierarquia[nivel-1],tag);
														}
														BEGIN INITIAL;
													}
												}
}
<TAG_QUANDO>{
\>												{
													printf("TAG_QUANDO: -> quando\n");
													adicionaSecudaryNode(doc,hierarquia[nivel-1],"quando");
													BEGIN INITIAL;	
												}	
}
.|\n											{;}


%%

int yywrap(){
	return 1;
}

int main(){
	doc = initDoc();
	tag = NULL;
	int i;
	for(i=0;i<20;i++){
		hierarquia[i] = NULL;
	}
	nivel=0;
	yylex();
	imprimeLista(doc);
	return 0;
}