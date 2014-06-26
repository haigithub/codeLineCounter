BEGIN{
	linesum = 0; effective = 0; comment = 0; blank = 0;
}

{	
	linesum		+= $4;
	effective		+= $6;
	comment	+= $8;
	blank		+= $10;
}

END{	
	print "linesum:",linesum,"effective:",effective,"comment:",comment,"blank:",blank
}



