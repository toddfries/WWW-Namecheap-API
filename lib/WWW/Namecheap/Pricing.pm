package WWW::Namecheap::Pricing;

use 5.006;
use strict;
use warnings;
use Carp();

=head1 NAME

WWW::Namecheap::Pricing - Namecheap API user methods

=cut

our $VERSION = '0.06';

=head1 SYNOPSIS

Namecheap API user methods.

Perhaps a little code snippet.

    use WWW::Namecheap::Pricing;

    my $foo = WWW::Namecheap::Pricing->new(API => $api);
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
	class => $class,
    };

    return bless($self, $class);
}

=head2 $user->getpricing()

Returns a hashref containing information about the user's pricing.

See also: https://www.namecheap.com/support/api/methods/users/get-pricing.aspx

=cut

sub getpricing {
    my $self = shift;

    my $params = _argparse(@_);

    for (qw(ProductType ActionName)) {
	my $class = $self->{class};
        Carp::croak("${class}->getpricing(): Mandatory parameter $_ not provided.") unless $params->{$_};
    }

    my %request = (
        Command => 'namecheap.users.getPricing',
	ProductType => $params->{ProductType},
    );

    for (('ProductCategory', 'PromotionCode', 'ActionName', 'ProductName')) {
	$request{$_} = $params->{$_} if defined($params->{$_});
    }


    my $xml = $self->api->request(%request);

    return unless ($xml && $xml->{Status} eq 'OK');

    return $xml->{CommandResponse}->{UserGetPricingResult};
}

=head2 $user->api()

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

=head1 AUTHOR

Tim Wilde, C<< <twilde at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-namecheap-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Namecheap-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.



=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Namecheap::Pricing


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

1; # End of WWW::Namecheap::Pricing
