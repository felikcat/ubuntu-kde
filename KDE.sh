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

PKGS=(kubuntu-* ubuntu-deskto* plasma-desktop kde-full kde-standard kde-baseapps)
_pkgs_remove
apt autoremove -y

#
# sddm, sddm-theme-breeze: KDE's default login manager and the default theme for it.
# plasma-desktop: KDE itself, the minimalist version for Ubuntu.
# plasma-workspace-wayland: Wayland support.
# libdecor-0-0, qtwayland5, qt6-wayland: Run more programs in Wayland instead of Xorg.
# kde-spectacle: Screenshot Utility.
# ufw: A firewall suitable for hosting purposes.
# konsole: Terminal Emulator.
# xdg-desktop-portal-gnome: Required to launch some Flatpaks, such as Telegram Desktop.
# gnome-keyring, gnome-keyring-pkcs11, libnotify-bin: Firefox (non Flatpak version) requires this for keyring support.
#
# dolphin: File browser.
# -> ark: File archive support, such as Zip and 7z.
# -> ffmpegthumbs: Video thumbnail support.
# -> kimageformat-plugins, qt5-image-formats-plugins: Support for various image formats; https://api.kde.org/frameworks/kimageformats/html/index.html
# -> libjxl0.7: JPEG XL support.
# -> libpackagekitqt5-1: Required for "Configure > Configure Dolphin > Context Menu > Download New Services".
# -> libtag1v5: Audio metadata support.
# -> meld: "Compare files" support.
# -> unrar: Unarchiving .rar file support.
#
# noto-fonts-*: The best supported fonts for making sure characters don't display as blank boxes.
# gnome-logs: To better your ability to tell what's going on with your Linux PC.
# systemd-oomd: Better Out Of Memory killing behavior.
# gamemode: Automatic system tuning to maximum performance when used to run a process or game.
#
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
