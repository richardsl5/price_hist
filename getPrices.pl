#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use HTTP::Request;
use Number::Format;
use DBI;

#some global variables
my $dsn= "DBI:mysql:database=crypto;host=localhost"; 
my $baseURL = "https://api.coinmarketcap.com/v1/ticker/?limit=0";
my @ticker; 

#set the date
my @ta = localtime();
my $c_date = ($ta[5]+1900) . "-" . sprintf("%02d",($ta[4]+1)) . "-" . sprintf("%02d",$ta[3]);

#get the list of currencies we care about
#my $dbh = DBI->connect($dsn,"crypto","crypt0!M00n");
my $dbh = DBI->connect($dsn,"root","yell0wTail");
if (not defined $dbh) { die "Connect failed" };

$dbh->do("use crypto") or die "Use stmt failed $dbh->errstr()";

my $select_stmt = qq (SELECT ticker from currency);
my $sth = $dbh->prepare($select_stmt) or die "prepare failed: $dbh->errstr()";
$sth->execute() or die "execute of select failed: $dbh->errstr()";

while (my @ref = $sth->fetchrow_array()) {
	push @ticker, $ref[0];
};

# Get the data from the website
my $ua = LWP::UserAgent->new(
	ssl_opts=> { verify_hostname => 0},
	cookie_jar => {}
);

my $request = HTTP::Request->new("GET"=>$baseURL);	
my $response = $ua->request($request);
if (!$response->is_success()) { die "Get call failed" };
my $msg = $response->content;
my @json_obj=decode_json($msg);

# Now go through the tickers getting the price data for the ones we want
# and insert into the database
my $insert_stmt;  
my $idx = 0;
foreach my $target (@ticker) {
	$idx = 0;
	while (defined ($json_obj[0][$idx])) {
		if ($target eq $json_obj[0][$idx]->{"symbol"}) {
			last;
		};
		$idx++;
	};
	my $t_price = $json_obj[0][$idx]->{"price_usd"};
	my $t_rank = $json_obj[0][$idx]->{"rank"};

	$insert_stmt = qq(
		INSERT INTO price_history (
			ticker,
			price,
			caprank,
			p_date)
			VALUES (
			\"$target\",
			$t_price,
			$t_rank,
			NOW()));
	$dbh->do($insert_stmt) or die $dbh->errstr();

};

$dbh->disconnect();
