#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC2012
image=$(ls "$HOME"/Downloads/*.uf2 --sort time | head -n1)
image_mtime=$(stat "$image" --format "%y")

echo "flashing $image, last modified $image_mtime"

read -rp "is this correct? (y/n) "
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

echo "prompting sudo password once to avoid needing to type it again"
sudo true

wait_until_present() {
  local file="$1"
  local side_descr="$2"
  local keys="$3"

  while [ ! -e "$file" ]; do
    echo "Glove80 $side_descr not connected, re-start it with $keys pressed"
    sleep 5
  done

  echo "$side_descr is connected"
}

flash_side() {
  local disk="$1"
  local side_descr="$2"

  if [ ! -e "$disk" ]; then
  	echo "$disk is missing, boot the glove80 while pressing PgDn+I"
	  exit 1
  fi

  local mountpoint
  mountpoint=$(mktemp -d)

  echo "mounting $disk at $mountpoint" 
  sudo mount "$disk" "$mountpoint"
  echo "copying $image to $side_descr"
  sudo cp "$image" "$mountpoint/CURRENT.UF2"
  echo "done flashing $side_descr"
}

wait_and_flash() {
  local side_shorthand="$1"
  local side_descr="$2"
  local keys="$3"
  
  local disk="/dev/disk/by-label/GLV80${side_shorthand}BOOT"

  wait_until_present "$disk" "$side_descr" "$keys"
  flash_side "$disk" "$side_descr"
}

wait_and_flash "RH" "right-hand side" "PgDn+I"
wait_and_flash "LH" "left-hand side" "Magic+E"

echo "done flashing!"
