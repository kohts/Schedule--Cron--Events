#!/usr/bin/perl
#
# https://rt.cpan.org/Ticket/Display.html?id=53899
#

use strict;
use warnings;

use lib './lib';
use Test::More;
use Test::Deep;

use Schedule::Cron::Events;
use Data::Dumper;

plan(tests => 1);

my $obj_crontab1 = Schedule::Cron::Events->new( " 2 * * * * whatever", Date => [ 10, 45, 12, 23, 4, 111 ] );
my $obj_crontab2 = Schedule::Cron::Events->new( "2 * * * * whatever", Date => [ 10, 45, 12, 23, 4, 111 ] );

cmp_deeply($obj_crontab1, $obj_crontab2, "leading space in crontab line");
