PRODUCT_BRAND ?= omni

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
OMNI_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
OMNI_PRODUCT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# general properties
OMNI_PRODUCT_PROPERTIES += \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.build.selinux=1 \
    persist.sys.disable_rescue=true

# Google assistant
OMNI_PRODUCT_PROPERTIES += \
    ro.opa.eligible_device=true

# Tethering - allow without requiring a provisioning app
# (for devices that check this)
OMNI_PRODUCT_PROPERTIES += \
    net.tethering.noprovisioning=true

# Enforce privapp-permissions whitelist
OMNI_PRODUCT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/bin/clean_cache.sh:system/bin/clean_cache.sh

# Backup Tool
ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/omni/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/omni/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh \
    vendor/omni/prebuilt/addon.d/69-gapps.sh:system/addon.d/69-gapps.sh
else
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/omni/prebuilt/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/omni/prebuilt/bin/blacklist:system/addon.d/blacklist
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/sysconfig/backup.xml:system/etc/sysconfig/backup.xml

# Init script file with omni extras
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/init.local.rc:system/etc/init/init.omni.rc

# Enable SIP and VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

#permissions
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/permissions/privapp-permissions-omni.xml:system/etc/permissions/privapp-permissions-omni.xml \
    vendor/omni/prebuilt/etc/permissions/privapp-permissions-elgoog.xml:system/etc/permissions/privapp-permissions-elgoog.xml \
    vendor/omni/prebuilt/etc/permissions/omni-power-whitelist.xml:system/etc/permissions/omni-power-whitelist.xml

# default sounds
OMNI_PRODUCT_PROPERTIES += \
    ro.config.ringtone=The_big_adventure.ogg,The_big_adventure.ogg \
    ro.config.notification_sound=Beginning.ogg \
    ro.config.alarm_alert=Bright_morning.ogg

# mkshrc
#PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/mkshrc:system/etc/mkshrc

# whitelist packages for location providers not in system
OMNI_PRODUCT_PROPERTIES += \
    ro.services.whitelist.packagelist=com.google.android.gms

# Additional packages
-include vendor/omni/config/packages.mk

# Versioning
-include vendor/omni/config/version.mk

# Themed bootanimation
TARGET_MISC_BLOCK_OFFSET ?= 0
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.misc.block.offset=$(TARGET_MISC_BLOCK_OFFSET)
PRODUCT_PACKAGES += \
    misc_writer_system \
    themed_bootanimation

# Add our overlays
DEVICE_PACKAGE_OVERLAYS += vendor/omni/overlay/common

# Long Screenshot
PRODUCT_PACKAGES += \
    StitchImage

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED := false
ifeq ($(TARGET_GAPPS_ARCH),arm64)
ifneq ($(TARGET_DISABLE_ALTERNATIVE_FACE_UNLOCK), true)
PRODUCT_PACKAGES += \
    FaceUnlockService
TARGET_FACE_UNLOCK_SUPPORTED := true
endif
endif
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.moto_unlock_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

# GApps
include vendor/gapps/config.mk

# Pixel Style
include vendor/pixelstyle/config.mk
