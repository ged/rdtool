=begin
= RDtool 0.6.21
== What is RDtool

RD is Ruby's POD. RDtool is a formatter for RD. This is a re-packaging of
rdtool as a Rubygem.

== What is Changed

See HISTORY.

== How to Install

 ((%sudo gem install rdtool%))

== How to use

Simply,
  % rd2 rdfile.rd > outputfile

If you want to indicate format-library, do
  % rd2 -r library rdfile.rd > outputfile

Use ((% rd2 --help %)) for more options.

For options depend on format-library, enter ((%--help%)) after
the indication of format-library. For example,

  % rd2 -r rd/rd2html-lib.rb --help

rd2 loads "${HOME}/.rd2rc" when it runs, so you can use it to set 
default options.

== How to write RD?

Please read doc/rd-draft.rd.

== About bug reports

This is a re-packaged version 

If you find a bug in RDtool, please E-mail me
((<URL:mailto:moonwolf@moonwolf.com>)).

== License

You can use/re-distribute/change RDtool under Ruby's License or GPL.
This distribution of RDtool include files that are copyrighted by
somebody else, and these files can be re-distributed under those own license.
These files include the condition of those licenses in themselves.

=end
