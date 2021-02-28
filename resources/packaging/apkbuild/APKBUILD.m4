# Maintainer: Héctor Molinero Fernández <hector@molinero.dev>
pkgname='hblock'
pkgver='m4_esyscmd(printf '%s' "${PKG_VERSION?}")'
pkgrel='0'
pkgdesc='Adblocker that creates a hosts file from multiple sources'
url='https://github.com/hectorm/hblock'
arch='noarch'
license='MIT'
depends='curl'
makedepends='make'
subpackages="${pkgname:?}-doc"
source="${pkgname:?}-${pkgver:?}.tar.gz"

check() {
  make test
}

package() {
  make DESTDIR="${pkgdir:?}" prefix="/usr" install
}
