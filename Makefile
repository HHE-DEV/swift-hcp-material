prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib
executable = hcp-material

build:
	swift build \
		--disable-sandbox \
		--configuration release \
		-Xswiftc --cross-module-optimization
		
install: build
	install -d "$(bindir)" "$(libdir)"
	install ".build/release/$(executable)" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/$(executable)"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
