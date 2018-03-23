BEGIN 		{ FS = ":"; RS = "\n";IGNORECASE=1; filename = "thesaurus.html"; print("<html>")>filename; print("\t<body>")>filename; }

$1~/%inv/	{
				split($2,segundo," ");
				while(segundo[1]~/ ./){
					split(segundo[1],segundo," ");
				}
				split($3,terceiro," ");
				while(terceiro[1]~/ ./){
					split(terceiro[1],terceiro," ");
				}
				inversos[segundo[1]] = terceiro[1];	
			}
$1~/%THE/	{ 
				if($1~/</){
					split($1,uni,"<");
					unico = uni[2];
				}

				for(i=2; i<NF+1;i++){
					
					if($i~/ ./ || $i~/.* /){
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
								auxfile = $1".html"; 
								print("<html>")>auxfile; 
								print("\t<body>")>auxfile; 
								
								print("<a href=\""$1".html\">"$1"</a><br>")>filename;

								if(unico!="" && $1!=""){
									print("<p>"$1"</p>")>auxfile;
									print("\t\t<ul>")>auxfile;
									print("<li>iof: "unico"</li>")>auxfile;
								}

								for(i=2; i<NF+1;i++){
							
									if($i~/|/){
										split($i,triplos,"|");
										for(t in triplos){
											print("<li>"relacoes[i]": "triplos[t]"</li>")>auxfile;
										}
									}
									else if($i!=""){
										print("<li>"relacoes[i]": "$i"</li>")>auxfile;
									}
								}

								print("\t\t</ul>")>auxfile;
								print("<p> INVERSOS </p>")>auxfile;
								print("<p></p>")>auxfile;

								for(i=2;i<NF+1;i++){
									if($i!=""){
											if(inversos[relacoes[i]]!=""){
												if($i~/|/){
													split($i,tripletes,"|");
													for(t in tripletes){
														print("<p>"tripletes[t]"</p>")>auxfile;
														print("\t\t<ul>")>auxfile;
														print("<li>"inversos[relacoes[i]]": " $1"</li>")>auxfile;
														if(instancia[i]!=""){
															print("<li>iof: "instancia[i]"</li>")>auxfile;
														}
														print("\t\t</ul>")>auxfile;
													}
												}
												else{
													print("<p>"$i"</p>")>auxfile;
													print("\t\t<ul>")>auxfile;
													print("<li>"inversos[relacoes[i]]": " $1"</li>")>auxfile;
													if(instancia[i]!=""){
														print("<li>iof: "instancia[i]"</li>")>auxfile;
													}
													print("\t\t</ul>")>auxfile;
												}
											}
										}
									}
								print("\t</body>")>auxfile;
								print("</html>")>auxfile;
							}
END	{print("\t</body>")>filename;print("</html>")>filename;}

							



