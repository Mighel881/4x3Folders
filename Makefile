INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = armv7 armv7s arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 4x3Folders

4x3Folders_FILES = 4x3folders.x
4x3Folders_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
