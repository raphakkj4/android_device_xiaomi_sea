#
# Copyright (C) 2026 The YgorBRxx Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from generic device
$(call inherit-product, device/xiaomi/sea/device.mk)

# Include GApps. The path to the gapps blobs may be different, check the vendor/gapps/arm64/Android.mk file and adjust accordingly.
# $(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)

# Gapps
WITH_GMS := true

# Device props
TARGET_SUPPORTS_BLUR := true
TARGET_SUPPORTS_QUICK_TAP := true
TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_DISABLE_EPPE := true
TARGET_SUPPORTS_NEXT_GEN_ASSISTANT := true
TARGET_SUPPORTS_OMX_SERVICE := false

PRODUCT_DEVICE := sea
PRODUCT_NAME := lineage_sea
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := ocean
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_SYSTEM_NAME := ocean_global
PRODUCT_SYSTEM_DEVICE := ocean

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="missi-user 15 AP3A.240905.015.A2 OS2.0.212.0.VHZMIXM release-keys" \
    BuildFingerprint=Redmi/ocean_global/ocean:15/AP3A.240905.015.A2/OS2.0.212.0.VHZMIXM:user/release-keys \
    DeviceName=$(PRODUCT_SYSTEM_DEVICE) \
    DeviceProduct=$(PRODUCT_SYSTEM_NAME) \
    ProductModel=$(PRODUCT_SYSTEM_DEVICE) \
    DeviceProduct=$(PRODUCT_SYSTEM_NAME)
