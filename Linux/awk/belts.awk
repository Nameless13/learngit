#!/bin/awk -f
# name: belts.awk
# to call: belts.awk grade2.txt
# loops through the grade2.txt file and counts how many
# belts we have in (yellow,orange,red)
# also count how many adults and juniors wu have
#
# start of BEGIN
# set FS and load the arrays with our values
BEGIN{FS="#"
# load the belt colours we are interested in only
belt["Yellow"]
belt["Orange"]
belt["Red"]
# end of BEGIN
# load the student type
student["Junior"]
student["Senior"]
}
# loop thru array that holds the belt colours against field-1
# if we have a match,keep a running total
  {for (colour in belt)
	{if ($1==colour)
	belt[colour]++}}
# loop thru array that holds the student type against
# field-2 if we have match,keep a running total
  {for (senior_or_junior in student)
	{if ($2==senior_or_junior)
	student[senior_or_junior]++}}
# finished processing so print out the matches..for each array
END {for (colour in belt)print "The club has",belt[colour],colour,"Belts"
for (senior_or_junior in student) print "The club has",student[senior_or_junior]\
,senior_or_junior,"students"}
