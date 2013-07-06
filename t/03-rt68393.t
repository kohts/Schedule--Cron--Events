#!/usr/bin/perl
#
# Unit test for https://rt.cpan.org/Ticket/Display.html?id=68393
#
# Handy calendar: http://www.timeanddate.com/calendar/?year=2011
#


use strict;
use warnings;

use lib './lib';
use Test;
use Test::Deep;

use Schedule::Cron::Events;

use Data::Dumper;
use DateTime; 

#              field          allowed values
#              -----          --------------
#              minute         0-59
#              hour           0-23
#              day of month   1-31
#              month          1-12 (or names, see below)
#              day of week    0-7 (0 or 7 is Sun, or use names)

# 14:00 on Monday or Thursday
my $crontime = "00 14 * * 1,4"; # 1,4

# 12:45, 23 of May, 2011
my $date1 = [ 10, 45, 12, 23, 4, 111 ];

my $obj_crontab = Schedule::Cron::Events->new( $crontime, Date => $date1 );

Test::plan(tests => 6);

cmp_deeply([$obj_crontab->nextEvent()], [0, 0, 14, 23, 4, 111], "23 of May, 2011");
cmp_deeply([$obj_crontab->nextEvent()], [0, 0, 14, 26, 4, 111], "26 of May, 2011");
cmp_deeply([$obj_crontab->nextEvent()], [0, 0, 14, 30, 4, 111], "30 of May, 2011");
cmp_deeply([$obj_crontab->nextEvent()], [0, 0, 14, 2, 5, 111],  "02 of June, 2011");
cmp_deeply([$obj_crontab->nextEvent()], [0, 0, 14, 6, 5, 111],  "06 of June, 2011");
cmp_deeply([$obj_crontab->nextEvent()], [0, 0, 14, 9, 5, 111],  "09 of June, 2011");
