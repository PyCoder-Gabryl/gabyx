# ==============================================================================
# PROJECT:          Snake Ada Game
# AUTHOR:           PyCoder Gabryl
# EMAIL:            pycoder.gabryl@gmail.com
# GITHUB:           https://github.com/PyCoder-Gabryl/
# LICENSE:          Apache License 2.0
# ------------------------------------------------------------------------------
# DESCRIPTION:      Główny plik automatyzacji (Workflow Engine). Integruje
#                   kompilator GNAT, analizator SPARK oraz narzędzia GNATcov.
#                   Zaprojektowany jako centrum dowodzenia procesem wytwórczym
#                   oprogramowania wysokiej niezawodności w standardzie 1.0.0.
# ------------------------------------------------------------------------------
# PATH:             Makefile
# FILE VERSION:     1.0.0
# CREATED:          2026-07-07
# UPDATED:          2026-07-16
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

# Ścieżki do plików konfiguracyjnych i raportów
ENV_CONFIG   := .dev_env.ini
SPARK_REPORT := obj/gnatprove/gnatprove.out
COV_REPORT   := coverage_report
COV_RTS_DIR  := $(CURDIR)/gnatcov_rts

# Listy narzędzi do skanowania (podzielone dla zachowania szerokości linii)
KNOWN_EDITORS := Cursor Zed IntelliJ\ IDEA PyCharm CLion RustRover Fleet \
                 Antigravity Visual\ Studio\ Code VSCodium code vim nano
KNOWN_TERMINALS := Ghostty iTerm WezTerm Alacritty kitty Warp Terminal

# ==============================================================================
# POMOC I DOKUMENTACJA
# ==============================================================================

## help: Wyswietla liste dostepnych polecen wraz z opisami
help:
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@echo "$(C_BLUE)                   SNAKE ADA - CENTRUM AUTOMATYZACJI                  $(C_RESET)"
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@awk 'BEGIN {FS = "## |: "} /^[#][#] / { \
		printf "  $(C_CYAN)%-25s$(C_RESET) %s\n", $$2, $$3 \
	}' $(MAKEFILE_LIST)
	@echo ""

# ==============================================================================
# KOMPILACJA I URUCHAMIANIE
# ==============================================================================

## build: Budowanie projektu w trybie deweloperskim (Debug + Asercje)
build:
	@echo "$(C_BLUE)==> Budowanie Snake Ada (Development)...$(C_RESET)"
	# EDUKACJA: Tryb deweloperski aktywuje flagi -g i -gnata (asercje).
	alr build -- -j0
	@echo "$(C_GREEN)==> Build zakonczony pomyslnie!$(C_RESET)"

## build-prod: Budowanie produkcyjne z pelna optymalizacja (-O3)
build-prod:
	@echo "$(C_BLUE)==> Budowanie Snake Ada (Release/Optimization)...$(C_RESET)"
	# EDUKACJA: Tryb release wylacza asercje i wlacza agresywny inlining kodu.
	alr build --release -- -j0
	@echo "$(C_GREEN)==> Build produkcyjny zakonczony!$(C_RESET)"

## run: Uruchamianie gry w srodowisku Alire
run:
	@echo "$(C_BLUE)==> Uruchamianie gry Snake Ada...$(C_RESET)"
	alr run
	@echo "$(C_GREEN)==> Program zakonczyl dzialanie.$(C_RESET)"

## clean: Usuwanie plików binarnych, obiektowych i artefaktów SPARK/COV
clean:
	@echo "$(C_YELLOW)==> Czyszczenie projektu (obj, bin, rts, trace)...$(C_RESET)"
	$(RM) obj bin gnatcov_rts gnatcov_rts.gpr *.trace *.srctrace game_tests.trace
	@echo "$(C_GREEN)==> Projekt wyczyszczony.$(C_RESET)"

# ==============================================================================
# ANALIZA STATYCZNA (SPARK)
# ==============================================================================

## prove-l1: Analiza przeplywu danych (Stone level - Flow Analysis)
prove-l1:
	@echo "$(C_BLUE)==> SPARK: Analiza przeplywu danych (Level 1)...$(C_RESET)"
	alr exec gnatprove -- -P snake_ada.gpr --level=1 -XSPARK_MODE=On --timeout=30 -v -j0
	@echo "$(C_GREEN)==> Analiza Level 1 zakonczona.$(C_RESET)"

## prove-l2: Dowod braku bledow wykonania (Silver level - AoRE)
prove-l2:
	@echo "$(C_BLUE)==> SPARK: Dowod braku bledow wykonania (Level 2)...$(C_RESET)"
	alr exec gnatprove -- -P snake_ada.gpr --level=2 -XSPARK_MODE=On --timeout=30 -v -j0
	@echo "$(C_GREEN)==> Analiza Level 2 zakonczona.$(C_RESET)"

## prove-l3: Dowod poprawnosci kontraktow Pre/Post (Gold level)
prove-l3:
	@echo "$(C_BLUE)==> SPARK: Weryfikacja kontraktow (Level 3)...$(C_RESET)"
	alr exec gnatprove -- -P snake_ada.gpr --level=3 -XSPARK_MODE=On --timeout=30 -v -j0
	@echo "$(C_GREEN)==> Analiza Level 3 zakonczona.$(C_RESET)"

## prove-l4: Pelna poprawnosc funkcjonalna (Diamond level)
prove-l4:
	@echo "$(C_BLUE)==> SPARK: Pelne dowodzenie logiczne (Level 4)...$(C_RESET)"
	alr exec gnatprove -- -P snake_ada.gpr --level=4 -XSPARK_MODE=On --timeout=30 -v -j0
	@echo "$(C_GREEN)==> Analiza Level 4 zakonczona sukcesem!$(C_RESET)"

# ==============================================================================
# ANALIZA POKRYCIA KODU (COVERAGE)
# ==============================================================================

COV_LEVEL := stmt+decision

## coverage: Generuje raport pokrycia kodu testami (XCOV)
coverage: clean
	@echo "$(C_BLUE)==> KROK 0: Przygotowanie lokalnego runtime GNATcov...$(C_RESET)"
	alr exec -- gnatcov setup --prefix=$(COV_RTS_DIR)
	@echo "$(C_BLUE)==> KROK 1: Instrumentacja kodu zrodlowego...$(C_RESET)"
	alr exec -- sh -c 'GPR_PROJECT_PATH="$(COV_RTS_DIR)/share/gpr:$$GPR_PROJECT_PATH" \
		gnatcov instrument -P tests.gpr --level=$(COV_LEVEL) --projects=snake_ada --projects=tests'
	@echo "$(C_BLUE)==> KROK 2: Budowanie instrumentowanych binariow...$(C_RESET)"
	alr exec -- sh -c 'GPR_PROJECT_PATH="$(COV_RTS_DIR)/share/gpr:$$GPR_PROJECT_PATH" \
		gprbuild -P tests.gpr -j0 --src-subdirs=gnatcov-instr --implicit-with=gnatcov_rts.gpr'
	@echo "$(C_BLUE)==> KROK 3: Uruchamianie testow i zrzut sladow...$(C_RESET)"
	alr exec -- sh -c 'GNATCOV_TRACE_FILE=game_tests.trace ./bin/tests/run_all_tests'
	@echo "$(C_BLUE)==> KROK 4: Generowanie raportu XCOV...$(C_RESET)"
	@mkdir -p $(COV_REPORT)
	alr exec -- sh -c 'GPR_PROJECT_PATH="$(COV_RTS_DIR)/share/gpr:$$GPR_PROJECT_PATH" \
		gnatcov coverage -P tests.gpr --level=$(COV_LEVEL) \
		--annotate=xcov --output-dir=$(COV_REPORT) --projects=snake_ada game_tests.trace'
	@echo "$(C_GREEN)==> Analiza pokrycia zakonczona. Raport w: $(COV_REPORT)/$(C_RESET)"

## show-coverage: Otwiera katalog z raportami pokrycia XCOV
show-coverage:
	@if [ -d $(COV_REPORT) ]; then \
		echo "$(C_BLUE)==> Otwieranie katalogu z raportami XCOV...$(C_RESET)"; \
		if [ "$(UNAME_S)" = "Darwin" ]; then open $(COV_REPORT); else xdg-open $(COV_REPORT); fi; \
	else \
		echo "$(C_RED)Blad: Raport nie istnieje. Uruchom 'make coverage'.$(C_RESET)"; \
	fi

# ==============================================================================
# TESTY JEDNOSTKOWE I INTEGRACYJNE
# ==============================================================================

## test: Uruchamia domyslny zestaw testow Alire
test:
	@echo "$(C_BLUE)==> Uruchamianie testow Alire...$(C_RESET)"
	alr test
	@echo "$(C_GREEN)==> Testy zakonczone.$(C_RESET)"

## test-drivers: Uruchamia reczne sterowniki testowe (Etap 1)
test-drivers:
	@echo "$(C_BLUE)==> Uruchamianie sterownikow testowych (Etap 1)...$(C_RESET)"
	alr exec gprbuild -- -P tests.gpr -j0
	@./bin/tests/test_snake
	@./bin/tests/test_board
	@./bin/tests/test_engine
	@echo "$(C_GREEN)==> Etap 1: Wszystkie testy zaliczone!$(C_RESET)"

## test-aunit: Uruchamia profesjonalna uprzaz testowa AUnit (Etap 2)
test-aunit:
	@echo "$(C_BLUE)==> Budowanie i uruchamianie AUnit Suite (Etap 2)...$(C_RESET)"
	alr exec gprbuild -- -P tests.gpr -j0
	@./bin/tests/run_all_tests
	@echo "$(C_GREEN)==> Etap 2: Testy AUnit zakończone sukcesem!$(C_RESET)"

# ==============================================================================
# NARZĘDZIA DEWELOPERSKIE (DX)
# ==============================================================================

## check: Szybkie sprawdzenie skladni kodu bez pelnej kompilacji
check:
	@echo "$(C_BLUE)==> Sprawdzanie skladni kodu (gnatcheck)...$(C_RESET)"
	alr exec gnat -- make -gnats -P snake_ada.gpr
	@echo "$(C_GREEN)==> Skladnia poprawna.$(C_RESET)"

## deps: Wizualizacja drzewa zaleznosci projektu
deps:
	@echo "$(C_BLUE)==> Pobieranie drzewa zaleznosci projektu...$(C_RESET)"
	@alr show --detail --tree --solve --system --external-detect
	@echo "$(C_GREEN)==> Koniec listy zaleznosci.$(C_RESET)"

## format: Automatyczne formatowanie kodu (GNAT Pretty Printer)
format:
	@echo "$(C_BLUE)==> Formatowanie kodu zrodlowego (gnatpp)...$(C_RESET)"
	# EDUKACJA: gnatpp wymaga instalacji gnat_util w toolchainie Alire.
	alr exec gnatpp -- -P snake_ada.gpr -r
	@echo "$(C_GREEN)==> Formatowanie zakonczone.$(C_RESET)"

## open-project-in-terminal: Otwiera projekt w domyslnym terminalu
open-project-in-terminal:
	@if [ ! -f $(ENV_CONFIG) ]; then echo "$(C_RED)Uruchom 'make setup-terminal'$(C_RESET)"; exit 1; fi
	@TERM_CMD=$$(grep '^default_terminal=' $(ENV_CONFIG) | cut -d'=' -f2); \
	if [ -z "$$TERM_CMD" ]; then echo "$(C_RED)Ustaw terminal w 'make setup-terminal'$(C_RESET)"; exit 1; fi; \
	echo "$(C_BLUE)==> Otwieranie projektu w $$TERM_CMD...$(C_RESET)"; \
	if [ "$(UNAME_S)" = "Darwin" ] && [ -d "/Applications/$$TERM_CMD.app" ]; \
		then open -a "$$TERM_CMD" .; else $$TERM_CMD . & fi

## setup-editor: Skanuje system i pozwala wybrac domyslny edytor
setup-editor: _scan-tools
	@echo "$(C_YELLOW)Znalezione edytory:$(C_RESET)"
	@awk '/^\[editors\]/{f=1;next}/^\[/{f=0}f && NF{print "  - " $$0}' $(ENV_CONFIG)
	@printf "$(C_GREEN)Wybierz edytor: $(C_RESET)"; read CHOSEN; \
	awk -v v="$$CHOSEN" 'BEGIN{FS=OFS="="}/^default_editor/{$$2=v}1' $(ENV_CONFIG) \
		> $(ENV_CONFIG).tmp && mv $(ENV_CONFIG).tmp $(ENV_CONFIG)

## setup-terminal: Skanuje system i pozwala wybrac domyslny terminal
setup-terminal: _scan-tools
	@echo "$(C_YELLOW)Znalezione terminale:$(C_RESET)"
	@awk '/^\[terminals\]/{f=1;next}/^\[/{f=0}f && NF{print "  - " $$0}' $(ENV_CONFIG)
	@printf "$(C_GREEN)Wybierz terminal: $(C_RESET)"; read CHOSEN; \
	awk -v v="$$CHOSEN" 'BEGIN{FS=OFS="="}/^default_terminal/{$$2=v}1' $(ENV_CONFIG) \
		> $(ENV_CONFIG).tmp && mv $(ENV_CONFIG).tmp $(ENV_CONFIG)

## show-report: Otwiera raport SPARK w domyslnym edytorze
show-report:
	@if [ ! -f $(ENV_CONFIG) ]; then echo "$(C_RED)Uruchom 'make setup-editor'$(C_RESET)"; exit 1; fi
	@EDITOR=$$(grep '^default_editor=' $(ENV_CONFIG) | cut -d'=' -f2); \
	if [ -z "$$EDITOR" ]; then echo "$(C_RED)Ustaw edytor w 'make setup-editor'$(C_RESET)"; exit 1; fi; \
	if [ ! -f $(SPARK_REPORT) ]; then echo "$(C_RED)Brak raportu. Uruchom 'make prove-l1'$(C_RESET)"; exit 1; fi; \
	echo "$(C_BLUE)==> Otwieranie raportu w $$EDITOR...$(C_RESET)"; \
	if [ "$(UNAME_S)" = "Darwin" ] && [ -d "/Applications/$$EDITOR.app" ]; \
		then open -a "$$EDITOR" $(SPARK_REPORT); else $$EDITOR $(SPARK_REPORT); fi

# ==============================================================================
# ZARZĄDZANIE REPOZYTORIUM I DYSTRYBUCJA
# ==============================================================================

## package: Pakuje projekt do archiwum ZIP (wersja dystrybucyjna)
package:
	@echo "$(C_BLUE)==> Pakowanie projektu do wersji 1.0.0...$(C_RESET)"
	@mkdir -p dist
	@zip -r dist/snake_ada_v1.0.0.zip src tests LLM Makefile alire.toml \
		snake_ada.gpr tests.gpr README.md VERSION LICENSE .dev_env.ini
	@echo "$(C_GREEN)==> Archiwum gotowe w katalogu dist/$(C_RESET)"

## git-tag-add: Interaktywna procedura tworzenia tagu wersji
git-tag-add:
	@printf "$(C_YELLOW)Podaj wersje (np. v1.0.0): $(C_RESET)"; read tag; \
	printf "$(C_YELLOW)Opis: $(C_RESET)"; read desc; \
	git tag -a "$$tag" -m "$$desc" && git push origin "$$tag"

## clear: Czysci bufor terminala
clear:
	@clear

# Wewnetrzny target skanujacy system (ukryty przed help)
_scan-tools:
	@echo "$(C_BLUE)==> Skanowanie systemu w poszukiwaniu narzedzi...$(C_RESET)"
	@if [ ! -f $(ENV_CONFIG) ]; then \
		printf "[default-config]\ndefault_editor=\ndefault_terminal=\n\n[editors]\n[terminals]\n" \
			> $(ENV_CONFIG); \
	fi
	@echo "# Konfiguracja srodowiska deweloperskiego" > $(ENV_CONFIG).tmp
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
# EKSPORT KONTEKSTU DLA AI STUDIO
# ==============================================================================

CONTEXT_OUT := context.txt

## dump-context: Generuje skonsolidowany plik tekstowy z architektura projektu dla AI Studio (Alias: ctx)
dump-context ctx:
	@echo "$(C_BLUE)==> KROK 1: Skanowanie i generowanie struktury katalogow...$(C_RESET)"
	@echo "=== STRUKTURA PROJEKTU (Wygenerowano: $$(date '+%Y-%m-%d %H:%M:%S')) ===" > $(CONTEXT_OUT)
	@if command -v tree >/dev/null 2>&1; then \
		tree -I 'build|obj|bin|.git|gnatcov_rts|coverage_report' >> $(CONTEXT_OUT); \
	else \
		find . -maxdepth 4 -not -path '*/.*' -not -path './obj*' -not -path './bin*' -not -path './gnatcov_rts*' -not -path './coverage_report*' >> $(CONTEXT_OUT); \
	fi
	@echo "" >> $(CONTEXT_OUT)

	@echo "$(C_BLUE)==> KROK 2: Dolaczanie bazowych konfiguracji i API Ady...$(C_RESET)"
	@if [ -f config.toml ]; then \
		echo "=== BAZOWA KONFIGURACJA SILNIKA (config.toml) ===" >> $(CONTEXT_OUT); \
		cat config.toml >> $(CONTEXT_OUT); \
		echo "" >> $(CONTEXT_OUT); \
	fi
	@if [ -f snake_ada.gpr ]; then \
		echo "=== PLIK PROJEKTU ALIRE (snake_ada.gpr) ===" >> $(CONTEXT_OUT); \
		cat snake_ada.gpr >> $(CONTEXT_OUT); \
		echo "" >> $(CONTEXT_OUT); \
	fi

	@echo "$(C_BLUE)==> KROK 3: Agregacja specyfikacji architektonicznych (Pliki .ads)...$(C_RESET)"
	@echo "=== SPECIFIKACJE INTERFEJSOW (API ADY) ===" >> $(CONTEXT_OUT)
	@find src -name "*.ads" -type f -exec sh -c 'echo "--- PLIK: {} ---" >> $(CONTEXT_OUT); cat {} >> $(CONTEXT_OUT); echo "" >> $(CONTEXT_OUT)' \;

	@echo "$(C_BLUE)==> KROK 4: Skanowanie modulow zewnetrznych i logiki obiektow...$(C_RESET)"
	@if [ -d src/entities ]; then \
		echo "=== AKTYWNE OBIEKTY GRY (Skrypty Lua) ===" >> $(CONTEXT_OUT); \
		find src/entities -name "*.lua" -type f -exec sh -c 'echo "--- PLIK: {} ---" >> $(CONTEXT_OUT); cat {} >> $(CONTEXT_OUT); echo "" >> $(CONTEXT_OUT)' \;; \
	fi

	@echo "$(C_GREEN)==> Sukces! Pelny kontekst spakowany do: $(CONTEXT_OUT) ($$(wc -l < $(CONTEXT_OUT) | xargs) linii)$(C_RESET)"
	@echo "$(C_YELLOW)[INFO] Skopiuj zawartosc '$(CONTEXT_OUT)' i wklej na start nowej sesji w AI Studio.$(C_RESET)"


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
	dump-context ctx
