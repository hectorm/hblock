%define name hblock
%define version __PKG_VERSION__

Name: %{name}
Version: %{version}
Release: 1
Summary: Improve your security and privacy by blocking ads, tracking and malware domains
Packager: Héctor Molinero Fernández <hector@molinero.dev>
License: MIT
URL: https://github.com/hectorm/hblock
Source0: %{name}-%{version}.tar.gz
BuildArch: noarch
BuildRequires: make systemd
Requires: curl

%{?systemd_requires}

%description
This POSIX-compliant shell script, designed for Unix-like systems, gets a list
of domains that serve ads, tracking scripts and malware from multiple sources
and creates a hosts file (alternative formats are also supported) that prevents
your system from connecting to them.

%prep
%setup -c

%install
make DESTDIR="%{buildroot}" PREFIX="%{buildroot}%{_prefix}" SYSTEMDUNITDIR="%{buildroot}%{_unitdir}" SKIP_SERVICE_START=1 install

%clean
rm -rf "%{buildroot}"

%post
%systemd_post hblock.timer

%preun
%systemd_preun hblock.timer

%files
%{_prefix}/bin/hblock
%{_unitdir}/hblock.timer
%{_unitdir}/hblock.service
