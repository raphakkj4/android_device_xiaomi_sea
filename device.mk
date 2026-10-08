#
# Copyright (C) 2026 The YgorBRxx Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/sea

# Inherit launch_with_vendor_ramdisk product
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Inherit common MediaTek IMS
$(call inherit-product, vendor/mediatek/ims/ims.mk)

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# A/B
PRODUCT_PACKAGES += \
    com.android.hardware.boot \
    android.hardware.boot-service.default_recovery

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

PRODUCT_PACKAGES += \
    create_pl_dev \
    create_pl_dev.recovery

# API levels
PRODUCT_SHIPPING_API_LEVEL := 33

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Rootdir
PRODUCT_PACKAGES += \
    init.insmod.sh \
    init.pstore_blk.sh

# Init
PRODUCT_PACKAGES += \
    fstab.emmc \
    factory_init.connectivity.common.rc \
    factory_init.connectivity.rc \
    factory_init.project.rc \
    factory_init.rc \
    init.ago.rc \
    init.cgroup.rc \
    init.connectivity.common.rc \
    init.connectivity.rc \
    init.modem.rc \
    init.mt6781.rc \
    init.mt6781.usb.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.sea.power.rc \
    init.sensor_1_0.rc \
    init.stnfc.rc \
    init_connectivity.rc \
    meta_init.connectivity.common.rc \
    meta_init.connectivity.rc \
    meta_init.modem.rc \
    meta_init.project.rc \
    meta_init.rc \
    meta_init.vendor.rc \
    init.recovery.mt6781.rc \
    fstab.mt6781 \
    fstab.mt6781.vendor_ramdisk

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.emmc:$(TARGET_VENDOR_RAMDISK_OUT)/first_stage_ramdisk/fstab.emmc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/mediatek \
    hardware/xiaomi \
    hardware/mediatek/libaedv \
    hardware/mediatek/wlan/wifi_hal

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Configstore
PRODUCT_PACKAGES += \
    disable_configstore

# Control groups/Task profiles
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/cgroups_30.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json \
    system/core/libprocessgroup/profiles/task_profiles_30.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# DTB
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)-prebuilt/dtb.img:dtb.img \
    $(LOCAL_PATH)-prebuilt/kernel:kernel

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint-service.xiaomi

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/uinput-fpc.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput-fpc.kl \
    $(LOCAL_PATH)/configs/keylayout/uinput-goodix.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput-goodix.kl

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore.km41.xml

# Libshim
PRODUCT_PACKAGES += \
    libbase_shim

PRODUCT_PACKAGES += \
    FrameworksOverlaySea \
    TetheringConfigOverlay \
    SettingsOverlaySea \
    SystemUIOverlaySea \
    WifiOverlaySea

PRODUCT_PACKAGES += \
    NcmTetheringOverlay

PRODUCT_PACKAGES += \
    LineageApertureOverlayYgorBRxx \
    LineageDialerYgorBRxx \
    LineageLauncher3OverlayYgorBRxx \
    LineageSDKOverlayYgorBRxx \
    LineageSettingsOverlayYgorBRxx \
    PowerOffAlarmOverlayYgorBRxx

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2025-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2025-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_4.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ksrn/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ksrn/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ksrn/android.hardware.nfc.uicc.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ksrn/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ksrn/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnel_migration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnel_migration.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

# Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service.ygorbrxx


# Extra files
TARGET_USES_VULKAN := true
TARGET_EXCLUDES_AUDIOFX := true

# DRM (Clearkey)
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth-service.mediatek

PRODUCT_PACKAGES += \
    audio.primary.default \
    audio.r_submix.default \
    audio_policy.stub \
    audio.usb.default

PRODUCT_PACKAGES += \
    audio.bluetooth.default

PRODUCT_PACKAGES += \
    libaecsw \
    libagc1sw \
    libagc2sw \
    libbassboostsw \
    libbundleaidl \
    libdownmixaidl \
    libdynproc \
    libdynamicsprocessingaidl \
    libequalizersw \
    libenvreverbsw \
    libhapticgenerator \
    libhapticgeneratoraidl \
    libloudnessenhanceraidl \
    libnssw \
    libpreprocessingaidl \
    libpresetreverbsw \
    libreverbaidl \
    libspatializersw \
    libvibratorutils \
    libvirtualizersw \
    libvisualizeraidl \
    libvolumesw \
    libextensioneffect

PRODUCT_PACKAGES += \
    MtkInCallService

# ConsumerIR
PRODUCT_PACKAGES += \
    android.hardware.ir-service.example

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.mediatek \
    android.hardware.usb.gadget-service.mediatek

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.example \
    android.hardware.health-service.example_recovery

# Lights
$(call soong_config_set_bool,lineagelight,scan_for_backlight_devices,$(TARGET_LIGHT_HAL_SCAN_FOR_BACKLIGHT_DEVICES))
PRODUCT_PACKAGES += \
    android.hardware.light-service.lineage

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/displayconfig/common_multi_factor_thermal_brightness_control.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/displayconfig/common_multi_factor_thermal_brightness_control.xml \
    $(LOCAL_PATH)/configs/displayconfig/display_id_4627039422300187648.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/displayconfig/display_id_4627039422300187648.xml

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.xiaomi-multihal \
    android.hardware.sensors@2.0-subhal-impl-1.0 \
    sensors.dynamic_sensor_hal

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.mediatek \
    thermal_symlinks_mediatek

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.st \
    com.android.nfc_extras \
    Tag

# WiFi
PRODUCT_CFI_INCLUDE_PATHS += hardware/mediatek/wlan/wpa_supplicant_8_lib
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    wpa_supplicant \
    libwifi-hal-wrapper

# Inherit the proprietary files
$(call inherit-product, vendor/xiaomi/sea/sea-vendor.mk)
