# Maintainer: Héctor Molinero Fernández <hector@molinero.dev>
pkgname='hblock'
pkgver='m4_esyscmd(printf -- '%s' "${PKG_VERSION?}")'
pkgrel='0'
pkgdesc='An adblocker that creates a hosts file from automatically downloaded sources'
url='https://github.com/hectorm/hblock'
arch='noarch'
license='MIT'
depends='curl'
makedepends='make'
checkdepends='libidn2'
subpackages="${pkgname:?}-doc"
source="${pkgname:?}-${pkgver:?}.tar.gz"

check() {
  make test
}

package() {
  make DESTDIR="${pkgdir:?}" prefix="/usr" install
}
