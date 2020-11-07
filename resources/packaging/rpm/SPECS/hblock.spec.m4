m4_changequote([[, ]])m4_dnl
%define name hblock
%define version m4_esyscmd(printf -- '%s' "${PKG_VERSION?}")

Name: %{name}
Version: %{version}
Release: 1
Summary: Improve your security and privacy by blocking ads, tracking and malware domains

License: MIT
URL: https://github.com/hectorm/hblock
Source0: %{name}.tar

BuildArch: noarch
BuildRequires: make
BuildRequires: idn2
BuildRequires: systemd
Requires: (curl or wget)

%description
hBlock is a POSIX-compliant shell script that gets a list of domains that serve
ads, tracking scripts and malware from multiple sources and creates a hosts
file, among other formats, that prevents your system from connecting to them.

%prep
%setup -c

%install
%make_install prefix="%{_prefix}" bindir="%{_bindir}" mandir="%{_mandir}" unitdir="%{_unitdir}"

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
