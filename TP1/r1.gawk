BEGIN 		{ FS = ":"; RS = "\n";IGNORECASE = 1;i=1;k=1;l=1; }
$1~/%dom/ 	{ dominios[$2]++;}
$1~/%THE/	{ relacoes[$2]++;}
END			{ print "Dominios: "; for(j in dominios){ print(k "->" j " -> nº de Ocorrências: " dominios[j]);k++}; 
			  print "Relações: "; for(i in relacoes){ print(l"->" i " -> nº de Ocorrências: " relacoes[i]);l++};
			}

