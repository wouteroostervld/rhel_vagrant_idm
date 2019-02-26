#Vagrantfile with IPA-server and -client.

Vagrantfile to install an ipa-server (ipa.example999.com) and configure a separate ipa-client
(rhel76.example999.com).

Vagrantfile uses vagrant-registration to register box. This plugin is broken since RHEL 7.5. Project
is waiting on a patch ( https://github.com/projectatomic/adb-vagrant-registration/pull/127 ).
In the mean time you can use this repo which integrates this fix:

https://github.com/wouteroostervld/adb-vagrant-registration

    git clone https://github.com/wouteroostervld/adb-vagrant-registration
    cd adb-vagrant-registration
    vagrant plugin install .

Uses the/a rhel76-box with nfs and subscription-manager available.

How to test the functioning of the ipa-client and -server:

Connect to the client-machine:

    [wouter@cookie vanilla_rhel]$ vagrant ssh rhel76

Become the admin-user:

    [vagrant@rhel76 ~]$ sudo -iu admin
    Creating home directory for admin.

Get the admin-token:

    [admin@rhel76 ~]$ kinit
    Password for admin@EXAMPLE999.COM: 

Test GSSAPI SSO functionality:

    [admin@rhel76 ~]$ ssh -v ipa
    OpenSSH_7.4p1, OpenSSL 1.0.2k-fips  26 Jan 2017
    (...)
    debug1: Authentications that can continue: publickey,gssapi-keyex,gssapi-with-mic,password,keyboard-interactive
    debug1: Next authentication method: gssapi-keyex
    debug1: No valid Key exchange context
    debug1: Next authentication method: gssapi-with-mic
    debug1: Authentication succeeded (gssapi-with-mic).
    Authenticated to ipa (via proxy).
    debug1: channel 0: new [client-session]
    debug1: Requesting no-more-sessions@openssh.com
    debug1: Entering interactive session.
    debug1: pledge: proc
    debug1: client_input_global_request: rtype hostkeys-00@openssh.com want_reply 0
    debug1: Sending environment.
    debug1: Sending env LANG = en_US.UTF-8
    Creating home directory for admin.
    Last login: Tue Feb 26 14:46:49 2019 from 192.168.33.10
    [admin@ipa ~]$ 

Hooray!

If you add "192.168.33.11 ipa.example999.com" to /etc/hosts you can connect to the admin-interface
of RedHat IdM.
