use strict;
use warnings;
use utf8;
use Test::More;
use lib "xt/lib";
use CLI;

subtest same => sub {
    with_same_local {
        my $r1 = cpm_install "App::FatPacker";
        ok -f $r1->local . "/bin/fatpack";
        like $r1->err, qr/DONE install App-FatPacker/;

        my $r2 = cpm_install "App::FatPacker";
        like $r2->err, qr/DONE install App::FatPacker is up to date/;
        like $r2->err, qr/0 distribution installed/;
    };
};

subtest no_meta => sub {
    my $r = cpm_install "WWW::RobotRules::Extended";
    like $r->err, qr/DONE install WWW-RobotRules-Extended/;
};

subtest test => sub {
    # Test::Requires only in test requires
    my $r = cpm_install "Data::Section::Simple";
    unlike $r->err, qr/Test-Requires/;

    $r = cpm_install "--no-test", "Data::Section::Simple";
    unlike $r->err, qr/Test-Requires/;

    $r = cpm_install "--test", "Data::Section::Simple";
    like $r->err, qr/Test-Requires/;
};

subtest range => sub {
    my $r = cpm_install "CPAN::Test::Dummy::Perl5::Deps::VersionRange";
    is $r->exit, 0;
    like $r->err, qr/DONE install CPAN-Test-Dummy-Perl5-Deps-VersionRange/;
};

subtest http => sub {
    my $r = cpm_install "https://cpan.metacpan.org/authors/id/L/LE/LEONT/ExtUtils-Config-0.008.tar.gz";
    is $r->exit, 0;
};

subtest configure => sub {
    # https://github.com/Ovid/Test-Differences/issues/13
    # https://rt.cpan.org/Ticket/Display.html?id=119616
    my $r = cpm_install 'Lingua::EN::Inflect@1.900';
    is $r->exit, 0;
    note $r->log;

    $r = cpm_install 'Data::Utilities@0.04';
    is $r->exit, 0;
    note $r->log;
};

done_testing;
