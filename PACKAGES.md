## Packages

### Arch Linux

A package for Arch Linux users is [available in the Arch User Repository (AUR)](https://aur.archlinux.org/packages/hblock/).

Use your favorite [AUR helper](https://wiki.archlinux.org/index.php/AUR_helpers) to perform the installation.

### DragonFlyBSD

A package for DragonFlyBSD users is [available in DPorts](https://github.com/DragonFlyBSD/DPorts/tree/master/net/hblock/).

```sh
pkg install hblock
```

### FreeBSD

A package for FreeBSD users is [available in FreshPorts](https://www.freshports.org/net/hblock/).

```sh
pkg install hblock
```

### Gentoo

A package for Gentoo users is [available in the `src_prepare` overlay](https://gitlab.com/src_prepare/src_prepare-overlay/-/tree/master/net-firewall/hblock/).

 * Add the `src_prepare` overlay with the help of the [official repository](https://gitlab.com/src_prepare/src_prepare-overlay#adding-the-overlay).
 * Unmask the `net-firewall/hblock` package with the help of the [Gentoo wiki](https://wiki.gentoo.org/wiki/Knowledge_Base:Unmasking_a_package).
 * Install the package through Portage:

   ```sh
   emerge --verbose net-firewall/hblock
   ```

### Haiku OS

A package for Haiku OS users is [available in HaikuPorts](https://github.com/haikuports/haikuports/tree/master/net-firewall/hblock).

```sh
pkgman install hblock
```

### macOS

A package for macOS users is [available in Homebrew](https://formulae.brew.sh/formula/hblock).

```sh
brew install hblock
```

### Node.js

A package for Node.js users is [available in npm](https://www.npmjs.com/package/hblock).

```sh
npm install -g hblock
```
or
```sh
npx hblock
```
