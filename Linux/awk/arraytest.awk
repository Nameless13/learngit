#! /bin/awk -f
# name:arraytest.awk
# prints out an array
BEGIN{
record="123#456#789";
split(record,myarray,"#")}
  END { for (i in myarray) {print myarray[i]}}
