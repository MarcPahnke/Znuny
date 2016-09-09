# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::EmailParser;

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my @Tests = (
    {
        Name     => "plain email",
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedPlain.eml",
        Body     => 'first part



second part',
        Attachments => [
            # Look for the concatenated plain body part.
            {
                'Charset' => 'us-ascii',
                'Content' => 'first part



second part',
                'ContentID'       => undef,
                'ContentLocation' => undef,
                'ContentType'     => 'text/plain; charset=us-ascii',
                'Disposition'     => undef,
                'Filename'        => 'file-1',
                'Filesize'        => 25,
                'MimeType'        => 'text/plain'
            },
            # Look for the attachment.
            {
                'Charset' => '',
                'Content' => "1\n",
                'ContentDisposition' => "attachment; filename=1.txt\n",
                'ContentID'       => undef,
                'ContentLocation' => undef,
                'ContentType'     => 'text/plain; name="1.txt"',
                'Disposition'     => 'attachment; filename=1.txt',
                'Filename'        => '1.txt',
                'Filesize'        => 2,
                'MimeType'        => 'text/plain'
            }
        ],
    },
    {
        Name     => "plain email",
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedHTML.eml",
        Body     => 'first part



second part',
        Attachments => [
            # Look for the plain body part.
            {
                'Charset' => 'us-ascii',
                'Content' => 'first part



second part',
                'ContentAlternative' => 1,
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/plain; charset=us-ascii',
                'Disposition'        => undef,
                'Filename'           => 'file-1',
                'Filesize'           => 25,
                'MimeType'           => 'text/plain'
            },
            # Look for the concatenated HTML body part.
            {
                'Charset' => 'us-ascii',
                'Content' =>
                    '<html><head><meta http-equiv="Content-Type" content="text/html charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><b class="">first</b> part<div class=""><br class=""></div><div class=""></div></body></html><html><head><meta http-equiv="Content-Type" content="text/html charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><div class=""></div><div class=""><br class=""></div><div class="">second part</div></body></html>',
                'ContentAlternative' => 1,
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/html; charset=us-ascii',
                'Disposition'        => undef,
                'Filename'           => 'file-2',
                'Filesize'           => 589,
                'MimeType'           => 'text/html'
            },
            # Look for the attachment.
            {
                'Charset' => '',
                'Content' => "1\n",
                'ContentAlternative' => 1,
                'ContentDisposition' => "attachment; filename=1.txt\n",
                'ContentID'       => undef,
                'ContentLocation' => undef,
                'ContentType'     => 'text/plain; name="1.txt"',
                'Disposition'     => 'attachment; filename=1.txt',
                'Filename'        => '1.txt',
                'Filesize'        => 2,
                'MimeType'        => 'text/plain'
            }
        ],
    },
);

for my $Test (@Tests) {
    my @Array;
    open my $IN, '<', $Test->{RawEmail};    ## no critic
    while (<$IN>) {
        push @Array, $_;
    }
    close $IN;

    # create local object
    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );

    my @Attachments = $EmailParserObject->GetAttachments();
    my $Body        = $EmailParserObject->GetMessageBody();

    $Self->Is(
        $Body,
        $Test->{Body},
        "Test->{Name} - body",
    );

    $Self->IsDeeply(
        \@Attachments,
        $Test->{Attachments},
        "$Test->{Name} - attachments"
    );
}

1;
