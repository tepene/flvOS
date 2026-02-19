#!/usr/bin/env bash

set -eoux pipefail

# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh
# shellcheck source=/dev/null
source /ctx/build/font-helpers.sh

echo "::group:: Install Desktop Packages"

# Install niri, greetd, waybar and dependencies
dnf5 install --setopt=install_weak_deps=False -y \
  greetd \
  greetd-selinux \
  niri \
  gnome-keyring \
  xdg-desktop-portal-gnome \
  xwayland-satellite \
  mako \
  waybar \
  swaybg \
  swayidle \
  fuzzel \
  nwg-bar \
  nm-connection-editor \
  rofi-wayland \
  qrencode \
  blueman \
  pavucontrol \
  xdg-terminal-exec \
  btop

copr_install_isolated "avengemedia/danklinux" dms-greeter
copr_install_isolated "solopasha/hyprland" hyprlock uwsm
copr_install_isolated "scottames/ghostty" ghostty

# HyprLTM-Net | https://github.com/hyprltm/hyprltm-net/blob/stable/README.md#-installation
echo "Installing HyprLTM-Net..."
hyprltm_net_tmp_dir=$(mktemp -d -t hyprltm-net-XXXXXX)
hyprltm_net_bin_dir="/usr/bin"
rofi_themes_dir="/etc/xdg/rofi/themes"

mkdir -p "${rofi_themes_dir}"
git clone https://github.com/hyprltm/hyprltm-net.git "${hyprltm_net_tmp_dir}"
## Fallback to custom-build
# git clone --branch fork/custom-build --single-branch https://github.com/tepene/hyprltm-net.git "${hyprltm_net_tmp_dir}"
cp "${hyprltm_net_tmp_dir}/hyprltm-net.sh" "${hyprltm_net_bin_dir}/hyprltm-net"
chmod +x "${hyprltm_net_bin_dir}/hyprltm-net"
cp "${hyprltm_net_tmp_dir}"/*.rasi "${rofi_themes_dir}"

# dmenu-bluetooth | https://github.com/Layerex/dmenu-bluetooth
echo "Installing dmenu_bluetooth..."
dmenu_bluetooth_bin_dir="/usr/bin"
curl -L "https://raw.githubusercontent.com/Layerex/dmenu-bluetooth/master/dmenu-bluetooth" -o "${dmenu_bluetooth_bin_dir}/dmenu-bluetooth"
chmod +x "${dmenu_bluetooth_bin_dir}/dmenu-bluetooth"

# Delete unwanted application launchers
find /usr/share/applications -type f -name "rofi*.desktop" -delete

# Fonts
install_fonts "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/NerdFontsSymbolsOnly.zip"

# Enable services
systemctl enable greetd
systemctl --global enable app-com.mitchellh.ghostty.service

# Create user service integration for niri
mkdir -p /etc/systemd/user/niri.service.wants
ln -s /usr/lib/systemd/user/mako.service /etc/systemd/user/niri.service.wants/mako.service
ln -s /usr/lib/systemd/user/waybar.service /etc/systemd/user/niri.service.wants/waybar.service
ln -s /usr/lib/systemd/user/swaybg.service /etc/systemd/user/niri.service.wants/swaybg.service
ln -s /usr/lib/systemd/user/swayidle.service /etc/systemd/user/niri.service.wants/swayidle.service

echo "::endgroup::"
