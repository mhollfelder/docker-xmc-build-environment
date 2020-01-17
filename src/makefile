## Project names
PROJECT = UART

MCU = XMC1100
PACKAGE = _T038
VARIANT = x0064

## Build related variables
ROOT_DIR := ./
BUILD := $(ROOT_DIR)../build/
LIB := $(ROOT_DIR)../lib/
TOOLS := $(ROOT_DIR)../tools/

## Cross-compilation commands
ARM_TOOLCHAIN = $(TOOLS)binaries/ARM-GCC-49/bin/
CC      = arm-none-eabi-gcc
AR      = arm-none-eabi-ar
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE    = arm-none-eabi-size

## Toolchain & library paths
XMC_LIB := $(LIB)XMC_Peripheral_Library_v2.1.24/XMCLib/
CMSIS := $(LIB)XMC_Peripheral_Library_v2.1.24/CMSIS/
CMSIS_GCC := $(CMSIS)Infineon/XMC1100_series/Source/GCC/
NEWLIB := $(LIB)XMC_Peripheral_Library_v2.1.24/ThirdPartyLibraries/Newlib

## Linker flags & variables
LINKER_MAP_FILE := $(BUILD)/$(PROJECT).map
LINKER_FLAGS := -nostartfiles -Xlinker --gc-sections -specs=nano.specs -specs=nosys.specs
LINKER_FLAGS += -mcpu=cortex-m0 -mthumb -g -gdwarf-2 -Wl,-Map,$(LINKER_MAP_FILE)
LINKER_SCRIPT := $(CMSIS)Infineon/XMC1100_series/Source/GCC/$(MCU)$(VARIANT).ld

## Compiler flags
CC_FLAGS := -O1 -ffunction-sections -fdata-sections -fno-common -Wall -Wextra -std=gnu99 -pipe -c -fmessage-length=0 -Wno-missing-field-initializers -mcpu=cortex-m0 -mthumb -g -gdwarf-2
AS_FLAGS := -x assembler-with-cpp -Wall -c -fmessage-length=0 -mcpu=cortex-m0 -mthumb -g -gdwarf-2
LIBS := -lm

## The source files
## Add here additional sources which should be compiled
C_SRCS := 	$(shell find "$(XMC_LIB)src" -name '*.cpp' -or -name '*.c' -or -name '*.s' -or -name '*.S') \
			$(shell find "$(CMSIS_GCC)" -name '*.cpp' -or -name '*.c' -or -name '*.s' -or -name '*.S') \
			$(shell find "$(CMSIS_GCC).." -maxdepth 1 -name '*.cpp' -or -name '*.c' -or -name '*.s' -or -name '*.S') \
			$(shell find "$(NEWLIB)" -name '*.cpp' -or -name '*.c' -or -name '*.s' -or -name '*.S') \
			$(ROOT_DIR)main.c

## The object files
OBJS_E := $(C_SRCS:.c=.o)
OBJS_E := $(OBJS_E:.S=.o)
OBJS = $(foreach obj, $(OBJS_E), $(BUILD)$(obj:./../%=%))

## The dependency files
DEPFILES := $(OBJS:%.o=%.d)

INCLUDE_PATHS := $(LIB)$(XMC_LIB)inc/ \
		   		 $(LIB)$(CMSIS)Include/ \
		   		 $(LIB)$(CMSIS)Infineon/$(MCU)_series/Include/ \
				 $(ROOT_DIR)..

INCLUDE = $(foreach inc, $(INCLUDE_PATHS), -I$(inc))

## Tool invocations
$(BUILD)$(PROJECT).elf: $(OBJS) $(LINKER_SCRIPT)
	@echo 'Building target: $@'
	@echo 'Invoking: ARM-GCC C Linker'
	$(file >$(BUILD)objects.rsp, $(OBJS))
	"$(ARM_TOOLCHAIN)$(CC)" -T$(LINKER_SCRIPT) $(LINKER_FLAGS) -o $@ "@$(BUILD)objects.rsp" $(LIBS)
	@echo 'Finished building target: $@'
	@echo

$(BUILD)$(PROJECT).hex: $(BUILD)$(PROJECT).elf
	@echo 'Invoking: ARM-GCC Create Flash Image'
	"$(ARM_TOOLCHAIN)$(OBJCOPY)" -O ihex "$<" "$@"
	@echo 'Finished building: $@'
	@echo

$(BUILD)$(PROJECT).lst: $(BUILD)$(PROJECT).elf
	@echo 'Invoking: ARM-GCC Create Listing'
	"$(ARM_TOOLCHAIN)$(OBJDUMP)" -h -S "$<" > "$@"
	@echo 'Finished building: $@'
	@echo

$(BUILD)$(PROJECT).siz: $(BUILD)$(PROJECT).elf
	@echo 'Invoking: ARM-GCC Print Size'
	"$(ARM_TOOLCHAIN)$(SIZE)" --format=berkeley "$<"
	@echo 'Finished showing size'
	@echo

## C files to object files
$(BUILD)%.o: ../%.c $(BUILD)%.d
	@echo 'Building file: $^'
	@echo 'Invoking: ARM-GCC C Compiler'
	mkdir -p $(dir $(@))
	"$(ARM_TOOLCHAIN)$(CC)" $(CC_FLAGS) -MMD -MT "$@" -D$(MCU)$(PACKAGE)$(VARIANT) $(INCLUDE) -Wa,-adhlns="$@.lst" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$(@)" "$<"
	@echo 'Finished building: $^'
	@echo

## C files to object files for the main src folder
$(BUILD)%.o: ./%.c $(BUILD)%.d
	@echo 'Building file: $^'
	@echo 'Invoking: ARM-GCC C Compiler'
	mkdir -p $(dir $(@))
	"$(ARM_TOOLCHAIN)$(CC)" $(CC_FLAGS) -MMD -MT "$@" -D$(MCU)$(PACKAGE)$(VARIANT) $(INCLUDE) -Wa,-adhlns="$@.lst" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$(@)" "$<"
	@echo 'Finished building: $^'
	@echo

## Assembler files to object files
$(BUILD)%.o: ../%.S $(BUILD)%.d
	@echo 'Building file: $<'
	@echo 'Invoking: ARM-GCC Assembler'
	mkdir -p $(dir $(@))
	"$(ARM_TOOLCHAIN)$(CC)" $(AS_FLAGS) -MMD -MT "$@" -D$(MCU)$(PACKAGE)$(VARIANT) $(INCLUDE) -Wa,-adhlns="$@.lst" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$(@)" "$<" 
	@echo 'Finished building: $<'
	@echo

## Include the dependency files
$(DEPFILES):
include $(wildcard $(DEPFILES))

.PHONY: all
all:$(BUILD)$(PROJECT).hex

.PHONY: size
size:$(BUILD)$(PROJECT).siz

.PHONY: list
size:$(BUILD)$(PROJECT).lst

.PHONY: flash
flash: 

.PHONY: clean
clean:
	@echo 'Removing all generated files'
	@echo 'Invoking: rm'
	@rm $(BUILD)/* -rf
	@echo 'Finished removing all files from: $(BUILD)'
	@echo