package ZeroMQ::JSON;
use 5.008;
use strict;
use ZeroMQ ();
#use Params::Util '_INSTANCE';
use JSON::Any ();

our $VERSION = '0.01';

sub import {
  my $class = shift;
  ZeroMQ->export_to_level(1, $class, @_);
}

package # PAUSE indexer hiding
  ZeroMQ::Context;

sub json_socket {
  my $cxt = shift;
  return ZeroMQ::Socket::JSON->new($cxt, @_);
}

package ZeroMQ::Socket::JSON;

our @ISA = qw(ZeroMQ::Socket);

sub send {
  my $self = shift;
  my $msg = shift;
  my $msgobj;
#  if (_INSTANCE($msg, 'ZeroMQ::Message')) {
#    $msgobj = $msg;
#  }
#  else {
    $msgobj = ZeroMQ::Message->new(JSON::Any->objToJson($msg));
#  }
  return $self->SUPER::send($msgobj);
}

sub recv {
  my $self = shift;
  my $msgobj = $self->SUPER::recv();
  return ZeroMQ::Message->new(JSON::Any->jsonToObj($msgobj));
}

1;
__END__

=head1 NAME

ZeroMQ::JSON - A convenience wrapper around ZeroMQ using JSON serialization

=head1 SYNOPSIS

  use ZeroMQ::JSON qw/:all/;
  my $cxt = ZeroMQ::Context->new;

  my $sock = $cxt->json_socket(ZMQ_REQ);
  # Or: $sock = ZeroMQ::Socket::JSON->new($cxt, ZMQ_REQ);
  
  $sock->bind($addr);
  
  $sock->send(
    {arbitrary => 'data', structure => 'will_be_send_as_json'}
  );
  
  # elsewhere:
  my $structure = $sock->recv;
  # $structure was automatically deserialized from the JSON message

=head1 DESCRIPTION

C<ZeroMQ::JSON> is a convenience wrapper around the L<ZeroMQ> message
passing library. When using C<ZeroMQ>, you create message objects containing
abitrary data and pass send them via C<ZeroMQ::Socket>s. C<ZeroMQ::JSON> provides
the C<ZeroMQ::Socket::JSON> subclass that handles the serialization and
deserialization for you.

You can create a new C<ZeroMQ::Socket::JSON> just like you create a regular
C<ZeroMQ::Socket> via the C<new> constructor or using the C<json_socket(...)>
method of C<ZeroMQ::Context>.

The C<send()> and C<recv()> methods have been overridden to respectively
send or return a Perl data structure (that can be serialized as JSON)
instead of a C<ZeroMQ::Message> object that is normally used.

This makes it trivially easy to exchange data with programs written
in other languages that also use the 0MQ library for message passing.

=head2 EXPORTS

As an added convenience, loading C<ZeroMQ::JSON> exposes the same
exporting interface as C<ZeroMQ>.

=head1 CAVEATS

This is an early release. Proceed with caution, please report
(or better yet: fix) bugs you encounter.

=head1 SEE ALSO

L<ZeroMQ>

L<ZeroMQ::Context>, L<ZeroMQ::Socket>

L<http://zeromq.org>

L<JSON::Any>

=head1 AUTHOR

Steffen Mueller, E<lt>smueller@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

The ZeroMQ::JSON module is

Copyright (C) 2010 by Steffen Mueller

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
