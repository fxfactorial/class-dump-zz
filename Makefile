# -*- makefile -*-
# Still need to do an export for the IP of the specific devices
export THEOS=./theos_fork
export THEOS_PORT=22

# Remember to uncomment this if you plan to use the network rather
# than gandalf to deploy to a specific device instead of deploying to
# all the devices with the deploy target

# export THEOS_DEVICE_IP='10.0.0.36'

# Temporarily turn off -Werror, useful while developing
export GO_EASY_ON_ME=1

# Assuming that we installed the cross compiler via nix, yes this is
# needed because of a ?= in theo's makefiles
SDKBINPATH := ${shell echo "/home/`whoami`/.nix-profile/bin"}
SDKTARGET := armv7-apple-darwin11

# These must come before THEOS's include
override _SDK_DIR := /home/gar/.nix-profile
override _THEOS_PLATFORM_LIPO := armv7-apple-darwin11-lipo

include $(THEOS)/makefiles/common.mk

TOOL_NAME := classdumpzz
classdumpzz_FILES := main.mm

# classdumpzz_PRIVATE_FRAMEWORKS :=

# classdumpzz_CFLAGS := -D_DEBUG -D_DUMP_CLIENT

include $(THEOS_MAKE_PATH)/tool.mk

after-install::
	install.exec "killall -9 itunesstored"

.PHONY: deploy do all

deploy:
	scp -P 2000 .theos/obj/debug/classdumpzz root@localhost:~/
