PRODUCT_VERSION_MAJOR = 24
PRODUCT_VERSION_MINOR = 0

ifeq ($(LINEAGE_VERSION_APPEND_TIME_OF_DAY),true)
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Set LINEAGE_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef LINEAGE_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "LINEAGE_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^LINEAGE_||g')
        LINEAGE_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# bitDroid: builds are OFFICIAL unless another known type is asked for
ifeq ($(filter OFFICIAL RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(LINEAGE_BUILDTYPE)),)
    LINEAGE_BUILDTYPE := OFFICIAL
    LINEAGE_EXTRAVERSION :=
endif

ifeq ($(LINEAGE_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        LINEAGE_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

LINEAGE_VERSION_SUFFIX := $(LINEAGE_BUILD_DATE)-$(LINEAGE_BUILDTYPE)$(LINEAGE_EXTRAVERSION)-$(LINEAGE_BUILD)

# Internal version
LINEAGE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(LINEAGE_VERSION_SUFFIX)

# DriftVaneOS version
DRIFTVANE_VERSION_MAJOR := 1
DRIFTVANE_VERSION_MINOR := 0
DRIFTVANE_VERSION := $(DRIFTVANE_VERSION_MAJOR).$(DRIFTVANE_VERSION_MINOR)-$(LINEAGE_VERSION_SUFFIX)

# Display version (shown in Settings > About phone)
LINEAGE_DISPLAY_VERSION := bitDroid-$(DRIFTVANE_VERSION)

# LineageOS version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lineage.version=$(LINEAGE_VERSION) \
    ro.lineage.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.lineage.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.lineage.releasetype=$(LINEAGE_BUILDTYPE)

# DriftVaneOS version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.driftvane.version=$(DRIFTVANE_VERSION) \
    ro.driftvane.build.version=$(DRIFTVANE_VERSION_MAJOR).$(DRIFTVANE_VERSION_MINOR) \
    ro.driftvane.base=LineageOS-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)

# DriftVaneOS OTA server (never point at LineageOS's servers)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    lineage.updater.uri=https://raw.githubusercontent.com/bitDroidOS/OTA/main/{device}.json
