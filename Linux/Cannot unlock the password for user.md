# 'Cannot unlock the password for <user>!'

pam_tally --user= --reset

Example

pam_tally --user=cyberninja --reset
I hope this helps someone.

I found this post looking for an answer to this exact question. I had the same error but on a SLES 11 SP2 server. My co-worker reset my password and tried to unlock my account with the command passwd -u. One of my other co-workers said I needed clear account in PAM and gave me the command. Which I have posted above.

Update,

I now have a fix that keeps this from happening again. It seems that there are two PAM files that where in conflict. These files are; /etc/pam.d/login and /etc/pam.d/sshd. Both files have this line.

auth required pam_tally.so onerr=fail deny=3
You must commit out, this line from one of the files listed above. We commented the line out in the /etc/pam.d/sshd file.

After you do this you should never have this issue again.