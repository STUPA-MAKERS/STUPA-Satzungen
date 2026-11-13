# Build the Organisationssatzung, the QSM-Ordnung and the Finanzordnung with Typst.

TYPST       ?= typst
ROOT         = src
SOURCE       = $(ROOT)/main.typ
FONTS        = $(ROOT)/hsrtreport/src/assets/fonts
BUILD_DIR    = build
PDF          = $(BUILD_DIR)/Organisationssatzung.pdf
QSMO_SOURCE  = $(ROOT)/qsmo.typ
QSMO_PDF     = $(BUILD_DIR)/QSM-Ordnung.pdf
FO_SOURCE    = $(ROOT)/fo.typ
FO_PDF       = $(BUILD_DIR)/Finanzordnung.pdf
TYPST_FLAGS  = --root $(ROOT) --font-path $(FONTS)

.DEFAULT_GOAL := compile

# The template is a git submodule. Fetch it if it is missing.
$(FONTS):
	git submodule update --init --recursive

.PHONY: compile
compile: $(FONTS)
	@mkdir -p $(BUILD_DIR)
	$(TYPST) compile $(TYPST_FLAGS) $(SOURCE) $(PDF)
	$(TYPST) compile $(TYPST_FLAGS) $(QSMO_SOURCE) $(QSMO_PDF)
	$(TYPST) compile $(TYPST_FLAGS) $(FO_SOURCE) $(FO_PDF)

.PHONY: watch
watch: $(FONTS)
	@mkdir -p $(BUILD_DIR)
	$(TYPST) watch $(TYPST_FLAGS) $(SOURCE) $(PDF)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
