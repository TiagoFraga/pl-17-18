BEGIN 		{ FS = ":"; RS = "\n";IGNORECASE = 1;}
$1~/%dom/ 	{ dominios[$2]++;}
$1~/%THE/	{
				for(i=2; i<NF+1;i++){
					
					if($i~/ ./ || $i~/.* /){
						split($i,tmp," ");
						if(tmp[1]~/</){
							split(tmp[1],aux,"<");
							relacoes[aux[1]]++;
						} 
						else if(tmp[1]~/@/){
							split(tmp[1],aux,"@");
							relacoes[aux[2]]++;
						}
						else{
							relacoes[tmp[1]]++;
						}
					}
					else if($i!=""){
						if($i~/</){
							split($i,tmp,"<");
							relacoes[tmp[1]]++;
						}
						else if($i~/@/){
							split($i,tmp,"@");
							relacoes[tmp[2]]++;
						}
						else{ 
							relacoes[$i]++;
						}
					}
				}
			}
END			{ print "Dominios: "; for(j in dominios){ print(k "->" j " -> nº de Ocorrências: " dominios[j]);k++}; 
			  print "Relações: "; for(i in relacoes){ print(l"->" i " -> nº de Ocorrências: " relacoes[i]);l++};
			}

