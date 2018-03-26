use lib 'lib';
use Grammar::Tracer;
use TARS::Parser;

my $result = Tars.parsefile('test.tars', actions => TarsAction.new );