		
#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Usage: $FUNCNAME hdfs_path,the number of the parameters must be one"
  exit 1
fi

hdfs_path="$1"

hadoop fs -test -s ${hdfs_path}/*

if [ $? -eq 0 ] ;then 
    echo "Found data files in ${hdfs_path}" 
    echo `hadoop fs -ls ${hdfs_path} | head -1`  
else  
    echo "Error! No data files in ${hdfs_path}" 
	exit 1
fi 


#-bash-3.2$ hadoop fs -help  
#-test -[defsz] <path>:    Answer various questions about <path>, with result via exit status.  
#          -d  return 0 if <path> is a directory.  
#          -e  return 0 if <path> exists.  
#          -f  return 0 if <path> is a file.  
#          -s  return 0 if file <path> is greater than zero bytes in size.  
#          -z  return 0 if file <path> is zero bytes in size.  
#        else, return 1.  