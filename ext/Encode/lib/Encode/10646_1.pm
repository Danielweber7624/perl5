package Encode::10646_1;
use strict;
our $VERSION = do { my @r = (q$Revision: 1.20 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r };

use base 'Encode::Encoding';
# Encoding is 16-bit network order Unicode (no surogates)
# Used for X font encodings

__PACKAGE__->Define(qw(UCS-2BE UCS-2));

sub decode
{
    my ($obj,$str,$chk) = @_;
    my $uni   = '';
    while (length($str))
    {
	my $code = unpack('n',substr($str,0,2,'')) & 0xffff;
	$uni .= chr($code);
    }
    $_[1] = $str if $chk;
    utf8::upgrade($uni);
    return $uni;
}

sub encode
{
    my ($obj,$uni,$chk) = @_;
    my $str   = '';
    while (length($uni))
    {
	my $ch = substr($uni,0,1,'');
	my $x  = ord($ch);
	unless ($x <= 0xffff)
	{
	    last if ($chk);
	    $x = 0;
	}
	$str .= pack('n',$x);
    }
    $_[1] = $uni if $chk;
    return $str;
}
1;
__END__

=head1 NAME

Encode::10656_1 -- for internal use only

=cut
