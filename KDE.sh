#!/bin/bash

_pkgs_add()
{
    if [[ -n ${PKGS} ]]; then
		sudo apt install -y "${PKGS[@]}" || :
	fi
}
_pkgs_remove()
{
    if [[ -n ${PKGS} ]]; then
		sudo apt remove -y "${PKGS[@]}" || :
	fi
}
_config_sddm()
{
	rm -f "/etc/sddm.conf.d/default.conf"
	rm -f "/etc/sddm.conf.d/kubuntu_settings.conf"

	local CONF="/etc/sddm.conf.d/kde_settings.conf"
	kwriteconfig5 --file "${CONF}" --group "Theme" --key "Current" "breeze"
}

apt update

# Comment out _pkgs_remove if this is undesirable!
PKGS=(kubuntu-* ubuntu-deskto* plasma-desktop kde-full kde-standard kde-baseapps)
_pkgs_remove
apt autoremove -y

PKGS=(sddm sddm-theme-breeze libdecor-0-0 qtwayland5 qt6-wayland plasma-desktop kde-spectacle ufw konsole
xdg-desktop-portal-gnome gnome-keyring gnome-keyring-pkcs11 libnotify-bin plasma-workspace-wayland
dolphin kconfig-frontends kde-cli-tools kdegraphics-thumbnailers kimageformat-plugins
qt5-image-formats-plugins ffmpegthumbs libtag1v5 openexr "libjxl0.7" libpackagekitqt5-1 meld
ark unrar fonts-noto-color-emoji fonts-noto-cjk gnome-logs systemd-oomd gamemode flatpak plasma-discover-backend-flatpak
)
_pkgs_add

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

_config_sddm

printf "\nSelect 'bgrt.plymouth' to restore the default Ubuntu bootup logo.\n"
update-alternatives --config default.plymouth

printf "\nKDE.sh finished, it is recommended to reboot.\n"
