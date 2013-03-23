LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := application

APP_SUBDIRS := $(patsubst $(LOCAL_PATH)/%, %, $(shell find $(LOCAL_PATH)/src/ -type d))

LOCAL_CFLAGS := $(foreach D, $(APP_SUBDIRS), -I$(LOCAL_PATH)/$(D)) \
				-I$(LOCAL_PATH)/../include \
				-I$(LOCAL_PATH)/.. \
				-I$(LOCAL_PATH)/../../../build/python-install/include/python2.7


LOCAL_CFLAGS += $(APPLICATION_ADDITIONAL_CFLAGS)

#Change C++ file extension as appropriate
LOCAL_CPP_EXTENSION := .cpp

LOCAL_SRC_FILES := $(foreach F, $(APP_SUBDIRS), $(addprefix $(F)/,$(notdir $(wildcard $(LOCAL_PATH)/$(F)/*.cpp))))
# Uncomment to also add C sources
LOCAL_SRC_FILES += $(foreach F, $(APP_SUBDIRS), $(addprefix $(F)/,$(notdir $(wildcard $(LOCAL_PATH)/$(F)/*.c))))

LOCAL_SHARED_LIBRARIES := $(COMPILED_LIBRARIES)

LOCAL_LDLIBS := -lpython2.7 -ldl -llog -lz

LOCAL_LDFLAGS += -L$(LOCAL_PATH)/../../../build/python-install/lib $(APPLICATION_ADDITIONAL_LDFLAGS)

LIBS_WITH_LONG_SYMBOLS := $(strip $(shell \
	for f in $(LOCAL_PATH)/../../libs/$ARCH/*.so ; do \
		if echo $$f | grep "libapplication[.]so" > /dev/null ; then \
			continue ; \
		fi ; \
		if [ -e "$$f" ] ; then \
			if nm -g $$f | cut -c 12- | egrep '.{128}' > /dev/null ; then \
				echo $$f | grep -o 'lib[^/]*[.]so' ; \
			fi ; \
		fi ; \
	done \
) )

ifneq "$(LIBS_WITH_LONG_SYMBOLS)" ""
$(foreach F, $(LIBS_WITH_LONG_SYMBOLS), \
$(info Library $(F): abusing symbol names are: \
$(shell nm -g $(LOCAL_PATH)/../../libs/$ARCH/$(F) | cut -c 12- | egrep '.{128}' ) ) \
$(info Library $(F) contains symbol names longer than 128 bytes, \
YOUR CODE WILL DEADLOCK WITHOUT ANY WARNING when you'll access such function - \
please make this library static to avoid problems. ) )
$(error Detected libraries with too long symbol names. Remove all files under project/libs/$ARCH, make these libs static, and recompile)
endif

include $(BUILD_SHARED_LIBRARY)
