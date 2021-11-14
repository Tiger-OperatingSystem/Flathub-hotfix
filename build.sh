#!/bin/bash

[ ! "${EUID}" = "0" ] && {
  echo "Execute esse script como root:"
  echo
  echo "  sudo ${0}"
  echo
  exit 1
}

HERE="$(dirname "$(readlink -f "${0}")")"

working_dir=$(mktemp -d)

mkdir -p "${working_dir}/var/lib/flatpak/repo"
mkdir -p "${working_dir}/DEBIAN/"

(
  cd "${working_dir}/var/lib/flatpak/repo"
  mkdir -p extensions objects refs state tmp
)

cp -v "${HERE}/config" "${HERE}/flathub.trustedkeys.gpg" "${working_dir}/var/lib/flatpak/repo"

(
 echo "Package: flathub-hotfix"
 echo "Priority: optional"
 echo "Version: 1.0"
 echo "Architecture: all"
 echo "Maintainer: Natanael Barbosa Santos"
 echo "Depends: "
 echo "Description: $(cat ${HERE}/README.md  | sed -n '1p')"
 echo
) > "${working_dir}/DEBIAN/control"

dpkg -b ${working_dir}
rm -rfv ${working_dir}

mv "${working_dir}.deb" "${HERE}/Flathub-hotfix.deb"

chmod 777 "${HERE}/Flathub-hotfix.deb"
chmod -x  "${HERE}/Flathub-hotfix.deb"
