BEGIN { IGNORECASE = 1; FS = ":" }
	  { if($1~/^%dom/ || $1~/^%THE/) print $1 " -> " $2 }
