# Build the statutes of the Studierendenschaft with Typst.
#
# Every statute is built twice: a clean version and a version that shows the
# changes from the previous version (`<Name>_Aenderungen.pdf`).

TYPST       ?= typst
PYTHON      ?= python3
ROOT         = src
FONTS        = $(ROOT)/hsrtreport/src/assets/fonts
BUILD_DIR    = build
TYPST_FLAGS  = --root $(ROOT) --font-path $(FONTS)

# <source file under src/>:<name of the PDF>
DOCUMENTS    = main:Organisationssatzung fo:Finanzordnung bs:Beitragssatzung qsmo:QSM-Ordnung

.DEFAULT_GOAL := compile

# The template is a git submodule. Fetch it if it is missing.
$(FONTS):
	git submodule update --init --recursive

.PHONY: compile
compile: $(FONTS)
	@mkdir -p $(BUILD_DIR)
	@set -e; for document in $(DOCUMENTS); do \
		source=$(ROOT)/$${document%%:*}.typ; pdf=$(BUILD_DIR)/$${document##*:}; \
		echo "$$source -> $$pdf.pdf, $${pdf}_Aenderungen.pdf"; \
		$(TYPST) compile $(TYPST_FLAGS) $$source $$pdf.pdf; \
		$(TYPST) compile $(TYPST_FLAGS) --input changes=true $$source $${pdf}_Aenderungen.pdf; \
	done

# Live preview of the Organisationssatzung with the changes shown.
.PHONY: watch
watch: $(FONTS)
	@mkdir -p $(BUILD_DIR)
	$(TYPST) watch $(TYPST_FLAGS) --input changes=true $(ROOT)/main.typ $(BUILD_DIR)/Organisationssatzung_Aenderungen.pdf

# Set the change marks again from the previous versions in baseline/.
.PHONY: marks
marks:
	$(PYTHON) tools/aenderungen.py

# Fail if the change marks do not match the previous versions.
.PHONY: check
check:
	$(PYTHON) tools/aenderungen.py --check

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
