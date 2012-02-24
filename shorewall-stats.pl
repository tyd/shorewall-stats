#!/usr/bin/perl
##############################################################
#
#   Shorewall Accounting Statistics for MRTG
#   https://github.com/tyd/shorewall-stats
#
#   This script is under the GPL (GENERAL PUBLIC LICENSE)
#   http://www.gnu.org/copyleft/gpl.html
#
#   2004-04-18 - Initial release
#   2005-12-01 - Changed to byte output ("show -x")
#   2012-02-24 - Added --reverse option
#
#############################################################
# CONFIGURATION
#############################################################
# path to shorewall binary
$shorewall = "/sbin/shorewall";
# path to uptime binary
$uptime    = "/usr/bin/uptime";
# path to hostname or simply enter hostname
$hostname  = "/bin/hostname";
#############################################################
# END OF CONFIGURATION
#############################################################
$reverse = false;	

# see if any counters were defined
if ( !@ARGV ) {
print "\nShorewall Accounting Statistics for MRTG\n";
print "Version v0.0.2\n";
print "https://github.com/tyd/shorewall-stats/\n\n";
print "This script is under the GPL (GENERAL PUBLIC LICENSE)\n";
print "http://www.gnu.org/copyleft/gpl.html\n\n";
print "Usage: shorewall-stats.pl <counter> <options>\n\n";
print "Options:\n";
print "\t--reverse : Reverse in/out output\n\n";
exit;
}

# Look for options
foreach ( @ARGV ) {
  if ( $_ eq '--reverse' ) {
    $reverse = true;
  }
}

# get counter and hostname
$show = $ARGV[0];
$host = `$hostname`;

# get in/out statistics
$in = `$shorewall show -x $show | head -n 7 | tail -1 | awk '{ print \$2 }'`;
$out = `$shorewall show -x $show | head -n 8 | tail -1 | awk '{ print \$2 }'`;

# UPTIME
$uptime = `$uptime`;
$uptime =~ /up (.*?,.*?),/;
$up = $1;

# Option to reverse in/out
if ( $reverse eq true )
{
    ($in,$out) = ($out,$in);
}

# Print out data in an mrtg friendly way
print trim($in)."\n";
print trim($out)."\n";
print "$up\n";
print "$host";
# END

## Trim function
sub trim {
   my $string = shift;
   $string =~ s/^\s+|\s+$//g;
   return $string;
}