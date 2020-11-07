# Maintainer: Héctor Molinero Fernández <hector@molinero.dev>
pkgname='hblock'
pkgver='m4_esyscmd(printf -- '%s' "${PKG_VERSION?}")'
pkgrel='1'
pkgdesc='An adblocker that creates a hosts file from automatically downloaded sources'
arch=('any')
url='https://github.com/hectorm/hblock'
license=('MIT')
depends=('bash' 'curl')
checkdepends=('libidn2')
source=("${pkgname:?}-${pkgver:?}.tar.gz")
sha256sums=('SKIP')

check() {
  cd -- "${pkgname:?}-${pkgver:?}"
  make test
}

package() {
  cd -- "${pkgname:?}-${pkgver:?}"
  make DESTDIR="${pkgdir:?}" prefix="/usr" install
}
