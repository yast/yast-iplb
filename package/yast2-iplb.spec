#
# spec file for package yast2-iplb
#
# Copyright (c) 2014 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           yast2-iplb
Version:        4.0.1
Release:        0

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source0:        %{name}-%{version}.tar.bz2

Requires:       yast2
BuildRequires:  perl-XML-Writer
BuildRequires:  update-desktop-files
BuildRequires:  yast2
BuildRequires:  yast2-devtools
BuildRequires:  yast2-testsuite

BuildArch:      noarch

Requires:       yast2-ruby-bindings >= 1.0.0

Summary:        Configuration of iplb
License:        GPL-2.0
Group:          System/YaST

%description
YaST2 - Configuration of IP load balance.With this module
you can configure a IP load balance system, frequently
used on high availability (HA) clusters.


%prep
%setup -n %{name}-%{version}

%build
%yast_build

%install
%yast_install

%files
%defattr(-,root,root)
%dir %{yast_yncludedir}/iplb
%{yast_yncludedir}/iplb/*
%{yast_clientdir}/iplb*.rb
%{yast_moduledir}/Iplb.rb
%{yast_desktopdir}/iplb.desktop
%{yast_scrconfdir}/*.scr
%doc %{yast_docdir}

%changelog
