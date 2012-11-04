package Fortune::WWW::Postillion;

use 5.010;
use strict;
use warnings;
use WWW::Mechanize;
use HTML::Parser;

=head1 NAME

Fortune::WWW::Postillion - Get fortune cookies from http://www.der-postillion.com!

=head1 VERSION

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Fortune::WWW::Postillion gives you fortune cookies from the newsticker archive
of the webside C<http://www.der-postillion.com>. 

    use Fortune::WWW::Postillion;

    
    my $random_cookie = cookie();
    my $third_cookie  = cookie(3);

=head1 EXPORT


=cut

our @text;

sub start_handler
{
        return if(shift ne 'p');
        my ($class) = shift->{href};
        my $self = shift;
        my $text;
        $self->handler(text => sub{$text = shift; if ($text =~ m/\+\+\+ ([^+]+) \+\+\+/) { push(@text, $1)}},"dtext");
}

sub text_handler 
{

}

=head1 SUBROUTINES

=head2 cookie

Get a new fortune cookie. You can either request a random cookie or give a
number n and the module will try to return the nth element of the cookie
list. The number is used modulo the number of elements in the cookie jar. So
if you ask for the 5th cookie in a 4 element jar, you will get the first one.

@param int - number of element in news list

@return success - string
@return error   - exception

@throws die()

=cut

sub cookie
{
        my ($num_cookie) = @_;
        my $url = 'http://www.der-postillon.com/search/label/Newsticker';
        my $mech = WWW::Mechanize->new();
        my $content = $mech->get($url)->content;
        # Create parser object
        my $parser = HTML::Parser->new();
        $parser->handler(start => \&start_handler,"tagname,attr,self");
        
        $parser->parse($content);
        $parser->eof;
        if (not $num_cookie) {
                $num_cookie = int(rand(@text)) + 1;
        }
        
        return $text[($num_cookie-1) % int @text];
        
}

=head1 AUTHOR

Maik Hentsche, C<< <Caldrin at cpan dot org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-fortune-www-postillion at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Fortune-WWW-Postillion>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Fortune::WWW::Postillion


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Fortune-WWW-Postillion>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Fortune-WWW-Postillion>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Fortune-WWW-Postillion>

=item * Search CPAN

L<http://search.cpan.org/dist/Fortune-WWW-Postillion/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Maik Hentsche.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Fortune::WWW::Postillion
