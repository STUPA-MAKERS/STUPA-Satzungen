# Baut die Satzungen der Studierendenschaft mit Typst.
#
# Jede Satzung entsteht zweimal: als saubere Fassung und als Fassung mit den
# Änderungen zur Vorfassung (`<Name>_Aenderungen.pdf`).

TYPST       ?= typst
PYTHON      ?= python3
ROOT         = src
FONTS        = $(ROOT)/hsrtreport/src/assets/fonts
BUILD_DIR    = build
TYPST_FLAGS  = --root $(ROOT) --font-path $(FONTS)

# <Quelldatei unter src/>:<Name des PDFs>
DOCUMENTS    = main:Organisationssatzung fo:Finanzordnung bs:Beitragssatzung qsmo:QSM-Ordnung

.DEFAULT_GOAL := compile

# Die Vorlage ist ein Submodul. Lade sie, wenn sie fehlt.
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

# Baut die Organisationssatzung mit Änderungen nach jeder Änderung neu.
.PHONY: watch
watch: $(FONTS)
	@mkdir -p $(BUILD_DIR)
	$(TYPST) watch $(TYPST_FLAGS) --input changes=true $(ROOT)/main.typ $(BUILD_DIR)/Organisationssatzung_Aenderungen.pdf

# Setzt die Änderungsmarkierungen neu. Grundlage sind die Vorfassungen in
# baseline/.
.PHONY: marks
marks:
	$(PYTHON) tools/aenderungen.py

# Bricht ab, wenn die Änderungsmarkierungen nicht aktuell sind.
.PHONY: check
check:
	$(PYTHON) tools/aenderungen.py --check

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
