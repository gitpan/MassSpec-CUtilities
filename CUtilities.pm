package MassSpec::CUtilities;

use 5.008;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use MassSpec::CUtilities ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&MassSpec::CUtilities::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('MassSpec::CUtilities', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

MassSpec::CUtilities - Perl extension containing C utilities for use in mass spectrometry

=head1 SYNOPSIS

  # MassSpec::CUtilities is an XS module so there's a chance that you or
  # your target user might not get it to install cleanly on the target system;
  # therefore it's recommended to make its presence optional and to offer
  # slower-performing Perl equivalents where practical.
  # 
  # Also note that this module uses a 19-letter amino alphabet rather than
  # the traditional 20-letter alphabet, since the isobars Leucine(L) and
  # Isoleucine(I) are represented instead by "X."  Furthermore some portions
  # of this module assume that their input peptides are internally in
  # alphabetical order.
  my $haveCUtilities;
  if (eval 'require MassSpec::CUtilities') {
          import MassSpec::CUtilities;
          $haveCUtilities = 1;
  } else {
          $haveCUtilities = 0;
  }
  if ($haveCUtilities) {
          my $candidate = MassSpec::CUtilities::encodeAsBitString("ACCGT");
          my @shortPeptides = ("ACT","CCGM","ACCGTY","CCT");
          my (@list,@answer);
          foreach $_ (@shortPeptides) {
                  push @list, MassSpec::CUtilities::encodeAsBitString($_);
          }
          if (MassSpec::CUtilities::testManyBitStrings($candidate,\@shortPeptides,\@list,\@answer)) {
                  # should print "ACT" and "CCT" only
                  print "Matched: " . join(',',@answer) . "\n";
          }
   }
   # see API documentation for other available subroutines


=head1 ABSTRACT

  An eclectic mix of C utilities originally used in a mass spectrometry
  denovo sequencing project at NIH.  It includes a fast Huffman decoder
  suitable (with minor modifications) for use with the CPAN module
  Algorithm::Huffman, as well as a fast peptide mass calculator and methods for   encoding peptides as products of prime numbers or as bitmaps.

=head1 DESCRIPTION

Stub documentation for MassSpec::CUtilities, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Jonathan Epstein, E<lt>Jonathan_Epstein@nih.govE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by Jonathan Epstein

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
