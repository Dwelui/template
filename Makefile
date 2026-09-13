CC := gcc

AR := ar
ARFLAGS := rcs

# Source --------------------------------
TARGET := build/libtemplate.a

CFLAGS := -Wall -Wextra -Wpedantic -std=c23 -Iinclude

SRC := $(wildcard src/*.c)
OBJ := $(SRC:src/%.c=build/source/obj/%.o)


# Libraries -----------------------------
REPO_ROOT := ..

TESTLIB := $(REPO_ROOT)/test
STRINGLIB := $(REPO_ROOT)/string

CFLAGS += \
	-I$(STRINGLIB)/include

LDFLAGS += \
	-L$(STRINGLIB)/build

LDLIBS += \
	-lstring


# Tests ---------------------------------
TEST_RUNNER := build/tests/run-tests

TEST_CFLAGS := -g -fsanitize=address -O0 $(CFLAGS) \
	-I$(TESTLIB)/include
TEST_LDFLAGS := -fsanitize=address $(LDFLAGS) \
	-L$(TESTLIB)/build/
TEST_LDLIBS := $(LDLIBS) \
	-ltest

TEST_SRC := $(wildcard tests/*.c)
TEST_OBJ := $(TEST_SRC:tests/%.c=build/tests/obj/%.o)

.PHONY: all test clean compdb

# Source --------------------------------
all: libs $(TARGET)

build/source/obj/%.o: src/%.c
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJ)
	@mkdir -p $(@D)
	@$(AR) $(ARFLAGS) $@ $^


# Libraries -----------------------------
libs:
	@$(MAKE) -C $(TESTLIB) --silent
	@$(MAKE) -C $(STRINGLIB) --silent


# Tests ---------------------------------
build/tests/obj/%.o: tests/%.c
	@mkdir -p $(@D)
	@$(CC) $(TEST_CFLAGS) -c $< -o $@

$(TEST_RUNNER): $(OBJ) $(TEST_OBJ)
	@mkdir -p $(@D)
	@$(CC) $^ $(TEST_LDFLAGS) $(TEST_LDLIBS) -o $@

test: libs $(TEST_RUNNER)
	@$(TEST_RUNNER)


# Tools ---------------------------------
clean:
	rm -rf build

compdb:
	bear --output compile_commands.json -- $(MAKE) clean $(TEST_RUNNER)
