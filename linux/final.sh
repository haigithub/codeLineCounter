#!/bin/bash
echo "please input filename"
read file
echo "you input:" $file

if [ -e "filenames" ];
	then rm filenames
	touch filenames
	chmod 777 filenames
else
	touch filenames
	chmod 777 filenames
fi

if [ -e "detail_record" ];
	then rm detail_record
	touch detail_record
	chmod 777 detail_record
else
	touch detail_record
	chmod 777 detail_record
fi



if  [ -e $file ];
	then #echo $file "exist"
	if [ -d $file ];
		#then echo $file "is a dir"
		then echo "input file type you want calc: c cpp java s h"
		read file_type #judge extrem
		#file_type = ${file_type//,/}
		for element in $file_type
		do
			echo you input type $element
			find $file -name "*."$element >> filenames
		done
		cat filenames | while read row;
		do
			awk -f line_counter.awk $row >> detail_record
		done
		echo "the detail result have write2file detail_record"
	else
		#echo $file "is not a dir"
		awk -f line_counter.awk $file>> detail_record
		echo "the detail result have write2file detail_record"
	fi
else
	echo $file "not exist"
fi

awk -f line_sum.awk detail_record

:<<!EOF!
if ( [-e $file]  && [-f $file] );
then awk -f line_counter.awk $file
else
echo $file "isn't exist or isn't a file"
fi
!EOF!