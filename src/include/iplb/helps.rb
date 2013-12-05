# encoding: utf-8

# ------------------------------------------------------------------------------
# Copyright (c) 2006 Novell, Inc. All Rights Reserved.
#
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, contact Novell, Inc.
#
# To contact Novell about this file by physical or electronic mail, you may find
# current contact information at www.novell.com.
# ------------------------------------------------------------------------------

# File:	include/iplb/helps.ycp
# Package:	Configuration of iplb
# Summary:	Help texts of all the dialogs
# Authors:	Cong Meng <cmeng@novell.com>
#
# $Id: helps.ycp 27914 2006-02-13 14:32:08Z locilka $
module Yast
  module IplbHelpsInclude
    def initialize_iplb_helps(include_target)
      textdomain "iplb"

      # All helps are here
      @HELPS = {
        "global_conf"  => _(
          "\n" +
            "<p><b><big>check interval</big> =</b> <i>n</i>\n" +
            "</p><p>Defines the number of second between server checks.\n" +
            "</p><p>Default: 10 seconds\n" +
            "\n" +
            "</p><p><b><big>check timeout</big> =</b> <i>n</i>\n" +
            "</p><p>Timeout in seconds for connect, external and ping checks. If the timeout is exceeded then the real server is declared dead.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>If undefined then the value of negotiatetimeout is used. negotiatetimeout is also a global value that may be overriden by a per-virtual setting.\n" +
            "</p><p>If both checktimeout and negotiatetimeout are unset, the default is used.\n" +
            "</p><p>Default: 5 seconds\n" +
            "\n" +
            "</p><p><b><big>failure count</big> =</b> <i>n</i>\n" +
            "</p><p>The number of consecutive times a failure will have to be reported by a check before the realserver is considered to have failed.  A value of 1 will have the realserver considered failed on the first failure.  A successful check will reset the failure counter to 0.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>Default: 1\n" +
            "\n" +
            "</p><p><b><big>negotiate timeout</big> =</b> <i>n</i>\n" +
            "</p><p>Timeout in seconds for negotiate checks.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>If undefined then the value of connecttimeout is used. connecttimeout is also a global value that may be overriden by a per-virtual setting.\n" +
            "</p><p>If both negotiatetimeout and connecttimeout are unset, the default is used.\n" +
            "</p><p>Default: 30 seconds\n" +
            "\n" +
            "</p><p><b><big>fallback</big> =</b> <i>ip_address|hostname[:portnumber|sercvicename]</i> [<b>gate</b>|<b>masq</b>|<b>ipip</b>]\n" +
            "</p><p>the server onto which a webservice is redirected if all real servers are down. Typically this would be 127.0.0.1 with an emergency page.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "\n" +
            "</p><p><b><big>log file</big> = \"</b><i>/path/to/logfile</i><b>\"</b>|syslog_facility\n" +
            "</p><p>An alternative logfile might be specified with this directive. If the logfile does not have a leading '/', it is assumed to be a <b><a href=\"/man/3/syslog\">syslog</a></b>(3) facility name.\n" +
            "</p><p>Default: log directly to the file <i>/var/log/ldirectord.log</i>.\n" +
            "\n" +
            "</p><p><b><big>email alert</big> = \"</b><i>emailaddress</i><b>\"</b>\n" +
            "</p><p>A valid email address for sending alerts about the changed connection status to any real server defined in the virtual service. This option requires perl\n" +
            "module MailTools to be installed. Automatically tries to send email using any of the built-in methods. See perldoc Mail::Mailer for more info on methods.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "\n" +
            "</p><p><b><big>email alert freq</big> =</b> <i>n</i>\n" +
            "</p><p>Delay in seconds between repeating email alerts while any given real server in the virtual service remains inaccessible. A setting of zero seconds will\n" +
            "inhibit the repeating alerts. The email timing accuracy of this setting is dependent on the number of seconds defined in the checkinterval configuration\n" +
            "option.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>Default: 0\n" +
            "\n" +
            "</p><p><b><big>email alert status</big> = all</b>|<b>none</b>|<b>starting</b>|<b>running</b>|<b>stopping</b>|<b>reloading</b>,...\n" +
            "</p><p>Comma delimited list of server states in which email alerts should be sent. <b>all</b> is a short-hand for\n" +
            "\"<b>starting</b>,<b>running</b>,<b>stopping</b>,<b>reloading</b>\". If <b>none</b> is specified, no other option may be specified, otherwise options are ored\n" +
            "with each other.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>Default: all\n" +
            "\n" +
            "</p><p><b><big>callback</big> = \"</b><i>/path/to/callback</i><b>\"</b>\n" +
            "</p><p>If this directive is defined, <b>ldirectord</b> automatically calls the executable <i>/path/to/callback</i> after the configuration file has changed on\n" +
            "disk. This is useful to update the configuration file through <b>scp</b> on the other heartbeated host. The first argument to the callback is the name of the\n" +
            "configuration.\n" +
            "</p><p>This directive might also be used to restart <b>ldirectord</b> automatically after the configuration file changed on disk. However, if <b>autoreload</b> is\n" +
            "set to yes, the configuration is reloaded anyway.\n" +
            "\n" +
            "</p><p><b><big>execute</big> = \"</b><i>configuration</i><b>\"</b>\n" +
            "</p><p>Use this directive to start an instance of ldirectord for the named <i>configuration</i>.\n" +
            "\n" +
            "</p><p><b><big>auto reload</big> = yes</b>|<b>no</b>\n" +
            "</p><p>Defines if &lt;ldirectord&gt; should continuously check the configuration file for modification. If this is set to 'yes' and the configuration file changed\n" +
            "on disk and its modification time (mtime) is newer than the previous version, the configuration is automatically reloaded.\n" +
            "</p><p>Default: no\n" +
            "\n" +
            "</p><p><b><big>quiescent</big> = yes</b>|<b>no</b>\n" +
            "</p><p>If <i>yes</i>, then when real or failback servers are determined to be down, they are not actually removed from the kernel's <small>LVS</small> table.\n" +
            "Rather, their weight is set to zero which means that no new connections will be accepted.\n" +
            "</p><p>This has the side effect, that if the real server has persistent connections, new connections from any existing clients will continue to be routed to the\n" +
            "real server, until the persistant timeout can expire. See ipvsadm for more information on persistant connections.\n" +
            "</p><p>This side-effect can be avoided by running the following:\n" +
            "</p><p>echo 1 &gt; /proc/sys/net/ipv4/vs/expire_quiescent_template\n" +
            "</p><p>If the proc file isn't present this probably means that the kernel doesn't have lvs support, <small>LVS</small> support isn't loaded, or the kernel is too\n" +
            "old to have the proc file. Running ipvsadm as root should load <small>LVS</small> into the kernel if it is possible.\n" +
            "</p><p>If <i>no</i>, then the real or failback servers will be removed from the kernel's <small>LVS</small> table. The default is <i>yes</i>.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>Default: <i>yes</i>\n" +
            "\n" +
            "</p><p><b><big>fork</big> = yes</b>|<b>no</b>\n" +
            "</p><p>If <i>yes</i>, then ldirectord will spawn a child proccess for every virtual server, and run checks against the real servers from them. This will increase\n" +
            "response times to changes in real server status in configurations with many virtual servers. This may also use less memory then running many seperate instances\n" +
            "of ldirectord. Child processes will be automaticly restarted if they die.\n" +
            "</p><p>Default: <i>no</i>\n" +
            "\n" +
            "</p><p><b><big>supervised</big> = yes</b>|<b>no</b>\n" +
            "</p><p>If <i>yes</i>, then ldirectord does not go into background mode. All log-messages are redirected to stdout instead of a logfile. This is useful to run\n" +
            "<b>ldirectord</b> supervised from daemontools. See <a href=\"http://untroubled.org/rpms/daemontools/\">http://untroubled.org/rpms/daemontools/</a> or <a href=\"http://cr.yp.to/daemontools.html\">http://cr.yp.to/daemontools.html</a> for details.\n" +
            "</p><p>Default: <i>no</i>\n" +
            "</p>\n"
        ),
        "vserver_conf" => _(
          "\n" +
            "<p><b><big>virtual server</big> =</b> <i>(ip_address|hostname:portnumber|servicename)|firewall-mark</i>\n" +
            "</p><p>Defines a virtual service by IP-address (or hostname) and port (or servicename) or firewall-mark. A firewall-mark is an integer greater than zero. The\n" +
            "configuration of marking packets is controled using the <tt>\"-m\"</tt> option to <b>ipchains</b>(8). All real services and flags for a virtual service\n" +
            "must follow this line immediately and be indented.\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>real servers</big> =</b> <i>ip_address|hostname[-&gt;ip_address|hostname][:portnumber|servicename</i>]\n" +
            "<b>gate</b>|<b>masq</b>|<b>ipip</b> [<i>weight</i>] [<b>\"</b><i>request</i><b>\", \"</b><i>receive</i><b>\"</b>]\n" +
            "</p><p>Defines a real service by IP-address (or hostname) and port (or servicename). If the port is omitted then a 0 will be used, this is intended primarily for\n" +
            "fwmark services where the port for real servers is ignored. Optionally a range of <small>IP</small> addresses (or two hostnames) may be given, in which case\n" +
            "each <small>IP</small> address in the range will be treated as a real server using the given port. The second argument defines the forwarding method, must be\n" +
            "<b>gate</b>, <b>ipip</b> or <b>masq</b>. The thrid argument is optional and defines the weight for that real server. If omitted then a weight of 1 will be\n" +
            "used. The last two arguments are also optional. They define a request-receive pair to be used to check if a server is alive. They override the request-receive\n" +
            "pair in the virtual server section. These two strings must be quoted. If the request string starts with http://... the IP-address and port of the real\n" +
            "server is overridden, otherwise the IP-address and port of the real server is used.\n" +
            "</p><p>For <small>TCP</small> and <small>UDP</small> (non fwmark) virtual services, unless the forwarding method is masq and the <small>IP</small> address of a\n" +
            "real server is non-local (not present on a interface on the host running ldirectord) then the port of the real server will be set to that of its virtual\n" +
            "service. That is, port-mapping is only available to if the real server is another machine and the forwarding method is masq. This is due to the way that the\n" +
            "underlying <small>LVS</small> code in the kernel functions.\n" +
            "</p><p>More than one of these entries may be inside a virtual section. The checktimeout, negotiatetimeout, failurecount, fallback, emailalert, emailalertfreq and\n" +
            "quiescent options listed above may also appear inside a virtual section, in which case the global setting is overridden.\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>check type</big> = connect</b>|<b>external</b>|<b>negotiate</b>|<b>off</b>|<b>on</b>|<b>ping</b>|<b>checktimeout</b><i>N</i>\n" +
            "</p><p>Type of check to perform. Negotiate sends a request and matches a receive string. Connect only attemts to make a <small>TCP/IP</small> connection, thus the\n" +
            "request and receive strings may be omitted. If checktype is a number then negotiate and connect is combined so that after each N connect attempts one negotiate\n" +
            "attempt is performed. This is useful to check often if a service answers and in much longer intervalls a negotiating check is done. Ping means that\n" +
            "<small>ICMP</small> ping will be used to test the availability of real servers. Ping is also used as the connect check for <small>UDP</small> services. Off\n" +
            "means no checking will take place and no real or fallback servers will be activated. On means no checking will take place and real servers will always be\n" +
            "activated. Default is <i>negotiate</i>.\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>service</big> = dns</b>|<b>ftp</b>|<b>http</b>|<b>https</b>|<b>imap</b>|<b>imaps</b>|<b>ldap</b>|<b>mysql</b>|<b>nntp</b>|<b>none</b>|<b>oracle</b>|<b>pgsql</b>|<b>pop</b>|<b>pops</b>|<b>radius</b>|<b>simpletcp</b>|<b>sip</b>|<b>smtp</b>\n" +
            "</p><p>The type of service to monitor when using checktype=negotiate. None denotes a service that will not be monitored.\n" +
            "</p><p>simpletcp sends the <b>request</b> string to the server and tests it against the <b>receive</b> regexp. The other types of checks connect to the server\n" +
            "using the specified protocol. Please see the <b>request</b> and <b>receive</b> sections for protocol specific information.\n" +
            "</p><p>Default:\n" +
            "</p><dl compact=\"compact\">\n" +
            "<dt>* Virtual server port is 21: ftp\n" +
            "</dt><dt>* Virtual server port is 25: smtp\n" +
            "</dt><dt>* Virtual server port is 53: dns\n" +
            "</dt><dt>* Virtual server port is 80: http\n" +
            "</dt><dt>* Virtual server port is 110: pop\n" +
            "</dt><dt>* Virtual server port is 119: nntp\n" +
            "</dt><dt>* Virtual server port is 143: imap\n" +
            "</dt><dt>* Virtual server port is 389: ldap\n" +
            "</dt><dt>* Virtual server port is 443: https\n" +
            "</dt><dt>* Virtual server port is 993: imaps\n" +
            "</dt><dt>* Virtual server port is 995: pops\n" +
            "</dt><dt>* Virtual server port is 1521: oracle\n" +
            "</dt><dt>* Virtual server port is 1812: radius\n" +
            "</dt><dt>* Virtual server port is 3306: mysql\n" +
            "</dt><dt>* Virtual server port is 5432: pgsql\n" +
            "</dt><dt>* Virtual server port is 5060: sip\n" +
            "</dt><dt>* Otherwise: none\n" +
            "\n" +
            "\n" +
            "</dt><dt><b><big>check command</big> = \"</b><i>path to script</i><b>\"</b>\n" +
            "<p>This setting is used if checktype is external and is the command to be run to check the status of a real server. It should exit with status 0 if everything\n" +
            "is ok, or non-zero otherwise.\n" +
            "</p><p>Four parameters are passed to the script:\n" +
            "</p></dt><dt>* virtual server ip/firewall mark\n" +
            "</dt><dt>* virtual server port\n" +
            "</dt><dt>* real server ip\n" +
            "</dt><dt>* real server port\n" +
            "</dt><dt>Default: /bin/true\n" +
            "\n" +
            "\n" +
            "<p><b><big>check port</big> =</b> <i>n</i>\n" +
            "</p><p>Number of port to monitor. Sometimes check port differs from service port.\n" +
            "</p><p>Default: port specified for each real server\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>request</big> = \"</b><i>uri to requested object</i><b>\"</b>\n" +
            "</p><p>This object will be requested each checkinterval seconds on each real server. The string must be inside quotes. Note that this string may be overridden by\n" +
            "an optional per real-server based request-string.\n" +
            "</p><p>For a <small>DNS</small> check this should the name of an A record, or the address of a <small>PTR</small> record to look up.\n" +
            "</p><p>For a MySQL, Oracle or PostgeSQL check, this should be an <small>SQL</small> query. The data returned is not checked, only that the answer is one or more\n" +
            "rows. This is a required setting.\n" +
            "</p><p>For a simpletcp check, this string is sent verbatim except any occurances of \n" +
            " are replaced with a new line character.\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>receive</big> = \"</b><i>regexp to compare</i><b>\"</b>\n" +
            "</p><p>If the requested result contains this <i>regexp to compare</i>, the real server is declared alive. The regexp must be inside quotes. Keep in mind that\n" +
            "regexps are not plain strings and that you need to escape the special characters if they should as literals. Note that this regexp may be overridden by an\n" +
            "optional per real-server based receive regexp.\n" +
            "</p><p>For a <small>DNS</small> check this should be any one the A record's addresses or any one of the <small>PTR</small> record's names.\n" +
            "</p><p>For a MySQL check, the receive setting is not used.\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>http method</big> = <small>GET</small></b> | <b><small>HEAD</small></b>\n" +
            "</p><p>Sets the <small>HTTP</small> method which should be used to fetch the <small>URI</small> specified in the request-string. <small>GET</small> is the\n" +
            "method used by default if the parameter is not set. If <small>HEAD</small> is used, the receive-string should be unset.\n" +
            "</p><p>Default: <small>GET</small>\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>virtual host</big> = \"</b><i>hostname</i><b>\"</b>\n" +
            "</p><p>Used when using a negotiate check with <small>HTTP</small> or <small>HTTPS</small> . Sets the host header used in the <small>HTTP</small> request. In the\n" +
            "case of <small>HTTPS</small> this generally needs to match the common name of the <small>SSL</small> certificate. If not set then the host header will be\n" +
            "derived from the request url for the real server if present. As a last resort the <small>IP</small> address of the real server will be used.\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>login</big> = \"</b><i>username</i><b>\"</b>\n" +
            "</p><p>For <small>FTP</small> , <small>IMAP</small> , <small>LDAP</small> , MySQL, Oracle, <small>POP</small> and PostgreSQL, the username used to log in.\n" +
            "</p><p>For Radius the passwd is used for the attribute User-Name.\n" +
            "</p><p>For <small>SIP</small> , the username is used as both the to and from address for an <small>OPTIONS</small> query.\n" +
            "</p><p>Default:\n" +
            "</p></dt><dt>* <small>FTP:</small> Anonymous\n" +
            "</dt><dt>* MySQL Oracle, and PostgreSQL: Must be specified in the configuration\n" +
            "</dt><dt>* <small>SIP:</small> ldirectord@&lt;hostname&gt;, hostname is derived as per the passwd option below.\n" +
            "</dt><dt>* Otherwise: empty string, which denotes that case authentication will not be attempted.\n" +
            "\n" +
            "\n" +
            "</dt><dt><b><big>password</big> = \"</b><i>password</i><b>\"</b>\n" +
            "<p>Password to use to login to <small>FTP</small> , <small>IMAP</small> , <small>LDAP</small> , MySQL, Oracle, <small>POP</small> , PostgreSQL and\n" +
            "<small>SIP</small> servers.\n" +
            "</p><p>For Radius the passwd is used for the attribute User-Password.\n" +
            "</p><p>Default:\n" +
            "</p></dt><dt>* <small>FTP:</small> ldirectord@&lt;hostname&gt;, where hostname is the environment variable <small>HOSTNAME</small> evaluated at run time, or sourced\n" +
            "from uname if unset.\n" +
            "</dt><dt>* Otherwise: empty string. In the case of <small>LDAP</small> , MySQL, Oracle, and PostgreSQL this means that authentication will not be performed.\n" +
            "\n" +
            "\n" +
            "</dt><dt><b><big>database name</big> = \"</b><i>databasename</i><b>\"</b>\n" +
            "<p>Database to use for MySQL, Oracle and PostgreSQL servers, this is the database that the query (set by <b>receive</b> above) will be performed against. This\n" +
            "is a required setting.\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>radius secret</big> = \"</b><i>radiussecret</i><b>\"</b>\n" +
            "</p><p>Secret to use for Radius servers, this is the secret used to perform an Access-Request with the username (set by <b>login</b> above) and passwd (set by\n" +
            "<b>passwd</b> above).\n" +
            "</p><p>Default: empty string\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>persistent</big> =</b> <i>n</i>\n" +
            "</p><p>Number of seconds for persistent client connections.\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>netmask</big> =</b> <i>w.x.y.z</i>\n" +
            "</p><p>Netmask to be used for granularity of persistent client connections.\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>scheduler</big> =</b> <i>scheduler_name</i>\n" +
            "</p><p>Scheduler to be used by <small>LVS</small> for loadbalancing. For an information on the available sehedulers please see the <b><a href=\"ipvsadm\">ipvsadm</a></b>(8) man page.\n" +
            "</p><p>Default: \"wrr\"\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>protocol</big> = tcp</b>|<b>udp</b>|<b>fwm</b>\n" +
            "</p><p>Protocol to be used. If the virtual is specified as an <small>IP</small> address and port then it must be one of tcp or udp. If a firewall mark then the\n" +
            "protocol must be fwm.\n" +
            "</p><p>Default:\n" +
            "</p></dt><dt>* Virtual is an <small>IP</small> address and port, and the port is not 53: tcp\n" +
            "</dt><dt>* Virtual is an <small>IP</small> address and port, and the port is 53: udp\n" +
            "</dt><dt>* Virtual is a firewall mark: fwm\n" +
            "</dt></dl>\n" +
            "\n" +
            "\n" +
            "</p><p><b><big>check timeout</big> =</b> <i>n</i>\n" +
            "</p><p>Timeout in seconds for connect, external and ping checks. If the timeout is exceeded then the real server is declared dead.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>If undefined then the value of negotiatetimeout is used. negotiatetimeout is also a global value that may be overriden by a per-virtual setting.\n" +
            "</p><p>If both checktimeout and negotiatetimeout are unset, the default is used.\n" +
            "</p><p>Default: 5 seconds\n" +
            "\n" +
            "</p><p><b><big>negotiate timeout</big> =</b> <i>n</i>\n" +
            "</p><p>Timeout in seconds for negotiate checks.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>If undefined then the value of connecttimeout is used. connecttimeout is also a global value that may be overriden by a per-virtual setting.\n" +
            "</p><p>If both negotiatetimeout and connecttimeout are unset, the default is used.\n" +
            "</p><p>Default: 30 seconds\n" +
            "\n" +
            "</p><p><b><big>failure count</big> =</b> <i>n</i>\n" +
            "</p><p>The number of consecutive times a failure will have to be reported by a check before the realserver is considered to have failed.  A value of 1 will have the realserver considered failed on the first failure.  A successful check will reset the failure counter to 0.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>Default: 1\n" +
            "\n" +
            "</p><p><b><big>email alert</big> = \"</b><i>emailaddress</i><b>\"</b>\n" +
            "</p><p>A valid email address for sending alerts about the changed connection status to any real server defined in the virtual service. This option requires perl\n" +
            "module MailTools to be installed. Automatically tries to send email using any of the built-in methods. See perldoc Mail::Mailer for more info on methods.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "\n" +
            "</p><p><b><big>email alert freq</big> =</b> <i>n</i>\n" +
            "</p><p>Delay in seconds between repeating email alerts while any given real server in the virtual service remains inaccessible. A setting of zero seconds will\n" +
            "inhibit the repeating alerts. The email timing accuracy of this setting is dependent on the number of seconds defined in the checkinterval configuration\n" +
            "option.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>Default: 0\n" +
            "\n" +
            "</p><p><b><big>email alert status</big> = all</b>|<b>none</b>|<b>starting</b>|<b>running</b>|<b>stopping</b>|<b>reloading</b>,...\n" +
            "</p><p>Comma delimited list of server states in which email alerts should be sent. <b>all</b> is a short-hand for\n" +
            "\"<b>starting</b>,<b>running</b>,<b>stopping</b>,<b>reloading</b>\". If <b>none</b> is specified, no other option may be specified, otherwise options are ored\n" +
            "with each other.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>Default: all\n" +
            "\n" +
            "</p><p><b><big>fallback</big> =</b> <i>ip_address|hostname[:portnumber|sercvicename]</i> [<b>gate</b>|<b>masq</b>|<b>ipip</b>]\n" +
            "</p><p>the server onto which a webservice is redirected if all real servers are down. Typically this would be 127.0.0.1 with an emergency page.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "\n" +
            "</p><p><b><big>quiescent</big> = yes</b>|<b>no</b>\n" +
            "</p><p>If <i>yes</i>, then when real or failback servers are determined to be down, they are not actually removed from the kernel's <small>LVS</small> table.\n" +
            "Rather, their weight is set to zero which means that no new connections will be accepted.\n" +
            "</p><p>This has the side effect, that if the real server has persistent connections, new connections from any existing clients will continue to be routed to the\n" +
            "real server, until the persistant timeout can expire. See ipvsadm for more information on persistant connections.\n" +
            "</p><p>This side-effect can be avoided by running the following:\n" +
            "</p><p>echo 1 &gt; /proc/sys/net/ipv4/vs/expire_quiescent_template\n" +
            "</p><p>If the proc file isn't present this probably means that the kernel doesn't have lvs support, <small>LVS</small> support isn't loaded, or the kernel is too\n" +
            "old to have the proc file. Running ipvsadm as root should load <small>LVS</small> into the kernel if it is possible.\n" +
            "</p><p>If <i>no</i>, then the real or failback servers will be removed from the kernel's <small>LVS</small> table. The default is <i>yes</i>.\n" +
            "</p><p>If defined in a virtual server section then the global value is overridden.\n" +
            "</p><p>Default: <i>yes</i>\n" +
            "\n" +
            "\n" +
            "\n"
        )
      } 

      # EOF
    end
  end
end
