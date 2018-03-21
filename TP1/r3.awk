BEGIN 		{ FS = ":"; RS = "\n";IGNORECASE=1; filename = "thesaurus.txt"; }

$1~/%inv/	{
				split($2,segundo," ");
				split($3,terceiro," ");
				inversos[segundo[1]] = terceiro[1];	
			}
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

$1!~/%/ &&  $1!~/#/ && $1!=""{	
								print($1)>filename;
	
								if(unico!="" && $1!=""){
									print("iof: "unico)> filename;
								}

								for(i=2; i<NF+1;i++){
							
									if($i~/|/){
										split($i,triplos,"|");
										for(t in triplos){
											print(relacoes[i]": "triplos[t])>filename;
										}
									}
									else if($i!=""){
										print(relacoes[i]": "$i)>filename;
									}
								}
								printf("\n")>filename;

								for(i=2;i<NF+1;i++){
									if($i!=""){
										for(inv in inversos){
											if(relacoes[i]==inv){
												if($i~/|/){
													split($i,tripletes,"|");
													for(t in triplos){
														print(tripletes[t])>filename;
														print(inversos[inv]": " $1)>filename;
														if(instancia[i]!=""){
															print("iof: "instancia[i])>filename;
														}
														printf("\n")>filename;
													}
												}
												else{
													print("PUTAS"$i)>filename;
													print(inversos[inv]": " $1)>filename;
													if(instancia[i]!=""){
														print("iof: "instancia[i])>filename;
													}
												}
											}
										}
									}
								}
							}



