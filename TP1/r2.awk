BEGIN 		  			{ FS = ":"; RS = "\n"; IGNORECASE = 1}
$1~/%inv/	  		  	{ inversos[$2] = $3;}
$1~/^%THE/ && NF == 2 	{ relacao =$2;}  	        	
NF == 2		      		{ if(!($1~/%/) && !($1~/#/)){
	            			split($2,triplo,"|");
							for (t in triplo){
								if(relacao == "EN"){ print ("("$1", EN ,"triplo[t]")");}
								else {
									print("("$1","relacao","triplo[t]")");
									for (i in inversos){
										if (relacao == i){
											print ("("triplo[t]","inversos[i]","$1")");
										}
									}
								}
							}
			  			  }
			  			}
$1~/^%THE/ && NF > 2   { 	split($i,tmp,"<"); 
							campos[1]=tmp[2];
							relacoes[n++]=tmp[2];
							for(i=2;i<=NF;i++){
								if(match($i,/</)){
									split($i,args,/</);
									campos[i]=args[1];
									relacoes[n++]=campos[i];
								}
								else{ 
									campos[i]=$i; 
									relacoes[n++]=$i;
								}
							}
						}
NF > 2	                { if(!($1~/%/) && !($1~/#/)){
							for(i=2;i< (NF+1);i++){
								if($i == ""){
									i++;
								}
								else{
									print("("$1","relacoes[i]","$i")");
								}
							}
						  }
						}

