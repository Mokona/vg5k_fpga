ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
WORK_DIR?=$(ROOT_DIR)/.tmp

all:

define test_rule
test_name:=$$(notdir $$(basename $$(basename $(1))))

TESTS+=$$(test_name)

$$(test_name):$(WORK_DIR)/$$(test_name).hash
	@if [ -e "$(ROOT_DIR)/img/$$(test_name).png" ] \
		&& cmp "$(WORK_DIR)/$$(test_name).hash" "$(ROOT_DIR)/img/$$(test_name).hash"; \
	then \
		echo "$$(test_name): nothing to do"; \
	else \
		echo "$$(test_name): generating"; \
		$(ROOT_DIR)/generate_img "$(WORK_DIR)/$$(test_name).ihex" "$(ROOT_DIR)/img/$$(test_name).png" && \
		cp $(WORK_DIR)/$$(test_name).hash $(ROOT_DIR)/img; \
	fi

endef

$(foreach test_file,$(wildcard $(ROOT_DIR)/src/*.test.m4),$(eval $(call test_rule,$(test_file))))

$(WORK_DIR)/%.s:$(ROOT_DIR)/src/%.test.m4 $(WORK_DIR)
	m4 -I $(ROOT_DIR)/src $< > $@

$(WORK_DIR)/%.bin:$(WORK_DIR)/%.s
	z80asm -I $(ROOT_DIR)/src -o $@ $<

$(WORK_DIR)/%.ihex:$(WORK_DIR)/%.bin
	objcopy -I binary -O ihex --change-section-address .data=0x0000 $< $@

$(WORK_DIR)/%.hash:$(WORK_DIR)/%.ihex
	md5sum $< | cut -d' ' -f1 > $@

all:$(TESTS)

$(WORK_DIR):
	mkdir $@

clean:
	rm -rf $(WORK_DIR)

.PHONY:all clean $(TESTS)

.NOTPARALLEL:$(TESTS)

.NOTINTERMEDIATE:
