package Devel::LoopDetection;
use base qw(Exporter);

use strict;
use warnings;

use Carp qw(croak);
use Scope::Upper qw(localize SCOPE);

our @EXPORT_OK;

=head1 NAME

Devel::LoopDetection - simple protection against looping

=head1 SYNOPSIS

  use Babel::LoopProtection (am_looping);
  
  sub foo {
    bar() unless am_looping;
  }
  
  sub bar() {
    foo();
  }

  # the following terminates safely
  foo();

=head1 DESCRIPTION

This module allows you to simply detect when you're looping in your
code;  That is to say it allows you to detect when you reach the same
line again while still in dynamic scope of the previous time you reached
that given line.

This module provides a single function as an interface;  It can be
exported on request.

=over

=item am_looping

The first time this function is called within dynamic scope from a
given line it will return false (the empty list.)  Subsequent times it is
called from the same line within the same dynamic scope it will return
true.

=cut

sub am_looping() {
  croak "am_looping called with wrong number of arguments" unless @_ == 0;

  no strict 'refs'; # we're about to make up a varname

  # This blatently abuses the fact that you can give a varible any name
  # you want - even "invalid" ones - you just can't directly refer to
  # them in the source.  We *could* do some kind of hashing here or coding
  # of the name here, but I'm avoiding that for performance reasons.

  my (undef, $filename, $line) = defined(&DB::sub) ? caller(3) : caller;
  my $name = "Babel::LoopDetection::Loop::${filename}::line${line}";

  # are we looping?
  return 1 if ${$name};

  # create a new local variable in our caller's scope so we can track
  # dynamic scope

  # If there is a DB::sub(), this is part of a debugger/profiler,
  # and we assume that it is inserting an extra stack frame that
  # we need to skip.  caller() doesn't show such a stack frame,
  # so we're forced to guess.
  localize *{$name}, \1, defined(&DB::sub) ? SCOPE(3) : SCOPE(1);

  return;
}
push @EXPORT_OK, "am_looping";

=head1 COPYRIGHT

Written by Mark Fowler C<mark@twoshortplanks.com>

Copyright Photobox 2009.  All Rights Reserved.

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=head1 BUGS

Doesn't play well with development routines that alter the caller()
stack as then C<am_looping> isn't called from where we're expecting.
This code does contain code to detect the presence of a DB::sub (from
the debugger) and compensate.

Please see http://twoshortplanks.com/dev/develloopdetection for
details of how to submit bugs, access the source control for
this project, and contact the author.

=head1 SEE ALSO

perl

=cut

1;