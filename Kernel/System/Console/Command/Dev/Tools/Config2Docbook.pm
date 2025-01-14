# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021-2022 Znuny GmbH, https://znuny.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::Config2Docbook;

use strict;
use warnings;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::System::DB',
    'Kernel::System::SysConfig',
    'Kernel::System::YAML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate a config options reference chapter (docbook) for the administration manual.');
    $Self->AddOption(
        Name        => 'language',
        Description => "Which language to use.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $UserLanguage = $Self->GetOption('language');
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Language' => {
            UserLanguage => $UserLanguage,
        },
    );
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => '
            SELECT DISTINCT navigation
            FROM sysconfig_default
            ORDER by navigation',
    );

    my %NavigationGroups;

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $NavigationGroups{ $Row[0] } = 1;
    }

    print <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE appendix PUBLIC "-//OASIS//DTD DocBook XML V4.4//EN"
    "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd">

<!-- Note: this file is autogenerated by Dev::Tools::Config2Docbook -->

EOF

    my $AppendixTitle = $LanguageObject->Translate('Configuration Options Reference');
    print <<"EOF";
<appendix id=\"ConfigReference\">
    <title>$AppendixTitle</title>
EOF

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $YAMLObject      = $Kernel::OM->Get('Kernel::System::YAML');

    for my $Navigation ( sort { $a cmp $b } keys %NavigationGroups ) {

        my @SettingsList = $SysConfigObject->ConfigurationListGet(
            Navigation => $Navigation,
        );

        my $EscapedNavigation = $Navigation;
        $EscapedNavigation =~ s{::}{_}smxg;

        my $VisibleNavigation = $Navigation;
        $VisibleNavigation =~ s{::}{ → }smxg;

        print <<"EOF";
    <section id=\"ConfigReference_Section_$EscapedNavigation\">
        <title>$VisibleNavigation</title>
        <variablelist>
EOF
        for my $Setting (@SettingsList) {
            my $Link = $Setting->{Name};
            $Link =~ s/###/_/g;
            $Link =~ s/[ ]/_/g;
            $Link =~ s/\///g;

            print <<EOF;
            <varlistentry id="ConfigReference_Setting_$Link">
                <term>$Setting->{Name}</term>
                <listitem>
EOF

            # Description in User Language
            my $Description = $LanguageObject->Translate( $Setting->{Description} );

            $Description =~ s/&/&amp;/g;
            $Description =~ s/</&lt;/g;
            $Description =~ s/>/&gt;/g;
            print <<"EOF";
                    <para>$Description</para>
EOF

            my %DefaultSetting = $SysConfigObject->SettingGet(
                Name    => $Setting->{Name},
                Default => 1,
            );

            my $IsReadOnly                 = $DefaultSetting{IsReadOnly}               // 0;
            my $IsValid                    = $DefaultSetting{IsValid}                  // 1;
            my $IsRequired                 = $DefaultSetting{IsRequired}               // 0;
            my $IsInvisible                = $DefaultSetting{IsInvisible}              // 0;
            my $IsUserModificationPossible = $DefaultSetting{UserModificationPossible} // 0;
            my $IsUserModificationActive   = $DefaultSetting{UserModificationActive}   // 0;

            my $EffectiveValueStrg = $YAMLObject->Dump(
                Data => $DefaultSetting{EffectiveValue},
            );

            if ($IsReadOnly) {
                my $ReadOnlyText = $LanguageObject->Translate('This setting can not be changed.');
                print <<"EOF";
                    <para>$ReadOnlyText</para>
EOF
            }
            elsif ( !$IsValid ) {
                my $InvalidText = $LanguageObject->Translate('This setting is not active by default.');
                print <<"EOF";
                    <para>$InvalidText</para>\
EOF
            }
            elsif ($IsRequired) {
                my $RequiredText = $LanguageObject->Translate('This setting can not be deactivated.');
                print <<"EOF";
                    <para>$RequiredText</para>
EOF
            }
            elsif ($IsInvisible) {
                my $InvisibleText = $LanguageObject->Translate('This setting is not visible.');
                print <<"EOF";
                    <para>$InvisibleText</para>
EOF
            }
            elsif ($IsUserModificationPossible) {
                my $UserModificationText
                    = $LanguageObject->Translate('This setting can be overridden in the user preferences.');
                if ( !$IsUserModificationActive ) {
                    $UserModificationText = $LanguageObject->Translate(
                        'This setting can be overridden in the user preferences, but is not active by default.'
                    );
                }
                print <<"EOF";
                    <para>$UserModificationText</para>
EOF
            }

            my $DefaultValueText = $LanguageObject->Translate('Default value');
            print <<"EOF";
                    <para>$DefaultValueText:
                        <programlisting><![CDATA[$EffectiveValueStrg]]></programlisting>
                    </para>
                </listitem>
            </varlistentry>
EOF
        }
        print <<"EOF";
        </variablelist>
    </section>

EOF
    }
    print <<"EOF";
</appendix>
EOF

    return $Self->ExitCodeOk();
}

1;
