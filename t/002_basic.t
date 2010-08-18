use strict;
use warnings;
use Test::More tests => 2;
BEGIN { use_ok('ZeroMQ::JSON') };

use ZeroMQ::JSON qw/:all/;

ok(ZMQ_REP, "constant was exported");



