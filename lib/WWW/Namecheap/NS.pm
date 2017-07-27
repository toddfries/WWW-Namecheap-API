package WWW::Namecheap::NS;

use 5.006;
use strict;
use warnings;
use Carp();

=head1 NAME

WWW::Namecheap::NS - Namecheap API nameserver methods

=cut

our $VERSION = '0.06';

=head1 SYNOPSIS

Namecheap API nameserver methods.

Perhaps a little code snippet.

    use WWW::Namecheap::NS;

    my $foo = WWW::Namecheap::NS->new();
    ...

=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new {
    my $class = shift;

    my $params = _argparse(@_);

    for (qw(API)) {
        Carp::croak("${class}->new(): Mandatory parameter $_ not provided.") unless $params->{$_};
    }

    my $self = {
        api => $params->{'API'},
    };

    return bless($self, $class);
}

=head2 $ns->api()

Accessor for internal API object.

=cut

sub api {
    return $_[0]->{api};
}

sub _argparse {
    my $hashref;
    if (@_ % 2 == 0) {
        $hashref = { @_ }
    } elsif (ref($_[0]) eq 'HASH') {
        $hashref = \%{$_[0]};
    }
    return $hashref;
}

sub getInfo {
    my $self = shift;

    my $params = _argparse(@_);

    return unless $params->{Nameserver};

    my %request = (
        Command => 'namecheap.domains.ns.getInfo',
        ClientIp => $params->{'ClientIp'},
        UserName => $params->{'UserName'},
    );

    my ($sld, $tld) = split(/[.]/, $params->{Nameserver}, 2);
    $request{SLD} = $sld;
    $request{TLD} = $tld;

    my $xml = $self->api->request(%request);

    return unless $xml;

    return $xml->{CommandResponse}->{DomainNSGetListResult};
}

=head1 AUTHOR

Tim Wilde, C<< <twilde at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-namecheap-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Namecheap-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.



=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Namecheap::NS


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Namecheap-API>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Namecheap-API>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Namecheap-API>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Namecheap-API/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Tim Wilde.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of WWW::Namecheap::NS
