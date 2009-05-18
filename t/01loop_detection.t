#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Devel::LoopDetection qw(am_looping);

########################################################################

ok(defined &am_looping, "am looping defined");

########################################################################

sub foo {
  bar() unless am_looping;
}

sub bar {
  foo();
}

# the following terminates safely
foo();

ok(1, "didn't get into an endless loop");

########################################################################

sub rod {
  return jane() unless am_looping;
  return 0;
}

sub jane {
  return freddy() unless am_looping;
  return 0;
}

sub freddy {
  return 1;
}

ok(rod(), "am looping instances are separate");

########################################################################