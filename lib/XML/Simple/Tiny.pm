package XML::Simple::Tiny;
use Exporter 'import';
@EXPORT_OK = qw( parsefile parsestring );
use strict;
use warnings;
our $TAGS  = 1;	#generate tag attribute
our $NAMES = 1;	#name a node by it's 'name' attribute

=head1 NAME

XML::Simple::Tiny - a tiny helper to read XML::Tiny output and transform it 
to something like XML::Simple, but without other dependencies.

=cut

our $VERSION = '0.02';
use XML::Tiny;

=head1 SYNOPSIS


    use XML::Simple::Tiny qw(parsestring);

    my $doc = parsestring( *DATA );

    $doc->{root}->{branch}->{second}->{leaf}->[0]->{flower};  # "false"
    $doc->{root}->{branch}->{second}->{leaf}->[0]->{content}; #"a dead leaf"
    $doc->{root}->{branch}->{first}->{name}; "first"
    $doc->{root}->{branch}->{first}->{tag}; "branch"
	__DATA__
    <?xml version="1.0" encoding="utf-8" ?>
    <root>
     <branch name="first"/>
     <branch name="second">
      <leaf flower="false">a dead leaf</leaf>
      <leaf flower="true">another leaf</leaf>
     </branch>
    </root>

=head1 SUBROUTINES/METHODS

=head2 parsefile

Read xml document from the given file name. 
For options, see XML::Tiny's parsefile documentation.

=cut

sub parsefile{
	my $doc = XML::Tiny::parsefile( @_ );
	my $new = traverse( $doc->[0] );
	return $new;
}

=head2 parsestring

Same as parsefile but take a string or an opened filehandle with the XML content

=cut

sub parsestring{
	if(fileno $_[0]){
		my $FH = shift;
		unshift @_, join '', <$FH>;
	}
	
	$_[0] = '_TINY_XML_STRING_' . $_[0];
	&parsefile;
}

=head2 traverse 

Take a document or sub-element in the XML::Tiny format, and an optional parent node.
It will return the document in the XML::Simple::Tiny format.

=cut

sub traverse{
	my ($obj, $node) = @_;
	$node = { } unless $node;
	
	if(ref $obj eq 'HASH'){
		if($obj->{type} eq 'e'){
			#prepare a tag element
			my $class = $obj->{name};
			#add attributs
			my %att = exists $obj->{attrib} ? %{$obj->{attrib}} : ( );
			my $elt = { ($TAGS ? (tag => $class) : () ), %att };
			#add childs
			foreach my $childobj( @{$obj->{content}} ){
				my $childelt = traverse( $childobj, $elt );
			}
			#add element in parent $node
			my $name = $obj->{attrib}->{name};
			if($NAMES and $name){
				if(exists($node->{ $class }->{ $name })){
					my $first = $node->{ $class }->{ $name };
					if(ref $first eq 'ARRAY'){
						push @$first, $elt;
					}
					else{
						$node->{ $class }->{ $name } = [ $first, $elt ];
					}
				}
				else{
					$node->{ $class }->{ $name } = $elt;
				}
			}
			else{
				if(exists($node->{ $class })){
					my $first = $node->{ $class };
					if(ref $first eq 'ARRAY'){
						push @$first, $elt;
					}
					else{
						$node->{ $class } = [ $first, $elt ];
					}
				}
				else{
					$node->{ $class } = $elt;
				}				
			}
		}
		elsif($obj->{type} eq 't'){
			#add element content
			$node->{content} = $obj->{content};
		}
	}
	elsif(ref $obj eq 'ARRAY'){
		die("traverse(ARRAY ref) is uncovered, please inform the author\n", 
					join ',', @{$obj} );
	}
	else{
		$node->{'content'} = $obj;
	}
	
	return $node;
}

=head1 AUTHOR

Nicolas Georges, C<< <xlat at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-XML-Simple-Tiny at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=XML-Simple-Tiny>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc XML::Simple::Tiny


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=XML-Simple-Tiny>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/XML-Simple-Tiny>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/XML-Simple-Tiny>

=item * Search CPAN

L<http://search.cpan.org/dist/XML-Simple-Tiny/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Nicolas Georges.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of XML::Simple::Tiny
