#!/usr/bin/perl -w
# --
# scripts/restore.pl - the restore script
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: restore.pl,v 1.2 2006-08-29 17:51:09 martin Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin)."/Kernel/cpan-lib";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Getopt::Std;
# --
# get options
# --
my %Opts = ();
my $DB = '';
my $DBDump = '';
getopt('hbd', \%Opts);
if ($Opts{'h'}) {
    print "restore.pl <Revision $VERSION> - restore script\n";
    print "Copyright (c) 2001-2006 OTRS GmbH, http://otrs.org/\n";
    print "usage: restore.pl -b /data_backup/<TIME>/ -d /opt/otrs/\n";
    exit 1;
}
if (!$Opts{'b'}) {
    print STDERR "ERROR: Need -d for backup directory\n";
    exit (1);
}
elsif (! -d $Opts{'b'}) {
    print STDERR "ERROR: No such directory: $Opts{'b'}\n";
    exit (1);
}
if (!$Opts{'d'}) {
    print STDERR "ERROR: Need -d for destination directory\n";
    exit (1);
}
elsif (! -d $Opts{'d'}) {
    print STDERR "ERROR: No such directory: $Opts{'d'}\n";
    exit (1);
}
# restore config
print "Restore $Opts{'b'}/Config.tar.gz ...\n";
if (-e "$Opts{'b'}/Config.tar.gz") {
    system("cd $Opts{'d'} && tar -xzf $Opts{'b'}/Config.tar.gz");
}

require Kernel::Config;
require Kernel::System::Time;
require Kernel::System::DB;
require Kernel::System::Log;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{TimeObject} = Kernel::System::Time->new(
    %CommonObject,
);
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-Restore',
    %CommonObject,
);
my $DatabaseHost = $CommonObject{ConfigObject}->Get('DatabaseHost');
my $Database = $CommonObject{ConfigObject}->Get('Database');
my $DatabaseUser = $CommonObject{ConfigObject}->Get('DatabaseUser');
my $DatabasePw = $CommonObject{ConfigObject}->Get('DatabasePw');
my $DatabaseDSN = $CommonObject{ConfigObject}->Get('DatabaseDSN');
my $ArticleDir = $CommonObject{ConfigObject}->Get('ArticleDir');
# check db backup support
if ($DatabaseDSN =~ /:mysql/i) {
    $DB = 'MySQL';
    $DBDump = 'mysql';
}
elsif ($DatabaseDSN =~ /:pg/i) {
    $DB = 'PostgreSQL';
    $DBDump = 'psql';
}
else {
    print STDERR "ERROR: Can't backup, no database dump support!\n";
    exit (1);
}
# check needed programs
foreach my $CMD ('cp', 'tar', $DBDump) {
    my $Installed = 0;
    open (IN, "which $CMD | ");
    while (<IN>) {
        $Installed = 1;
    }
    close (IN);
    if (!$Installed) {
        print STDERR "ERROR: Can't locate $CMD!\n";
        exit (1);
    }
}
# restore
my $Home = $CommonObject{ConfigObject}->Get('Home');

# backup application
if (-e "$Opts{'b'}/Application.tar.gz") {
    print "Restore $Opts{'b'}/Application.tar.gz ...\n";
    system("cd $Opts{'d'} && tar -xzf $Opts{'b'}/Application.tar.gz");
}
# backup vardir
if (-e "$Opts{'b'}/VarDir.tar.gz") {
    print "Restore $Opts{'b'}/VarDir.tar.gz ...\n";
    system("cd $Opts{'d'} && tar -xzf $Opts{'b'}/VarDir.tar.gz");
}
# backup datadir
if (-e "$Opts{'b'}/DataDir.tar.gz") {
    print "Restore $Opts{'b'}/DataDir.tar.gz ...\n";
    system("cd $Opts{'d'} && tar -xzf $Opts{'b'}/DataDir.tar.gz");
}

# backup database
if ($DB =~ /mysql/i) {
    print "create $DB\n";
    if ($DatabasePw) {
        $DatabasePw = "-p$DatabasePw";
    }
    if (-e "$Opts{'b'}/DatabaseBackup.sql.gz") {
        print "decompresses SQL-file ...\n";
        system("gunzip $Opts{'b'}/DatabaseBackup.sql.gz");
        print "cat SQL-file into $DB database\n";
        system("cat $Opts{'b'}/DatabaseBackup.sql | mysql -u$DatabaseUser $DatabasePw -h$DatabaseHost $Database");
        print "compress SQL-file...\n";
        system("gzip $Opts{'b'}/DatabaseBackup.sql");
    }
    elsif (-e "$Opts{'b'}/DatabaseBackup.sql.bz2") {
        print "decompresses SQL-file ...\n";
        system("bunzip $Opts{'b'}/DatabaseBackup.sql.bz2");
        print "cat SQL-file into $DB database\n";
        system("cat $Opts{'b'}/DatabaseBackup.sql | mysql -u$DatabaseUser $DatabasePw -h$DatabaseHost $Database");
        print "compress SQL-file...\n";
        system("bzip $Opts{'b'}/DatabaseBackup.sql");
    }
}
else {
    if (-e "$Opts{'b'}/DatabaseBackup.sql.gz") {
        print "decompresses SQL-file ...\n";
        system("gunzip $Opts{'b'}/DatabaseBackup.sql.gz");
        print "cat SQL-file into $DB database\n";
        system("cat $Opts{'b'}/DatabaseBackup.sql | psql -u$DatabaseUser -h$DatabaseHost $Database");
        print "compress SQL-file...\n";
        system("gzip $Opts{'b'}/DatabaseBackup.sql");
    }
    elsif (-e "$Opts{'b'}/DatabaseBackup.sql.bz2") {
        print "decompresses SQL-file ...\n";
        system("bunzip $Opts{'b'}/DatabaseBackup.sql.bz2");
        print "cat SQL-file into $DB database\n";
        system("cat $Opts{'b'}/DatabaseBackup.sql | psql -u$DatabaseUser -h$DatabaseHost $Database");
        print "compress SQL-file...\n";
        system("bzip $Opts{'b'}/DatabaseBackup.sql");
    }
}

