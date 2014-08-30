#!/usr/bin/perl
 use strict;
 use warnings;
 use LWP::Simple;
 use utf8;
 use Encode;


 my $TIMEOUT = 10;
 my $user_agent = 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Firefox/31.0';
 
 
my $browser = LWP::UserAgent->new(
     agent => $user_agent,
	 timeout => $TIMEOUT,
);
	 
  my $resp = $browser->get("$ARGV[0]");
  
  my $regex = $resp->content();

  my @line = split ('\n', $regex);


 my $list = '';
 my $ch = '';
  for (my $i=0; $i<=@line-1; $i++) {
	$line[$i] =~ /(<script>var base_url.*)/i and $list = $1;
  $line[$i] =~ /(<option value=".*" selected>(.*)<\/option>)/i and $ch = $2;
  }


print $ch;

  ### base_url ###
  $list =~ /(var file_url=")(.*)(";var current_url)/i and my $base = $2;

  ### base_link ###
  $list =~ /(\[.*\])/ and my $link = $1;

  ### short link ###
  my @short = split (",",$link);



# 1 3 5 <$
my $name =''; # filename
for (my $i=0; $i<=@short-1; $i++) {
	$short[$i] =~ /(\d+.*)(_Y_)(.*)(_)(.*)(".*)/i and $name = join("\n",$name,$1);
}

# change to array *** array index 0 = "" (blank)
my @lastname = split ('\n', $name);


print "$ch\n";
my $size = scalar @lastname-1;
print "Image : $size\n";
for (my $i=1; $i<=@lastname-1; $i++) {

  print "$base$lastname[$i]\n";
  }





### check
if ($ARGV[1]) {
  ###
  } else {
 usage();
 }


#array size

  print "\nEnter any key to download...\n";
  my $wait = <STDIN>;
#my $size = scalar @lastname-1;
 for (my $i=1; $i<=@lastname-1; $i++) {
 	print "Downloading.. Image $i/$size\n";
  my $final = "$base$lastname[$i]";
  getstore("$final","$ARGV[1]/$lastname[$i]") or die "Can't download : $final\n";
  print " - Download Image $i/$size Complete..\n\n";
}

exit;

##################
sub usage {
    #if($^O =~ /Win/){system("cls");}else{system("clear");}
    my $file_name = (split m{/|\\} => $0) [-1];
  print "\n\n[+] Usage\n$file_name \"link\" \"path\"";
    exit();
   }