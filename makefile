#
# Makefile for Google Shamrock
#

# The original zip file, MUST be specified by each product
local-zip-file     := stockrom.zip

# The output zip file of MIUI rom, the default is porting_miui.zip if not specified
local-out-zip-file := MIUI_Shamrock.zip

# the location for local-ota to save target-file
local-previous-target-dir := 

# All apps from original ZIP, but has smali files chanded
local-modified-apps := 

local-modified-jars := org.cyanogenmod.platform

# All apks from MIUI
local-miui-removed-apps := BugReport GameCenter FM Mipay MiuiCompass MiuiSuperMarket XiaomiVip MiGameCenterSDKService MiLivetalk MiuiVoip SogouInput SystemAdSolution VoiceAssist XMPass YellowPage Whetstone

local-miui-modified-apps := InCallUI TeleService SecurityCenter

# Config density for co-developers to use the aaps with HDPI or XHDPI resource,
# Default configrations are HDPI for ics branch and XHDPI for jellybean branch
local-density := XXHDPI

PORT_PRODUCT := shamrock_global

# All apps need to be removed from original ZIP file
#local-remove-apps   := 

include phoneapps.mk

# The certificate for release version
local-certificate-dir := security

local-target-bit := 32

# To include the local targets before and after zip the final ZIP file, 
# and the local-targets should:
# (1) be defined after including porting.mk if using any global variable(see porting.mk)
# (2) the name should be leaded with local- to prevent any conflict with global targets
local-pre-zip := local-pre-zip-misc
local-after-zip:= local-put-to-phone

# The local targets after the zip file is generated, could include 'zip2sd' to 
# deliver the zip file to phone, or to customize other actions

include $(PORT_BUILD)/porting.mk

# To define any local-target
#updater := $(ZIP_DIR)/META-INF/com/google/android/updater-script
#pre_install_data_packages := $(TMP_DIR)/pre_install_apk_pkgname.txt
local-pre-zip-misc:
	$(TOOLS_DIR)/post_process_props.py out/ZIP/system/build.prop other/build.prop
	@echo copy files
	cp -a -rf other/system/* $(ZIP_DIR)/system/
	cp -rf other/data/* $(ZIP_DIR)/data/miui/

	@echo goodbye! miui prebuilt binaries!
	rm -rf $(ZIP_DIR)/system/bin/app_process32_vendor
	cp -rf stockrom/system/bin/app_process32 $(ZIP_DIR)/system/bin/app_process32
	
	@echo remove unnecessary blobs!
	rm -rf $(ZIP_DIR)/system/recovery-from-boot.bak
	rm -rf $(ZIP_DIR)/system/etc/CHANGELOG-CM.txt
	rm -rf $(ZIP_DIR)/system/lib64
	rm -rf $(ZIP_DIR)/system/priv-app/priv-app.original
	
	@echo use only miui sounds!
	rm -rf $(ZIP_DIR)/system/media/audio/*
	cp -rf $(PORT_ROOT)/miui/system/media/$(local-density)/audio/* $(ZIP_DIR)/system/media/audio
	rm -rf $(ZIP_DIR)/system/media/audio/create_symlink_for_audio-timestamp

