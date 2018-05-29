title: CDH upgrade alternatives link not updated
categories: [CDH,Error]
date: 2018-05-23 09:57:34
---
# CDH upgrade alternatives link not updated 
There seems to be issues around update-alternatives command. 
Which is often caused by a broken alternatives link under /etc/alternatives/ or a bad (zero length,see [0]) alternatives configuration file under /var/lib/alternatives,and based on your description it appears to be the former. 
The root cause is that Cloudera Manager Agents relies in the OS provided binary of update-alternatives,
however the binary doesn't relay feedback on bad entries or problems,
therefore we have to resort to manually rectifying issues like these. 
We have an internal improvement JIRA OPSAPS-39415 to explore options on how to make alternatives updates during upgrades more resilient. 
To recover from the issue,
you would need to remove CDH related entries from alternatives configuration files. 

[0] https://bugzilla.redhat.com/show_bug.cgi?id=1016725 
= = = = = = = 
1. Stop CM agent service on node service cloudera-scm-agent stop 
    `service cloudera-scm-agent stop `
2. Delete hadoop /etc/alternatives - below will displays the rm command you'll need to issue. 
    `ls -l /etc/alternatives/ | grep "\/opt\/cloudera" | awk {'print $9'} | while read m; do if [[ -e /var/lib/alternatives/${m} ]]; then echo "rm -fv /var/lib/alternatives/${m}"; fi; echo "rm -fv /etc/alternatives/${m}"; done `
3. Remove 0 byte /var/lib/alternatives 
```
cd /var/lib/alternatives 
find . -size 0 | awk '{print $1 " "}' | tr -d '\n' 
```
4. The above command will give you a multi-line output of all 0 byte files in /var/lib/alternatives. Copy all the files,and put into the rm -f rm -f 
5. Start CM agent service cloudera-scm-agent start 
`service cloudera-scm-agent start`
= = = = = = =


