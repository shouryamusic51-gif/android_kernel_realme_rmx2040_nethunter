# Kali NetHunter Kernel for Realme Narzo 10 / 6i (RMX2040)

A custom **Linux 4.14.186** Kali NetHunter kernel for the **Realme Narzo 10 / Realme 6i (`RMX2040`, MediaTek Helio G80 / MT6768 / oppo6769)**, compiled natively on ARM64 with **Clang 11.0.1** and **LLD 11.0.1**.

> **Tested OS:** Realme UI 2.0 (Android 11), Magisk rooted
> **Disclaimer:** Flashing custom kernels carries risk. Always back up your stock `boot` partition before flashing.

---

## Features & Supported Hardware

### Core System & Vendor Compatibility
- **100% Stock Vendor Module Compatibility:** Keeps `CONFIG_MODVERSIONS=y` and `4.14.186` vermagic so all stock `/vendor/lib/modules/*.ko` (`wlan_drv_gen4m.ko`, `wmt_chrdev_wifi.ko`, `bt_drv.ko`, `wmt_drv.ko`, `gps_drv.ko`, `fmradio_drv.ko`, `fpsgo.ko`, `udc_lib.ko`) load cleanly at boot.
- **Built-in Wi-Fi, Bluetooth, GPS, FM Radio, Camera, and Audio:** All work out of the box.

### Kali NetHunter Features
- **Wi-Fi Monitor Mode & Packet Injection:** Includes `mac80211` injection patch (`add-wifi-injection-4.14.patch`).
- **Bluetooth Arsenal (USB Dongles):** `CONFIG_BT_HCIBTUSB=y` with TP-Link UB500 patch (`add-ub500-to-btusb.patch`), `CONFIG_BT_RFCOMM=y`, and `CONFIG_BT_HIDP=y`.
- **USB Gadgets (ConfigFS):**
  - HID Keyboard & Mouse (`CONFIG_USB_CONFIGFS_F_HID=y`) for BadUSB / DuckHunter attacks (`/dev/hidg0` / `/dev/hidg1`).
  - USB Mass Storage (`CONFIG_USB_CONFIGFS_MASS_STORAGE=y`) for DriveDroid / ISO mounting.
- **Networking & Tunneling:** `CONFIG_TUN=y` (`/dev/tun`, `/dev/net/tun`).

### Built-in External USB Wi-Fi Drivers (OTG)
Compiled directly into `Image` (no external `.ko` loading needed):

| Chipset / Driver | Kernel Option | Example Adapters |
| :--- | :--- | :--- |
| Realtek `RTL8812AU / 8821AU / 8814AU` | `CONFIG_88XXAU=y` | ALFA AWUS036ACH, AWUS036ACS |
| Realtek `RTL8188EU / RTL8188EUS / RTL8192CU / RTL8723BU` | `CONFIG_RTL8XXXU=y` | TP-Link TL-WN722N v2/v3 (RTL8188EUS) |
| Atheros `AR9271` | `CONFIG_ATH9K_HTC=y` | TP-Link TL-WN722N v1, ALFA AWUS036NHA |
| Ralink `RT2800USB` (`RT33XX/35XX/53XX/55XX`) | `CONFIG_RT2800USB=y` | Ralink RT3070 / RT5370 / RT5572 adapters |
| MediaTek `MT7601U` | `CONFIG_MT7601U=y` | Generic MT7601U USB Wi-Fi dongles |
| Realtek `RTL8187` | `CONFIG_RTL8187=y` | ALFA AWUS036H |

---

## Before You Flash (Mandatory Backup)

Back up your current working `boot` partition in a rooted Android Shell (`su`):

```bash
dd if=/dev/block/by-name/boot of=/sdcard/narzo10-stock-boot.img
```

---

## Flashing Instructions

Download the files from the **Releases** tab of this repository.

### Method 1: Universal Repack (Recommended for Any Firmware Version)
Use `narzo_nh_Image_v2` with your own `narzo10-stock-boot.img` so your exact firmware's `dtb`, ramdisk, and Magisk root are preserved:

```bash
mkdir -p /data/local/tmp/repack_narzo && cd /data/local/tmp/repack_narzo
cp /sdcard/narzo10-stock-boot.img .
/data/adb/magisk/magiskboot unpack narzo10-stock-boot.img
cp /sdcard/narzo_nh_Image_v2 kernel
/data/adb/magisk/magiskboot repack narzo10-stock-boot.img /sdcard/narzo10-nh-v2-boot.img
```

Flash via **Fastboot** (or TWRP **Install Image -> Boot**):
```bash
fastboot flash boot narzo10-nh-v2-boot.img
fastboot reboot
```

### Method 2: Direct Flash (`narzo10-nh-v2-boot.img`)
*(For matching Realme UI 2.0 Android 11 firmware with Magisk)*
```bash
fastboot flash boot narzo10-nh-v2-boot.img
fastboot reboot
```

---

## Enabling USB HID (`/dev/hidg*`) on Realme UI 2.0

If NetHunter USB Arsenal reports `Failed to set USB function` on Realme UI 2.0, bind `hid.0` via ConfigFS in **Android Shell (`su`)**:

```bash
setprop sys.usb.config none
sleep 1
echo "" > /config/usb_gadget/g1/UDC
ln -s /config/usb_gadget/g1/functions/hid.0 /config/usb_gadget/g1/configs/b.1/f1
echo "musb-hdrc" > /config/usb_gadget/g1/UDC
ln -sf /dev/hidg1 /dev/hidg0
```

---

## Building from Source (ARM64 / Linux)

```bash
git clone https://github.com/shouryamusic51-gif/android_kernel_realme_rmx2040_nethunter.git
cd android_kernel_realme_rmx2040_nethunter
./build_local.sh
```
The compiled kernel is generated at `out/arch/arm64/boot/Image`.

---

## Credits
- **Realme Open Source** (`realme-kernel-opensource`) for the `RMX2040` kernel source
- **Kali NetHunter** (`kali-nethunter-kernel`) for the 4.14 patches and drivers
- **Magisk** (`magiskboot`) for on-device boot image unpacking/repacking
￼Enter
