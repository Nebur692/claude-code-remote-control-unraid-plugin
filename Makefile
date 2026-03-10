PLUGIN_NAME := claude-code
VERSION := $(shell grep '^current_version' .bumpversion.toml | head -1 | cut -d'"' -f2)
PACKAGE := $(PLUGIN_NAME)-$(VERSION)-noarch-1

.PHONY: package clean

package: clean
	mkdir -p build/$(PACKAGE)
	cp -R src/* build/$(PACKAGE)/
	cp claude-icon.png build/$(PACKAGE)/usr/local/emhttp/plugins/claude-code/claude-code.png
	chmod 0755 build/$(PACKAGE)/usr/local/emhttp/plugins/claude-code/scripts/*.sh
	chmod 0755 build/$(PACKAGE)/usr/local/emhttp/plugins/claude-code/event/disks_mounted
	cd build/$(PACKAGE) && tar cJf ../$(PACKAGE).txz .
	@cd build && (sha256sum $(PACKAGE).txz 2>/dev/null || shasum -a 256 $(PACKAGE).txz)

clean:
	rm -rf build/
