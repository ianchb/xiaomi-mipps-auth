#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
set -e

src_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
pkg_src="$src_dir"
work=${TMPDIR:-/tmp}/xiaomi-mipps-auth-deb
pkg=$work/pkg
out=${1:-$work/xiaomi-mipps-auth_0.21_arm64.deb}

rm -rf "$work"
mkdir -p "$pkg/DEBIAN"
mkdir -p "$pkg/usr/libexec"
mkdir -p "$pkg/usr/lib/systemd/system"
mkdir -p "$pkg/usr/lib/udev/rules.d"

cp -a "$pkg_src/DEBIAN/." "$pkg/DEBIAN/"
install -m 0755 "$src_dir/xiaomi-mipps-auth" "$pkg/usr/libexec/xiaomi-mipps-auth"
install -m 0644 "$pkg_src/xiaomi-mipps-auth.service" "$pkg/usr/lib/systemd/system/xiaomi-mipps-auth.service"
install -m 0644 "$pkg_src/90-xiaomi-mipps-auth.rules" "$pkg/usr/lib/udev/rules.d/90-xiaomi-mipps-auth.rules"
chmod 0755 "$pkg/DEBIAN/postinst" "$pkg/DEBIAN/postrm"

mkdir -p "$(dirname -- "$out")"
dpkg-deb --build --root-owner-group "$pkg" "$out"
printf '%s\n' "$out"
