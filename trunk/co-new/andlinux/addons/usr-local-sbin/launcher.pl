#!/usr/bin/perl

use IO::Socket;
use Encode;
use strict;

# default settings
our $localPort = 2081;
our %pathPrefixes = ( "/mnt/win/" => "C:\\" );

# $wincharset must be configured depending on your environment.
# To see all available charsets, run:
# perl -e 'use Encode; @list=Encode->encodings(":all"); print "@list\n";'
our $wincharset = "";

# load config, if any
my $conf = "/etc/andlinux/launcher-conf.pl";
require $conf if -f $conf;


my $sock = new IO::Socket::INET(LocalPort => $localPort, Reuse => 1, Listen => 20) or die("Error creating local socket: $@\n");

while(my $client = $sock->accept())
{
	my $request = <$client>;
	chomp $request;

	if ($wincharset ne "")
	{
		$request = decode($wincharset, $request);
	}
	
	if($request =~ m/^cmd=(.+)&file=(.*)$/)
	{
		my $cmd = $1;
		my $file = $2;

		# apply all mappings
		foreach my $linuxPathPrefix ( keys %pathPrefixes ) {
		    my $windowsPathPrefix = $pathPrefixes{$linuxPathPrefix};
		    $windowsPathPrefix =~ s/\\/\\\\/g;
		    $file =~ s/$windowsPathPrefix/$linuxPathPrefix/gi;
		}

		# finalize with back-slashes replacement
		$file =~ s/\\/\//g;

		system("$cmd $file &");

		print $client "ok\n";
	}
	else
	{
		print $client "failed: parse error\n";
	}
	
	$client->close();
}
