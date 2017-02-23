#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: get_songs_curl.pl
#
#        USAGE: ./get_songs_curl.pl  
#
#  DESCRIPTION: a
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Ivan Chavero (ichavero@chavero.com.mx)
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 17/02/17 16:03:12
#     REVISION: ---
#
#===============================================================================

use strict;
use warnings;
use utf8;


# Este url se tiene que toma de firebug ya que google no deja acceder a este servicio sin
# la información de sesión
# Esta ofuscación (intencional o no) es la que hace difícil el scraping desde clientes fuera del navegador
# pero una vez identificado el URL es cuestión de hacer copy paste.
# Una versión mas robusta de este script puede usar WWW::Mechanize disponible en varios 
# lenguajes el cual realiza peticiones HTTP y mantiene el estado entre estas peticiones.

my $COMMAND = "curl 'https://www.google.com.mx/search?sclient=psy-ab&biw=1138&bih=473&noj=1&q=seis+pistos&oq=seis+pistos&gs_l=serp.3..0i71k1l5.0.0.1.309454.0.0.0.0.0.0.0.0..0.0....0...1c..64.serp..0.0.0.nsyRsBN9hbw' -H 'Host: www.google.com.mx' -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:50.0) Gecko/20100101 Firefox/50.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' > webinfo.txt";


my $out = `$COMMAND`;

my $TESTFILE="webinfo.txt";
my @lines;

# Como se había mencionado no es estríctamente necesario crear 
# una representación dentro del programa del HTML ya que con
# unas expresiones regulares es suficiente para realizar el
# parseo de lo que se busca.

open(WEBINFO, $TESTFILE);
while(my $line = <WEBINFO>){
    $line =~ s/<div class="_Mjf">/\n<div class="_Mjf">/g ;
    $line =~ s/<\/div><div class="_Ajf">/<\/div><div class="_Ajf">\n/g;
    my @dump_lines = split('\n', $line);
    push @lines, @dump_lines;
}
close(WEBINFO);

getSongs(@lines);


sub getSongs {
    my @mylines = @_;
    foreach my $l (@mylines) {
        if( $l =~ /_Mjf.*_Ajf/ ) { 
            $l =~ m/<div class="_Mjf"><div class="title">(.+)<\/div><div class="_Ajf">/gs;
            print "$1\n" if( $l !~ /getElementById/);
        }
    }
}

