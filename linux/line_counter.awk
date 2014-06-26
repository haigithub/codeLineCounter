BEGIN{
	comment_single = 0; 
	comment_multi = 0; 
	comment_multi_flag = 0;
	blank_line = 0; 
	effective_line = 0;

	multi_left = "\/\*";
	multi_rigth = "\*\/";
	multi_oneline = "/\/\*.*\*\//";
	single = "\/\/.*";
	blank = "^$"; 
}

{
	while( ($0 ~ multi_left) || ($0 ~ multi_rigth) || ($0 ~ single) || ($0 ~ blank) )
	{
		#if (  $0 ~ multi_oneline  )
		if (  /\/\*.*\*\// )
		{
#			print NR,"comment_multi_oneline",$0;
			comment_multi += 1;
			break;
		}

		#if (  $0 ~ multi_left  )#include #define
		if ( /\/\*.*/ )
		{
#			print NR,"comment_multi_left",$0;
			comment_multi_flag = 1;
			comment_multi += 1;
			break;
		}
		#if (  $0 ~ multi_rigth  )#comment_multi_rigth and single
		if ( /.*\*\//  )
		{
#			print NR,"comment_multi_rigth",$0;
			comment_multi_flag = 0;
			comment_multi += 1;
			break;
		}
		if (  comment_multi_flag == 1 )#comment_multi_left and this
		{	
#			print NR,"comment_multi",$0;
			comment_multi +=1;
			break;
		}
		if (  /\/\//  &&  !/\w.*\/\// )
		{
#			print NR,"comment_single",$0;
			comment_single += 1;
			break;
		}
		#if (   $0 ~ blank  )
		#if ( /^\s*$/ ) #failed
		if ( NF == 0 )
		{
#			print NR,"blank",$0;
			blank_line += 1;
			break;
		}
#		print NR,"default",$0;
		effective_line += 1;
		break;
	}
}
#END{print "filename",FILENAME,"line_sum:",NR,"effective_line",effective_line,"comment_multi_line:",comment_multi,"single_line:",comment_single,"blank_line:",blank_line}
END{print "file:",FILENAME,"line:",NR,"effective:",effective_line,"comment:",comment_multi + comment_single,"blank:",blank_line}