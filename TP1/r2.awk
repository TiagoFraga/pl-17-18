BEGIN 		{ FS = ":"; RS = "\n";IGNORECASE = 1;i=1;k=1;l=1; }


$1~/%THE/	{ 
				if($1~/</){
					split($1,uni,"<");
					unico = uni[2];
				}

				for(i=2; i<NF+1;i++){
					
					if($i~/ ./){
						split($i,tmp," ");
						if(tmp[1]~/</){
							split(tmp[1],aux,"<");
							relacoes[i] = aux[1];
							instancia[i] = aux[2];
						} 
						else if(tmp[1]~/@/){
							split(tmp[1],aux,"@");
							relacoes[i]= aux[2];
						}
						else{
							relacoes[i]=tmp[1];
						}
					}
					else if($i!=""){
						if($i~/</){
							split($i,tmp,"<");
							relacoes[i]=tmp[1];
							instancia[i]=tmp[2];
						}
						else if($i~/@/){
							split($i,tmp,"@");
							relacoes[i]=tmp[2]
						}
						else{ 
							relacoes[i]=$i;
						}
					}
				}
			}

$1!~/%/ &&  $1!~/#/ {	
						if(unico!="" && $1!=""){
							print("("$1",iof,"unico")");
						}

						for(i=2; i<NF+1;i++){
							if($i~/|/){
								split($i,triplos,"|");
								for(t in triplos){
									print("("$1","relacoes[i]","triplos[t]")");
									if(instancia[i] != ""){
										print("("triplos[t]",iof,"$1")");
									}
								}

							}
							else{
								if($i!=""){
									print("("$1","relacoes[i]","$i")");
								}
							}
						}
}

