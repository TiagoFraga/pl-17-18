%{
#include <stdio.h>


%}

%%
<INITIAL>{
\#							{BEGIN COMENTARIO;}
\%language					{BEGIN LANGUAGE;}
\baselang					{BEGIN BASE;}
\%inv						{BEGIN INV;} 
PT							{return PT;BEGIN PT;}
EN							{return EN;BEGIN EN;}
NT							{return NT;BEGIN NT;}
BT							{return BT;BEGIN BT;}
SN							{return SN;BEGIN SN;}
[a-z]+						{return TITULO;}
.|\n						{;} 
}
<COMENTARIO>{
\n							{BEGIN INITIAL;}
}
<LANGUAGE>{
PT							{return PT;}
EN							{return EN;}
\n 							{BEGIN INITIAL;}
}
<BASE>{
PT							{return PT;}
EN							{return EN;}
\n 							{BEGIN INITIAL;}
}						
<INV>{
BT							{return BT;}
NT							{return NT;}
\n 							{BEGIN INITIAL;}
}
<PT>{
[a-z]+ 						{return TRADUCAO;}
\n 							{BEGIN INITIAL;}
}
<EN>{
[a-z]+ 						{return TRADUCAO;}
\n 							{BEGIN INITIAL;}	
}
<NT>{
[a-zA-Z]+ 					{return FILHO;}
\n 							{BEGIN INITIAL;}
}
<BT>{
[a-zA-Z]+					{return PAI;}
\n 							{BEGIN INITIAL;}
}
<SN>{
.*							{return }
}
%%

int yywrap(){
	return 1;
}



