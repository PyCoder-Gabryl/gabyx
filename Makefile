# ==============================================================================
# PROJECT:          Gabyx
# AUTHOR:           PyCoder Gabryl
# EMAIL:            pycoder.gabryl@gmail.com
# GITHUB:           https://github.com/PyCoder-Gabryl/
# LICENSE:          Apache License 2.0
# ------------------------------------------------------------------------------
# DESCRIPTION:      Główny plik automatyzacji (Workflow Engine). Integruje
#                   kompilator GNAT, analizator SPARK oraz narzędzia GNATcov.
#                   Zaprojektowany jako centrum dowodzenia procesem wytwórczym
#                   oprogramowania wysokiej niezawodności.
# ------------------------------------------------------------------------------
# PATH:             Makefile
# FILE VERSION:     0.1.17
# CREATED:          2026-07-07
# ==============================================================================

# ==============================================================================
# KOLORY I FORMATOWANIE TERMINALA
# ==============================================================================
C_RESET  := \033[0m
C_BLUE   := \033[34;1m
C_GREEN  := \033[32;1m
C_YELLOW := \033[33;1m
C_RED    := \033[31;1m
C_CYAN   := \033[36;1m

# ==============================================================================
# KONFIGURACJA WIELOPLATFORMOWOŚCI
# ==============================================================================

.SHELLFLAGS = -ec
UNAME_S := $(shell uname -s 2>/dev/null || echo "Windows")

ifeq ($(OS),Windows_NT)
	SHELL := C:/Program Files/Git/bin/sh.exe
	RM    := rm -rf
else
	SHELL := /bin/sh
	RM    := rm -rf
endif

# Eksport lokalizacji dla poprawnej obsługi polskich znaków w komentarzach kodu
export LANG := pl_PL.UTF-8
export LC_ALL := pl_PL.UTF-8

# Eksport ścieżki do globalnych binariów Alire (rozwiązuje błędy w IDE na macOS)
export PATH := $(shell echo $$HOME)/.alire/bin:$(PATH)

# Bezwzględna ścieżka do globalnych binariów Alire (omija ograniczenia macOS SIP)
ALR_BIN_DIR  := $(shell echo $$HOME)/.alire/bin

# Ścieżki do plików konfiguracyjnych i raportów
ENV_CONFIG   := .dev_env.ini
SPARK_REPORT := obj/gnatprove/gnatprove.out
COV_REPORT   := coverage_report
COV_RTS_DIR  := $(CURDIR)/gnatcov_rts

# Listy edytorów i terminali (podzielone w celu zachowania czytelności linii)
KNOWN_EDITORS := Cursor Zed IntelliJ\ IDEA PyCharm CLion \
                 RustRover Fleet Antigravity Visual\ Studio\ Code \
                 VSCodium code vim nano

KNOWN_TERMINALS := Ghostty iTerm WezTerm Alacritty kitty \
                   Warp Terminal

# ==============================================================================
# POMOC, DOKUMENTACJA I PRZEWODNIKI
# ==============================================================================

## help: Wyświetla listę dostępnych poleceń wraz z opisami
help:
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@echo "$(C_BLUE)                     GABYX - CENTRUM AUTOMATYZACJI                    $(C_RESET)"
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@awk 'BEGIN {FS = "## |: "} /^[#][#] / { \
		printf "  $(C_CYAN)%-25s$(C_RESET) %s\n", $$2, $$3 \
	}' $(MAKEFILE_LIST)
	@echo ""

## workflow: Wyświetla szczegółowy przewodnik po cyklu deweloperskim i kolejności poleceń (Alias: wf)
workflow wf:
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@echo "$(C_GREEN)                   DOKUMENTACJA CYKLU PRACY (WORKFLOW)                $(C_RESET)"
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@echo "$(C_YELLOW)FAZA 1: INICJALIZACJA PROJEKTU$(C_RESET)"
	@echo "  1. $(C_CYAN)alr index --update-all$(C_RESET) - Pobiera definicje bibliotek z Alire."
	@echo "  2. $(C_CYAN)make build$(C_RESET)             - Buduje szkielet w trybie deweloperskim."
	@echo ""
	@echo "$(C_YELLOW)FAZA 2: ITERACYJNY CYKL WYTÓRCZY (DX)$(C_RESET)"
	@echo "  Podczas pisania kodu regularnie wywołuj te polecenia w podanej kolejności:"
	@echo "  1. $(C_CYAN)make format$(C_RESET)            - Dba o poprawność stylu i wcięć (gnatpp)."
	@echo "  2. $(C_CYAN)make check$(C_RESET)             - Weryfikuje składnię bez pełnej kompilacji."
	@echo "  3. $(C_CYAN)make prove-l1$(C_RESET)          - Uruchamia analizę przepływu danych SPARK."
	@echo "  4. $(C_CYAN)make run$(C_RESET)               - Odpala aplikację do testów manualnych."
	@echo ""
	@echo "$(C_YELLOW)FAZA 3: MATEMATYCZNA WERYFIKACJA I TESTOWANIE$(C_RESET)"
	@echo "  Przed zatwierdzeniem zmian (commit) wykonaj pełną kontrolę jakości:"
	@echo "  1. $(C_CYAN)make test-aunit$(C_RESET)        - Uruchamia automatyczne testy jednostkowe."
	@echo "  2. $(C_CYAN)make coverage$(C_RESET)          - Generuje raporty pokrycia kodu (GNATcov)."
	@echo "  3. $(C_CYAN)make prove-l2$(C_RESET)          - Dowodzi braku błędów wykonania (AoRE)."
	@echo "  4. $(C_CYAN)make prove-l3$(C_RESET)          - Weryfikuje formalne kontrakty Pre/Post."
	@echo ""
	@echo "$(C_YELLOW)FAZA 4: WYDANIE PRODUKCYJNE (RELEASE)$(C_RESET)"
	@echo "  Gdy kod jest zweryfikowany i gotowy do wdrożenia:"
	@echo "  1. $(C_CYAN)make build-prod$(C_RESET)        - Kompiluje optymalizowaną wersję binarną (-O3)."
	@echo "  2. $(C_CYAN)make package$(C_RESET)           - Pakuje kod i artefakty do archiwum ZIP."
	@echo "  3. $(C_CYAN)make git-tag-add$(C_RESET)       - Tworzy podpisany znacznik wersji."
	@echo "$(C_BLUE)======================================================================$(C_RESET)"

# ==============================================================================
# KOMPILACJA I URUCHAMIANIE
# ==============================================================================

## build: Budowanie projektu w trybie deweloperskim (Debug + Asercje)
build:
	@echo "$(C_BLUE)==> Budowanie projektu Gabyx (Środowisko deweloperskie)...$(C_RESET)"
	# EDUKACJA: Tryb deweloperski aktywuje flagi -g i -gnata (asercje).
	alr build -- -j0
	@echo "$(C_GREEN)==> Kompilacja zakończona pomyślnie!$(C_RESET)"

## build-prod: Budowanie produkcyjne z pełną optymalizacją (-O3)
build-prod:
	@echo "$(C_BLUE)==> Budowanie projektu Gabyx (Wersja produkcyjna)...$(C_RESET)"
	# EDUKACJA: Tryb release wyłącza asercje i włącza agresywny inlining kodu.
	alr build --release -- -j0
	@echo "$(C_GREEN)==> Kompilacja produkcyjna zakończona sukcesem!$(C_RESET)"

## run: Uruchamianie gry w środowisku Alire
run:
	@echo "$(C_BLUE)==> Uruchamianie gry Gabyx...$(C_RESET)"
	alr run
	@echo "$(C_GREEN)==> Program zakończył działanie.$(C_RESET)"

## clean: Usuwanie plików binarnych, obiektowych i artefaktów SPARK/COV
clean:
	@echo "$(C_YELLOW)==> Czyszczenie projektu (katalogi wyjściowe, runtime, ślady)...$(C_RESET)"
	$(RM) obj bin gnatcov_rts gnatcov_rts.gpr *.trace *.srctrace game_tests.trace context.txt
	@echo "$(C_GREEN)==> Projekt został wyczyszczony.$(C_RESET)"

# ==============================================================================
# ANALIZA STATYCZNA (SPARK)
# ==============================================================================

## prove-l1: Analiza przepływu danych (Stone level - Flow Analysis)
prove-l1:
	@echo "$(C_BLUE)==> SPARK: Analiza przepływu danych (Poziom 1)...$(C_RESET)"
	alr exec gnatprove -- -P gabyx.gpr --level=1 -XSPARK_MODE=On --timeout=30 -v -j0
	@echo "$(C_GREEN)==> Analiza przepływu danych zakończona.$(C_RESET)"

## prove-l2: Dowód braku błędów wykonania (Silver level - AoRE)
prove-l2:
	@echo "$(C_BLUE)==> SPARK: Dowód braku błędów wykonania (Poziom 2)...$(C_RESET)"
	alr exec gnatprove -- -P gabyx.gpr --level=2 -XSPARK_MODE=On --timeout=30 -v -j0
	@echo "$(C_GREEN)==> Analiza braku błędów wykonania zakończona.$(C_RESET)"

## prove-l3: Dowód poprawności kontraktów Pre/Post (Gold level)
prove-l3:
	@echo "$(C_BLUE)==> SPARK: Weryfikacja kontraktów Pre/Post (Poziom 3)...$(C_RESET)"
	alr exec gnatprove -- -P gabyx.gpr --level=3 -XSPARK_MODE=On --timeout=30 -v -j0
	@echo "$(C_GREEN)==> Analiza kontraktów zakończona.$(C_RESET)"

## prove-l4: Pełna poprawność funkcjonalna (Diamond level)
prove-l4:
	@echo "$(C_BLUE)==> SPARK: Pełne dowodzenie logiczne (Poziom 4 - Diamentowy)...$(C_RESET)"
	alr exec gnatprove -- -P gabyx.gpr --level=4 -XSPARK_MODE=On --timeout=30 -v -j0
	@echo "$(C_GREEN)==> Pełna weryfikacja formalna zakończona sukcesem!$(C_RESET)"

# ==============================================================================
# ANALIZA POKRYCIA KODU (COVERAGE)
# ==============================================================================

COV_LEVEL := stmt+decision

## coverage: Generuje raport pokrycia kodu testami (XCOV)
coverage: clean
	@echo "$(C_BLUE)==> KROK 0: Inicjalizacja lokalnego runtime GNATcov...$(C_RESET)"
	alr exec -- gnatcov setup --prefix=$(COV_RTS_DIR)
	@echo "$(C_BLUE)==> KROK 1: Instrumentacja kodu źródłowego (Gnatcov)...$(C_RESET)"
	alr exec -- sh -c 'GPR_PROJECT_PATH="$(COV_RTS_DIR)/share/gpr:$$GPR_PROJECT_PATH" \
		gnatcov instrument -P tests.gpr --level=$(COV_LEVEL) --projects=gabyx --projects=tests'
	@echo "$(C_BLUE)==> KROK 2: Konsolidacja i kompilacja instrumentowanych plików obiektowych...$(C_RESET)"
	alr exec -- sh -c 'GPR_PROJECT_PATH="$(COV_RTS_DIR)/share/gpr:$$GPR_PROJECT_PATH" \
		gprbuild -P tests.gpr -j0 --src-subdirs=gnatcov-instr \
		--implicit-with=gnatcov_rts.gpr'
	@echo "$(C_BLUE)==> KROK 3: Uruchomienie testów i generowanie śladu wykonania (trace)...$(C_RESET)"
	alr exec -- sh -c 'GNATCOV_TRACE_FILE=game_tests.trace ./bin/tests/run_all_tests'
	@echo "$(C_BLUE)==> KROK 4: Agregacja pokrycia i generowanie raportu HTML (XCOV)...$(C_RESET)"
	@mkdir -p $(COV_REPORT)
	alr exec -- sh -c 'GPR_PROJECT_PATH="$(COV_RTS_DIR)/share/gpr:$$GPR_PROJECT_PATH" \
		gnatcov coverage -P tests.gpr --level=$(COV_LEVEL) \
		--annotate=xcov --output-dir=$(COV_REPORT) \
		--projects=gabyx game_tests.trace'
	@echo "$(C_GREEN)==> Analiza pokrycia kodu zakończona pomyślnie. Raport w: $(COV_REPORT)/$(C_RESET)"

## show-coverage: Otwiera katalog z raportami pokrycia XCOV
show-coverage:
	@if [ -d $(COV_REPORT) ]; then \
		echo "$(C_BLUE)==> Otwieranie katalogu z raportami XCOV...$(C_RESET)"; \
		if [ "$(UNAME_S)" = "Darwin" ]; then open $(COV_REPORT); else xdg-open $(COV_REPORT); fi; \
	else \
		echo "$(C_RED)Błąd: Raport nie istnieje. Uruchom najpierw 'make coverage'.$(C_RESET)"; \
	fi

# ==============================================================================
# TESTY JEDNOSTKOWE I INTEGRACYJNE
# ==============================================================================

## test: Uruchamia domyślny zestaw testów Alire
test:
	@echo "$(C_BLUE)==> Uruchamianie pakietu testowego Alire...$(C_RESET)"
	alr test
	@echo "$(C_GREEN)==> Pakiet testowy Alire zakończył działanie.$(C_RESET)"

## test-drivers: Uruchamia ręczne sterowniki testowe (Etap 1)
test-drivers:
	@echo "$(C_BLUE)==> Uruchamianie sterowników testowych (Etap 1 - Klasyczne asercje)...$(C_RESET)"
	alr exec gprbuild -- -P tests.gpr -j0
	@./bin/tests/test_snake
	@./bin/tests/test_board
	@./bin/tests/test_engine
	@echo "$(C_GREEN)==> Etap 1: Wszystkie testy jednostkowe zakończone powodzeniem!$(C_RESET)"

## test-aunit: Uruchamia profesjonalną uprząż testową AUnit (Etap 2)
test-aunit:
	@echo "$(C_BLUE)==> Kompilacja i uruchamianie uprzęży testowej AUnit (Etap 2)...$(C_RESET)"
	alr exec gprbuild -- -P tests.gpr -j0
	@./bin/tests/run_all_tests
	@echo "$(C_GREEN)==> Etap 2: Wszystkie testy jednostkowe AUnit zakończone sukcesem!$(C_RESET)"

# ==============================================================================
# NARZĘDZIA DEWELOPERSKIE (DX)
# ==============================================================================

## check: Szybkie sprawdzenie składni kodu oraz reguł stylowych (gnatcheck)
syntax:
	@echo "$(C_BLUE)==> Sprawdzanie składni kodu kompilatorem...$(C_RESET)"
	@alr exec -- gprbuild -gnatc -P gabyx.gpr
	@echo "$(C_GREEN)==> Weryfikacja składniowa zakończona pomyślnie.$(C_RESET)"

## deps: Wizualizacja drzewa zależności projektu
deps:
	@echo "$(C_BLUE)==> Pobieranie i rozwiązywanie drzewa zależności projektu...$(C_RESET)"
	@alr show --detail --tree --solve --system --external-detect
	@echo "$(C_GREEN)==> Koniec listy zależności.$(C_RESET)"

## format: Automatyczne formatowanie kodu źródłowego (gnatpp)
format:
	@echo "$(C_BLUE)==> Automatyczne formatowanie kodu źródłowego (gnatpp)...$(C_RESET)"
	# EDUKACJA: gnatpp wymaga instalacji gnat_util w toolchainie Alire.
	alr exec gnatpp -- -P gabyx.gpr -r
	@echo "$(C_GREEN)==> Formatowanie kodu zakończone pomyślnie.$(C_RESET)"

## open-project-in-terminal: Otwiera projekt w domyślnym terminalu systemowym
open-project-in-terminal:
	@if [ ! -f $(ENV_CONFIG) ]; then echo "$(C_RED)Błąd: Uruchom 'make setup-terminal'$(C_RESET)"; exit 1; fi
	@TERM_CMD=$$(grep '^default_terminal=' $(ENV_CONFIG) | cut -d'=' -f2); \
	if [ -z "$$TERM_CMD" ]; then echo "$(C_RED)Błąd: Ustaw terminal w 'make setup-terminal'$(C_RESET)"; exit 1; fi; \
	echo "$(C_BLUE)==> Otwieranie projektu w edytorze $$TERM_CMD...$(C_RESET)"; \
	if [ "$(UNAME_S)" = "Darwin" ] && [ -d "/Applications/$$TERM_CMD.app" ]; \
		then open -a "$$TERM_CMD" .; else $$TERM_CMD . & fi

## setup-editor: Skanuje system i pozwala wybrać domyślny edytor programisty
setup-editor: _scan-tools
	@echo "$(C_YELLOW)Znalezione edytory:$(C_RESET)"
	@awk '/^\[editors\]/{f=1;next}/^\[/{f=0}f && NF{print "  - " $$0}' $(ENV_CONFIG)
	@printf "$(C_GREEN)Wybierz edytor: $(C_RESET)"; read CHOSEN; \
	awk -v v="$$CHOSEN" 'BEGIN{FS=OFS="="}/^default_editor/{$$2=v}1' $(ENV_CONFIG) \
		> $(ENV_CONFIG).tmp && mv $(ENV_CONFIG).tmp $(ENV_CONFIG)

## setup-terminal: Skanuje system i pozwala wybrać domyślny terminal systemowy
setup-terminal: _scan-tools
	@echo "$(C_YELLOW)Znalezione terminale:$(C_RESET)"
	@awk '/^\[terminals\]/{f=1;next}/^\[/{f=0}f && NF{print "  - " $$0}' $(ENV_CONFIG)
	@printf "$(C_GREEN)Wybierz terminal: $(C_RESET)"; read CHOSEN; \
	awk -v v="$$CHOSEN" 'BEGIN{FS=OFS="="}/^default_terminal/{$$2=v}1' $(ENV_CONFIG) \
		> $(ENV_CONFIG).tmp && mv $(ENV_CONFIG).tmp $(ENV_CONFIG)

## show-report: Otwiera raport SPARK w wybranym edytorze deweloperskim
show-report:
	@if [ ! -f $(ENV_CONFIG) ]; then echo "$(C_RED)Błąd: Uruchom najpierw 'make setup-editor'$(C_RESET)"; exit 1; fi
	@EDITOR=$$(grep '^default_editor=' $(ENV_CONFIG) | cut -d'=' -f2); \
	if [ -z "$$EDITOR" ]; then echo "$(C_RED)Błąd: Ustaw edytor w 'make setup-editor'$(C_RESET)"; exit 1; fi; \
	if [ ! -f $(SPARK_REPORT) ]; then echo "$(C_RED)Błąd: Brak raportu. Uruchom najpierw 'make prove-l1'$(C_RESET)"; exit 1; fi; \
	echo "$(C_BLUE)==> Otwieranie raportu analizy SPARK w edytorze $$EDITOR...$(C_RESET)"; \
	if [ "$(UNAME_S)" = "Darwin" ] && [ -d "/Applications/$$EDITOR.app" ]; \
		then open -a "$$EDITOR" $(SPARK_REPORT); else $$EDITOR $(SPARK_REPORT); fi

# ==============================================================================
# ZARZĄDZANIE REPOZYTORIUM I DYSTRYBUCJA
# ==============================================================================

## package: Pakuje projekt do archiwum ZIP (wersja dystrybucyjna dla graczy)
package:
	@echo "$(C_BLUE)==> Archiwizacja i pakowanie dystrybucyjne projektu...$(C_RESET)"
	@mkdir -p dist
	@zip -r dist/gabyx_v0.1.1.zip \
		src configs LLM Makefile alire.toml \
		gabyx.gpr tests.gpr README.md VERSION LICENSE .dev_env.ini
	@echo "$(C_GREEN)==> Archiwum ZIP przygotowane w katalogu dist/$(C_RESET)"

## git-tag-add: Interaktywna procedura tworzenia taga wersji (GitHub Release)
git-tag-add:
	@printf "$(C_YELLOW)Podaj wersję (np. v0.1.1): $(C_RESET)"; read tag; \
	printf "$(C_YELLOW)Opis zmian dla taga: $(C_RESET)"; read desc; \
	git tag -a "$$tag" -m "$$desc" && git push origin "$$tag"

## clear: Czyści bufor terminala systemowego
clear:
	@clear

# Wewnętrzny target skanujący system operacyjny (Ukryty przed komendą help)
_scan-tools:
	@echo "$(C_BLUE)==> Skanowanie systemu operacyjnego w poszukiwaniu narzędzi...$(C_RESET)"
	@if [ ! -f $(ENV_CONFIG) ]; then \
		printf "[default-config]\ndefault_editor=\ndefault_terminal=\n\n[editors]\n[terminals]\n" \
			> $(ENV_CONFIG); \
	fi
	@echo "# Konfiguracja środowiska deweloperskiego" > $(ENV_CONFIG).tmp
	@echo "[default-config]" >> $(ENV_CONFIG).tmp
	@DEF_ED=$$(grep '^default_editor=' $(ENV_CONFIG) 2>/dev/null | cut -d'=' -f2 || echo ""); \
	 echo "default_editor=$$DEF_ED" >> $(ENV_CONFIG).tmp
	@DEF_TERM=$$(grep '^default_terminal=' $(ENV_CONFIG) 2>/dev/null | cut -d'=' -f2 || echo ""); \
	 echo "default_terminal=$$DEF_TERM" >> $(ENV_CONFIG).tmp
	@echo "" >> $(ENV_CONFIG).tmp
	@echo "[editors]" >> $(ENV_CONFIG).tmp
	@echo "$(KNOWN_EDITORS)" | tr ' ' '\n' | while read ed; do \
		if command -v "$$ed" >/dev/null 2>&1 || [ -d "/Applications/$$ed.app" ]; then \
			echo "$$ed" >> $(ENV_CONFIG).tmp; fi; \
	done
	@echo "" >> $(ENV_CONFIG).tmp
	@echo "[terminals]" >> $(ENV_CONFIG).tmp
	@echo "$(KNOWN_TERMINALS)" | tr ' ' '\n' | while read term; do \
		if command -v "$$term" >/dev/null 2>&1 || [ -d "/Applications/$$term.app" ]; then \
			echo "$$term" >> $(ENV_CONFIG).tmp; fi; \
	done
	@mv $(ENV_CONFIG).tmp $(ENV_CONFIG)

# ==============================================================================
# EKSPORT KONTEKSTU ARCHITEKTURY DLA AI STUDIO (DUMP)
# ==============================================================================

CONTEXT_OUT := context.txt

## dump-context: Generuje skonsolidowany plik tekstowy z architekturą dla AI Studio (Alias: ctx)
dump-context ctx:
	@echo "$(C_BLUE)==> KROK 1: Analiza struktury katalogów projektu...$(C_RESET)"
	@echo "=== STRUKTURA PROJEKTU GABYX (Wygenerowano: $$(date '+%Y-%m-%d %H:%M:%S')) ===" > $(CONTEXT_OUT)
	@if command -v tree >/dev/null 2>&1; then \
		tree -I 'build|obj|bin|.git|gnatcov_rts|coverage_report|alire' >> $(CONTEXT_OUT); \
	else \
		find . -maxdepth 4 -not -path '*/.*' \
			-not -path './obj*' -not -path './bin*' \
			-not -path './gnatcov_rts*' \
			-not -path './coverage_report*' \
			-not -path './alire*' >> $(CONTEXT_OUT); \
	fi
	@echo "" >> $(CONTEXT_OUT)

	@echo "$(C_BLUE)==> KROK 2: Agregacja specyfikacji konfiguracji oraz interfejsów...$(C_RESET)"
	@if [ -d configs ]; then \
		echo "=== PLIKI KONFIGURACYJNE TOML (configs/) ===" >> $(CONTEXT_OUT); \
		find configs -name "*.toml" -type f -exec sh -c \
			'echo "--- PLIK: {} ---" >> $(CONTEXT_OUT); \
			cat {} >> $(CONTEXT_OUT); \
			echo "" >> $(CONTEXT_OUT)' \;; \
	fi
	@if [ -f gabyx.gpr ]; then \
		echo "=== KONFIGURACJA GPRBUILD (gabyx.gpr) ===" >> $(CONTEXT_OUT); \
		cat gabyx.gpr >> $(CONTEXT_OUT); \
		echo "" >> $(CONTEXT_OUT); \
	fi

	@echo "$(C_BLUE)==> KROK 3: Agregacja specyfikacji pakietów Ady (pliki .ads)...$(C_RESET)"
	@echo "=== INTERFEJSY I SPECYFIKACJE APID (Pliki .ads) ===" >> $(CONTEXT_OUT)
	@find src -name "*.ads" -type f -exec sh -c \
		'echo "--- PLIK: {} ---" >> $(CONTEXT_OUT); \
		cat {} >> $(CONTEXT_OUT); \
		echo "" >> $(CONTEXT_OUT)' \;

	@echo "$(C_BLUE)==> KROK 4: Konsolidacja zewnętrznych skryptów logiki i struktur...$(C_RESET)"
	@if [ -d src/entities ]; then \
		echo "=== SKRYPTY DEFINICJI STRUKTUR I OBIEKTOW LUA (entities/) ===" >> $(CONTEXT_OUT); \
		find src/entities -name "*.lua" -type f -exec sh -c \
			'echo "--- PLIK: {} ---" >> $(CONTEXT_OUT); \
			cat {} >> $(CONTEXT_OUT); \
			echo "" >> $(CONTEXT_OUT)' \;; \
	fi

	@echo "$(C_GREEN)==> Sukces! Kompletny kontekst spakowany do: $(CONTEXT_OUT) ($$(wc -l < $(CONTEXT_OUT) | xargs) linii)$(C_RESET)"
	@echo "$(C_YELLOW)[INFO] Skopiuj zawartość pliku '$(CONTEXT_OUT)' i przekaż swojemu asystentowi AI.$(C_RESET)"

# ==============================================================================
# NARZĘDZIA DEWELOPERSKIE (DX)
# ==============================================================================

## install-gnatmetric-gnatpp: Instaluje narzędzia gnatmetric, gnatpp i gnatstub (Alias: igmp, install-tools)
install-gnatmetric-gnatpp igmp install-tools:
	@echo "$(C_YELLOW)==> Rozpoczynanie wymuszonej instalacji gnatmetric, gnatpp, gnatstub...$(C_RESET)"
	@echo "$(C_CYAN)[URUCHAMIANIE]: alr --force install libadalang_tools$(C_RESET)"
	alr --force install libadalang_tools
	@echo "$(C_GREEN)==> Instalacja gnatmetric, gnatpp i gnatstub zakończona pomyślnie!$(C_RESET)"

## metrics: Analizuje złożoność cyklomatyczną, linie kodu oraz kontrakty SPARK (Alias: mt)
metrics mt:
	@if [ ! -f $(ALR_BIN_DIR)/gnatmetric ]; then \
		echo "$(C_YELLOW)[INFO] Narzędzie gnatmetric nie zostało znalezione w $(ALR_BIN_DIR)." ; \
		echo "Rozpoczynam automatyczną procedurę instalacyjną...$(C_RESET)"; \
		$(MAKE) install-gnatmetric-gnatpp; \
	fi
	@echo "$(C_BLUE)==> Analiza metryk kodu źródłowego (gnatmetric)...$(C_RESET)"
	@alr exec -- $(ALR_BIN_DIR)/gnatmetric -P gabyx.gpr \
		--complexity-all --lines-all \
		--contract --post --contract-complexity --lines-spark \
		$$(find src -name "*.ad?")
	@echo "$(C_GREEN)==> Generowanie metryk zakończone pomyślnie.$(C_RESET)"

# ==============================================================================
# DEKLARACJA TARGETÓW WIRTUALNYCH (.PHONY)
# ==============================================================================
.PHONY: \
	build \
	build-prod \
	check \
	clean \
	clear \
	coverage \
	deps \
	format \
	git-tag-add \
	help \
	open-project-in-terminal \
	package \
	prove-l1 \
	prove-l2 \
	prove-l3 \
	prove-l4 \
	run \
	setup-editor \
	setup-terminal \
	show-coverage \
	show-report \
	test \
	test-aunit \
	test-drivers \
	dump-context ctx \
	workflow wf \
	metrics mt \
	install-gnatmetric-gnatpp \
	igmp \
	install-tools
