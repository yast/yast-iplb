#
# spec file for package yast2-iplb
#
# Copyright (c) 2021 SUSE LLC
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via https://bugs.opensuse.org/
#


Name:           yast2-iplb
Version:        4.4.1
Release:        0
Summary:        Configuration of iplb
License:        GPL-2.0-only
Group:          System/YaST
URL:            https://github.com/yast/yast-iplb
Source0:        %{name}-%{version}.tar.bz2
BuildRequires:  perl-XML-Writer
BuildRequires:  update-desktop-files
BuildRequires:  yast2
BuildRequires:  yast2-devtools >= 4.4.0
BuildRequires:  yast2-testsuite
Requires:       yast2
Requires:       yast2-ruby-bindings >= 1.0.0
Supplements:    autoyast(iplb)
BuildArch:      noarch

%description
YaST2 - Configuration of IP load balance.With this module
you can configure a IP load balance system, frequently
used on high availability (HA) clusters.

%prep
%setup -q

%build
%yast_build

%install
%yast_install
%yast_metainfo

%files
%license COPYING
%{yast_yncludedir}
%{yast_clientdir}
%{yast_moduledir}
%{yast_desktopdir}
%{yast_metainfodir}
%{yast_scrconfdir}
%{yast_icondir}

%changelog
