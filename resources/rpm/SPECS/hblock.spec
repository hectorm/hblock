%define name hblock
%define version __PKG_VERSION__

Name: %{name}
Version: %{version}
Release: 1
Summary: Improve your security and privacy by blocking ads, tracking and malware domains

License: MIT
URL: https://github.com/hectorm/hblock
Source0: %{name}.tar

BuildArch: noarch
BuildRequires: make systemd
Requires: (curl or wget)
%{?systemd_requires}

%description
hBlock is a POSIX-compliant shell script that gets a list of domains that serve
ads, tracking scripts and malware from multiple sources and creates a hosts
file, among other formats, that prevents your system from connecting to them.

%prep
%setup -c

%install
%make_install PREFIX="%{?buildroot}%{_prefix}" BINDIR="%{?buildroot}%{_bindir}" MANDIR="%{?buildroot}%{_mandir}" SYSTEMDUNITDIR="%{?buildroot}%{_unitdir}"

%post
%systemd_post %{name}.timer

%preun
%systemd_preun %{name}.timer

%files
%{_bindir}/%{name}
%{_unitdir}/%{name}.timer
%{_unitdir}/%{name}.service
%{_mandir}/man1/%{name}.1*
%license LICENSE.md
%doc README.md
