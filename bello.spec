# RPM packaging recipe for the bello package
#
# Copyright 2024 Red Hat, Inc.
# Copyright 2024 林博仁(Buo-ren Lin) <buo.ren.lin@gmail.com>
# SPDX-License-Identifier: CC-BY-SA-3.0
Name:           bello
Version:        0.1
Release:        1%{?dist}
Summary:        Hello World example implemented in bash script

License:        GPLv3+
URL:            https://example.com/%{name}
Source0:        https://www.example.com/%{name}/releases/%{name}-%{version}.tar.gz

Requires:       bash

BuildArch:      noarch

%description
The long-tail description for our Hello World Example implemented in
bash script.

%prep
%setup -q


%build
echo build

%install
mkdir -p %{buildroot}/%{_bindir}

install -m 0755 %{name} %{buildroot}/%{_bindir}/%{name}


%files
%license LICENSE
%{_bindir}/%{name}


%changelog
* Sun Dec 22 2024 林博仁(Buo-ren Lin) <buo.ren.lin@gmail.com> - 0.1-1
- First bello package
- Example second item in the changelog for version-release 0.1-1
