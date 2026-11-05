# Build the Organisationssatzung with Typst.

TYPST       ?= typst
ROOT         = src
SOURCE       = $(ROOT)/main.typ
FONTS        = $(ROOT)/hsrtreport/src/assets/fonts
BUILD_DIR    = build
PDF          = $(BUILD_DIR)/Organisationssatzung.pdf
TYPST_FLAGS  = --root $(ROOT) --font-path $(FONTS)

.DEFAULT_GOAL := compile

# The template is a git submodule. Fetch it if it is missing.
$(FONTS):
	git submodule update --init --recursive

.PHONY: compile
compile: $(FONTS)
	@mkdir -p $(BUILD_DIR)
	$(TYPST) compile $(TYPST_FLAGS) $(SOURCE) $(PDF)

.PHONY: watch
watch: $(FONTS)
	@mkdir -p $(BUILD_DIR)
	$(TYPST) watch $(TYPST_FLAGS) $(SOURCE) $(PDF)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
