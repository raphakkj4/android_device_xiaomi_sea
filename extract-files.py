#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.file import File
from extract_utils.fixups_blob import (
    BlobFixupCtx,
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)
from extract_utils.tools import (
    llvm_objdump_path,
)
from extract_utils.utils import (
    run_cmd,
)

namespace_imports = [
	'device/xiaomi/sea',
	'hardware/mediatek',
	'hardware/xiaomi',
    'hardware/mediatek/libmtkperf_client',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'libformatter': lib_fixup_vendor_suffix,
}

blob_fixups: blob_fixups_user_type = {
    ('vendor/etc/init/vendor.mediatek.hardware.pq_aidl-service.rc'): blob_fixup()
        .regex_replace(
            'service vender\\.mediatek\\.hardware\\.pq_aidl-default',
            'service vendor.mediatek.hardware.pq_aidl-default',
        )
        .regex_replace(
            'interface aidl vendor\\.mediatek\\.hardware\\.pq_aidl-service',
            'interface aidl vendor.mediatek.hardware.pq_aidl.IPictureQuality_AIDL/default',
        ),

    (
        'vendor/lib/libpqtuning.so',
        'vendor/lib64/libpqtuning.so',
        'vendor/lib/mt6781/libdpframework.so',
        'vendor/lib64/mt6781/libdpframework.so',
    ): blob_fixup()
        .replace_needed('libpqsharememory.so', 'libpqsharememory_mtk.so'),

    ('vendor/lib64/libaalservice.so', 'vendor/lib64/libcam.utils.sensorprovider.so'): blob_fixup()
        .replace_needed('libsensorndkbridge.so', 'android.hardware.sensors@1.0-convert-shared.so')
        .replace_needed('android.hardware.sensors-V2-ndk.so', 'android.hardware.sensors-V1-ndk.so')
        .replace_needed('android.hardware.sensors-V1-ndk.so', 'android.hardware.sensors-V3-ndk.so'),

    (
        'vendor/lib/hw/displayfeature.default.so',
        'vendor/lib64/hw/displayfeature.default.so',
        'vendor/lib/libpqxmlparser.so',
        'vendor/lib64/libpqxmlparser.so',
        'vendor/lib/librt_extamp_intf.so',
        'vendor/lib64/librt_extamp_intf.so',
        'vendor/lib64/libsilkybrightnesscore.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),

    ('vendor/lib/libaalservice.so'): blob_fixup()
        .replace_needed('android.hardware.sensors-V2-ndk.so', 'android.hardware.sensors-V3-ndk.so'),

    ('vendor/bin/mnld'): blob_fixup()
        .replace_needed('libsensorndkbridge.so', 'android.hardware.sensors@1.0-convert-shared.so')
        .replace_needed('android.hardware.sensors-V2-ndk.so', 'android.hardware.sensors-V3-ndk.so')
        .replace_needed('libmnl.so', 'libmnl_mtk.so'),

    (
        'vendor/lib/egl/libGLES_mali.so',
        'vendor/lib64/egl/libGLES_mali.so',
        'vendor/lib/hw/android.hardware.graphics.allocator-V2-mediatek.so',
        'vendor/lib64/hw/android.hardware.graphics.allocator-V2-mediatek.so',
        'vendor/lib/hw/mapper.mediatek.so',
        'vendor/lib64/hw/mapper.mediatek.so',
        'vendor/lib/libcodec2_fsr.so',
        'vendor/lib64/libcodec2_fsr.so',
        'vendor/lib/libgpud.so',
        'vendor/lib64/libgpud.so',
        'vendor/lib/libmtkcam_grallocutils.so',
        'vendor/lib64/libmtkcam_grallocutils.so',
        'vendor/lib/vendor.mediatek.hardware.pq_aidl-V2-ndk.so',
        'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V2-ndk.so',
        'vendor/lib/vendor.mediatek.hardware.pq_aidl-V4-ndk.so',
        'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V4-ndk.so',
        'vendor/lib64/libaimemc.so',
        'vendor/lib64/vendor.mediatek.hardware.camera.isphal-V1-ndk.so',
        'vendor/bin/hw/android.hardware.graphics.allocator-V2-service-mediatek'
    ): blob_fixup()
        .replace_needed('android.hardware.graphics.common-V5-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),

    (
        'vendor/lib64/hw/vendor.mediatek.hardware.pq_aidl-impl.so',
        'vendor/lib/hw/vendor.mediatek.hardware.pq_aidl-impl.so',
        'vendor/lib64/hw/audio.primary.mt6781.so',
        'vendor/lib/hw/audio.primary.mt6781.so'
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),

    ('vendor/bin/hw/android.hardware.audio.service-aidl.mediatek'): blob_fixup()
        .replace_needed('libaudio_aidl_conversion_common_ndk.so', 'libaudio_aidl_conversion_common_ndk_prebuilt.so'),

    ('vendor/lib/hw/android.hardware.audio.effect.aidl-impl-mediatek.so', 'vendor/lib64/hw/android.hardware.audio.effect.aidl-impl-mediatek.so'): blob_fixup()
        .replace_needed('android.media.audio.common.types-V5-ndk.so', 'android.media.audio.common.types-V3-ndk.so')
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),

    ('vendor/lib/android.hardware.audio.core-impl-mediatek.so', 'vendor/lib64/android.hardware.audio.core-impl-mediatek.so'): blob_fixup()
        .add_needed('libaudioutils_shim.so')
        .replace_needed('libaudio_aidl_conversion_common_ndk.so', 'libaudio_aidl_conversion_common_ndk_prebuilt.so'),

    ('vendor/lib/libaudio_aidl_conversion_common_ndk_prebuilt.so', 'vendor/lib64/libaudio_aidl_conversion_common_ndk_prebuilt.so'): blob_fixup()
        .replace_needed('android.media.audio.common.types-V5-ndk.so', 'android.media.audio.common.types-V3-ndk.so'),
    
    ('vendor/lib/hw/android.hardware.soundtrigger3-impl.so', 'vendor/lib64/hw/android.hardware.soundtrigger3-impl.so'): blob_fixup()
        .replace_needed('libaudio_aidl_conversion_common_ndk.so', 'libaudio_aidl_conversion_common_ndk_prebuilt.so'),

    ('vendor/lib/libsensorndkbridge.so', 'vendor/lib64/libsensorndkbridge.so'): blob_fixup()
        .replace_needed('android.hardware.sensors-V2-ndk.so', 'android.hardware.sensors-V3-ndk.so'),

    ('vendor/lib/vendor.mediatek.hardware.pq_aidl-V7-ndk.so', 'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V7-ndk.so'): blob_fixup()
        .replace_needed('android.hardware.graphics.common-V4-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),

    ('vendor/lib64/libmtkcam_hal_aidl_common.so'): blob_fixup()
        .replace_needed('android.hardware.camera.common-V2-ndk.so', 'android.hardware.camera.common-V1-ndk.so'),

    ('vendor/lib64/hw/hwcomposer.mtk_common.so'): blob_fixup()
        .add_needed('libprocessgroup_shim.so')
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),

    ('vendor/lib/libteei_daemon_vfs.so', 'vendor/lib64/libteei_daemon_vfs.so'): blob_fixup()
        .add_needed('liblog.so'),

    ('vendor/bin/hw/android.hardware.contexthub-service.tinysys'): blob_fixup()
        .replace_needed('android.hardware.contexthub-V3-ndk.so', 'android.hardware.contexthub-V5-ndk.so'),
        
    ('vendor/bin/hw/android.hardware.memtrack-service.mediatek'): blob_fixup()
        .replace_needed('android.hardware.memtrack-V1-ndk.so', 'android.hardware.memtrack-V1-ndk_prebuilt.so'),

    ('vendor/bin/hw/mtkfusionrild'): blob_fixup()
        .add_needed('libutils-v33.so'),

    ('vendor/lib/mt6781/libneuron_adapter_mgvi.so', 'vendor/lib64/mt6781/libneuron_adapter_mgvi.so'): blob_fixup()
        .add_needed('libz.so')
        .add_needed('liblog.so')
        .add_needed('libnativewindow.so')
        .clear_symbol_version('AHardwareBuffer_allocate')
        .clear_symbol_version('AHardwareBuffer_createFromHandle')
        .clear_symbol_version('AHardwareBuffer_describe')
        .clear_symbol_version('AHardwareBuffer_getNativeHandle')
        .clear_symbol_version('AHardwareBuffer_lock')
        .clear_symbol_version('AHardwareBuffer_release')
        .clear_symbol_version('AHardwareBuffer_unlock'),

    ('vendor/lib64/libalLDC.so', 'vendor/lib64/libalhLDC.so', 'vendor/lib64/libneuralnetworks_sl_driver_mtk_legacy_prebuilt.so'): blob_fixup()
        .clear_symbol_version('AHardwareBuffer_allocate')
        .clear_symbol_version('AHardwareBuffer_createFromHandle')
        .clear_symbol_version('AHardwareBuffer_describe')
        .clear_symbol_version('AHardwareBuffer_getNativeHandle')
        .clear_symbol_version('AHardwareBuffer_lock')
        .clear_symbol_version('AHardwareBuffer_release')
        .clear_symbol_version('AHardwareBuffer_unlock'),
}

module = ExtractUtilsModule(
    'sea',
    'xiaomi',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
