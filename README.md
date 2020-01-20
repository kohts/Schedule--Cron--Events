# NAME

Schedule::Cron::Events - Schedule::Cron::Events - take a line from a crontab and find out when events will occur

# VERSION

version 1.96

# SYNOPSIS

```perl
use Schedule::Cron::Events;
my @mon = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

# a crontab line which triggers an event every 5 minutes
# initialize the counter with the current time
my $cron1 = new Schedule::Cron::Events( '*/5 * * * * /bin/foo', Seconds => time() );

# or initialize it with a date, for example 09:51:13 on 21st June, 2002
my $cron2 = new Schedule::Cron::Events( '*/5 * * * * /bin/foo', Date => [ 13, 51, 9, 21, 5, 102 ] );

# you could say this too, to use the current time:
my $cron = new Schedule::Cron::Events( '*/5 * * * * /bin/foo',  Date => [ ( localtime(time()) )[0..5] ] );

# find the next execution time
my ($sec, $min, $hour, $day, $month, $year) = $cron->nextEvent;
printf("Event will start next at %2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));

# find the following occurrence of the job
($sec, $min, $hour, $day, $month, $year) = $cron->nextEvent;
printf("Following event will start at %2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));

# reset the counter back to the original date given to new()
$cron->resetCounter;

# find out when the job would have last run
($sec, $min, $hour, $day, $month, $year) = $cron->previousEvent;
printf("Last event started at %2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));

# see when the job would have next run at a point in time
$cron->setCounterToDate(0, 18, 1, 26, 9, 85); # that's 26th October, 1985
($sec, $min, $hour, $day, $month, $year) = $cron->nextEvent;
printf("Event did start at %2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));

# turn a local date into a Unix time
use Time::Local;
my $epochSecs = timelocal($sec, $min, $hour, $day, $month, $year);
print "...or that can be expressed as " . $epochSecs . " seconds which is " . localtime($epochSecs) . "\n";
```

Here is a sample of the output produced by that code:

```
# Event will start next at  0:45:00 on 28 Aug, 2002
# Following event will start at  0:50:00 on 28 Aug, 2002
# Last event started at  0:40:00 on 28 Aug, 2002
# Event did start at  1:20:00 on 26 Oct, 1985
# ...or that can be expressed as 499134000 seconds which is Sat Oct 26 01:20:00 1985
```

Note that results will vary according to your local time and timezone.

# DESCRIPTION

Given a line from a crontab, tells you the time at which cron will next run the line, or when the last event
occurred, relative to any date you choose. The object keeps that reference date internally, 
and updates it when you call nextEvent() or previousEvent() - such that successive calls will
give you a sequence of events going forward, or backwards, in time.

Use setCounterToNow() to reset this reference time to the current date on your system,
or use setCounterToDate() to set the reference to any arbitrary time, or resetCounter()
to take the object back to the date you constructed it with.

This module uses Set::Crontab to understand the date specification, so we should be able to handle all
forms of cron entries.

# NAME

Schedule::Cron::Events - take a line from a crontab and find out when events will occur

# METHODS

In the following, DATE\_LIST is a list of 6 values suitable for passing to Time::Local::timelocal()
which are the same as the first 6 values returned by the builtin localtime(), namely 
these 6 numbers in this order

- seconds

    a number 0 .. 59

- minutes

    a number 0 .. 59

- hours

    a number 0 .. 23

- dayOfMonth

    a number 0 .. 31

- month

    a number 0 .. 11 - January is \*0\*, December is \*11\*

- year

    the desired year number \*minus 1900\*

- new( CRONTAB\_ENTRY, Seconds => REFERENCE\_TIME, Date => \[ DATE\_LIST \] )

    Returns a new object for the specified line from the crontab. The first 5 fields of the line
    are actually parsed by Set::Crontab, which should be able to handle the original crontab(5) ranges
    as well as Vixie cron ranges and the like. It's up to you to supply a valid line - if you supply
    a comment line, an environment variable setting line, or a line which does not seem to begin with
    5 fields (e.g. a blank line), this method returns undef.

    Give either the Seconds option or the Date option, not both.
    Supply a six-element array (as described above) to specify the date at which you want to start.
    Alternatively, the reference time is the number of seconds since the epoch for the time you want to 
    start looking from.

    If neither of the 'Seconds' and 'Date' options are given we use the current time().

- resetCounter()

    Resets the object to the state when created (specifically resetting the internal counter to the 
    initial date provided)

- nextEvent()

    Returns a DATE\_LIST for the next event following the current reference time.
    Updates the reference time to the time of the event.

- previousEvent()

    Returns a DATE\_LIST for the last event preceding the current reference time.
    Updates the reference time to the time of the event.

- setCounterToNow()

    Sets the reference time to the current time.

- setCounterToDate( DATE\_LIST )

    Sets the reference time to the time given, specified in seconds since the epoch.

- commandLine()

    Returns the string that is the command to be executed as specified in the crontab - i.e. without the leading
    date specification.

# ERROR HANDLING

If something goes wrong the general approach is to raise a fatal error with confess() so use
eval {} to trap these errors. If you supply a comment line to the constructor then you'll simply get back
undef, not a fatal error. If you supply a line like 'foo bar \*/15 baz qux /bin/false' you'll get a confess().

# DEPENDENCIES

Set::Crontab, Time::Local, Carp. Date::Manip is no longer required thanks to B Paulsen.

# MAINTENANCE

Since January 2012 maintained by Petya Kohts (petya.kohts at gmail.com)

# COPYRIGHT

Copyright 2002 P Kent

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself. 

# AUTHOR

Petya Kent <pause@selsyn.co.uk>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2002 by Petya Kent.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
