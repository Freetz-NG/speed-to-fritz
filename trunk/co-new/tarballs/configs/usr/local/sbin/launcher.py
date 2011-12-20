import subprocess,time,sys
sys.stderr=open('/dev/null','a')
sub=subprocess.Popen('/usr/local/sbin/launcher.pl',stdout=subprocess.PIPE,stderr=subprocess.PIPE)
time.sleep(1)
if sub.poll()==98:
	exit(1)
exit(0)
