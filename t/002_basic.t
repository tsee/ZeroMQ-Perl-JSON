use strict;
use warnings;
use Test::More tests => 14;
BEGIN { use_ok('ZeroMQ::JSON') };

use ZeroMQ::JSON qw/:all/;

ok(ZMQ_REP, "constant was exported");


my $cxt = ZeroMQ::Context->new;
isa_ok($cxt, 'ZeroMQ::Context');
can_ok($cxt, 'socket');
can_ok($cxt, 'json_socket');

my $sock = ZeroMQ::Socket::JSON->new($cxt, ZMQ_UPSTREAM); # Receiver
isa_ok($sock, 'ZeroMQ::Socket::JSON');
$sock = $cxt->json_socket(ZMQ_UPSTREAM);
isa_ok($sock, 'ZeroMQ::Socket::JSON');
isa_ok($sock, 'ZeroMQ::Socket');

$sock->bind("inproc://myPrivateSocket");
pass();

my $client = $cxt->json_socket(ZMQ_DOWNSTREAM); # sender
$client->connect("inproc://myPrivateSocket");
pass("alive after connect");

my $structure = {some => 'data', structure => [qw/that is json friendly/]};
ok($client->send( $structure ));

my $msg = $sock->recv();
ok(defined $msg, "received defined msg");

is_deeply($msg, $structure);

