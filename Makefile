#  =============================================================================
#  PROJECT:          Gabyx
#  AUTHOR:           PyCoder Gabryl
#  EMAIL:            pycoder.gabryl@gmail.com
#  GITHUB:           https://github.com/PyCoder-Gabryl/
#  LICENSE:          Apache License 2.0
#  -----------------------------------------------------------------------------
#  DESCRIPTION:      Główny plik automatyzacji (Workflow Engine). Integruje
#                    kompilator GNAT, analizator SPARK oraz narzędzia GNATcov.
#                    Zaprojektowany jako centrum dowodzenia procesem wytwórczym
#                    oprogramowania wysokiej niezawodności.
#  -----------------------------------------------------------------------------
#  PATH:             Makefile
#  FILE VERSION:     0.1.23
#  CREATED:          2026-07-07
#  MODIFIED:         2026-08-06
#  =============================================================================

#  =============================================================================
#  KOLORY I FORMATOWANIE TERMINALA
#  =============================================================================
C_RESET  := \033[0m
C_BLUE   := \033[34;1m
C_GREEN  := \033[32;1m
C_YELLOW := \033[33;1m
C_RED    := \033[31;1m
C_CYAN   := \033[36;1m

#  =============================================================================
#  KONFIGURACJA WIELOPLATFORMOWOŚCI
#  =============================================================================
.SHELLFLAGS := -ec
UNAME_S     := $(shell uname -s 2>/dev/null || echo "Windows")

ifeq ($(OS),Windows_NT)
   SHELL := C:/Program Files/Git/bin/sh.exe
   RM    := rm -rf
else
   SHELL := /bin/sh
   RM    := rm -rf
endif

#  EDUKACJA: Eksportujemy zmienne lokalizacji, aby kompilator GNAT poprawnie
#  interpretował polskie znaki w komunikatach i komentarzach (UTF-8).
export LANG   := pl_PL.UTF-8
export LC_ALL := pl_PL.UTF-8

#  EDUKACJA: macOS SIP (System Integrity Protection) często czyści PATH.
#  Jawne dodanie ~/.alire/bin gwarantuje dostęp do narzędzi SPARK/AUnit.
export PATH   := $(shell echo $$HOME)/.alire/bin:$(PATH)
ALR_BIN_DIR   := $(shell echo $$HOME)/.alire/bin

#  =============================================================================
#  ZMIENNE PROJEKTOWE I ŚCIEŻKI
#  =============================================================================
VERSION      := $(shell cat VERSION 2>/dev/null || echo "0.1.0")
GPR_FILE     := gabyx.gpr
ADC_FILE     := configs/gabyx.adc
ENV_CONFIG   := .dev_env.ini
CONTEXT_OUT  := context.txt

#  Ścieżki raportów i artefaktów
SPARK_REPORT := obj/gnatprove/gnatprove.out
COV_REPORT   := coverage_report
COV_RTS_DIR  := $(CURDIR)/gnatcov_rts

#  Listy narzędzi (DX)
KNOWN_EDITORS   := Cursor Zed IntelliJ\ IDEA PyCharm CLion idea \
                   RustRover Fleet Antigravity Visual\ Studio\ Code \
                   VSCodium code vim nano

KNOWN_TERMINALS := Ghostty iTerm WezTerm Alacritty kitty \
                   Warp Terminal

#  =============================================================================
#  POMOC I DOKUMENTACJA
#  =============================================================================

## help: Wyświetla listę dostępnych poleceń wraz z opisami
help:
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@echo "$(C_BLUE)                     GABYX - CENTRUM AUTOMATYZACJI                    $(C_RESET)"
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@awk 'BEGIN {FS = "## |: "} /^[#][#] / { \
		printf "  $(C_CYAN)%-25s$(C_RESET) %s\n", $$2, $$3 \
	}' $(MAKEFILE_LIST)
	@echo ""

## workflow: Wyświetla szczegółowy przewodnik po cyklu deweloperskim (Alias: wf)
workflow wf:
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@echo "$(C_GREEN)                   DOKUMENTACJA CYKLU PRACY (WORKFLOW)                $(C_RESET)"
	@echo "$(C_BLUE)======================================================================$(C_RESET)"
	@echo "$(C_YELLOW)FAZA 1: INICJALIZACJA PROJEKTU$(C_RESET)"
	@echo "  1. $(C_CYAN)make setup$(C_RESET)       - Tworzy strukturę i plik pragm .adc."
	@echo "  2. $(C_CYAN)alr index --update$(C_RESET) - Pobiera definicje bibliotek Alire."
	@echo "  3. $(C_CYAN)make build$(C_RESET)       - Buduje szkielet w trybie deweloperskim."
	@echo ""
	@echo "$(C_YELLOW)FAZA 2: ITERACYJNY CYKL WYTÓRCZY (DX)$(C_RESET)"
	@echo "  1. $(C_CYAN)make format$(C_RESET)      - Dba o poprawność stylu i wcięć (gnatpp)."
	@echo "  2. $(C_CYAN)make syntax$(C_RESET)      - Weryfikuje semantykę bez pełnego buildu."
	@echo "  3. $(C_CYAN)make prove-l1$(C_RESET)    - Uruchamia analizę przepływu danych SPARK."
	@echo "  4. $(C_CYAN)make run$(C_RESET)         - Odpala aplikację do testów manualnych."
	@echo ""
	@echo "$(C_YELLOW)FAZA 3: WERYFIKACJA I TESTOWANIE$(C_RESET)"
	@echo "  1. $(C_CYAN)make test-aunit$(C_RESET)  - Uruchamia automatyczne testy jednostkowe."
	@echo "  2. $(C_CYAN)make metrics$(C_RESET)     - Analizuje złożoność i kontrakty."
	@echo "  3. $(C_CYAN)make prove-l2$(C_RESET)    - Dowodzi braku błędów wykonania (AoRTE)."
	@echo "$(C_BLUE)======================================================================$(C_RESET)"

#  =============================================================================
#  KONFIGURACJA I SETUP
#  =============================================================================

## setup: Inicjalizuje strukturę projektu i tworzy plik konfiguracji pragm (.adc)
setup:
	@echo "$(C_BLUE)==> Przygotowanie struktury projektu i konfiguracji...$(C_RESET)"
	@mkdir -p configs src tests doc bin obj
	@if [ ! -f $(ADC_FILE) ]; then \
		echo "pragma Assertion_Policy (Check);" > $(ADC_FILE); \
		echo "pragma Restrictions (No_Obsolescent_Features);" >> $(ADC_FILE); \
		echo "pragma Restrictions (No_Entry_Calls_In_Elaboration_Code);" >> $(ADC_FILE); \
		echo "$(C_GREEN)Utworzono domyślny plik $(ADC_FILE)$(C_RESET)"; \
	fi
	@for f in README.md VERSION LICENSE; do \
		if [ ! -f $$f ]; then \
			touch $$f; \
			echo "$(C_GREEN)  [OK] Utworzono pusty plik: $$f$(C_RESET)"; \
		fi; \
	done
	@echo "$(C_GREEN)==> Środowisko gotowe do pracy.$(C_RESET)"

#  =============================================================================
#  KOMPILACJA I URUCHAMIANIE
#  =============================================================================

## build: Budowanie projektu w trybie deweloperskim (Debug + Asercje)
build:
	@echo "$(C_BLUE)==> Budowanie projektu Gabyx (Środowisko deweloperskie)...$(C_RESET)"
	# EDUKACJA: Flagi -g (debug) i -gnata (asercje) są kluczowe w fazie DX.
	@alr build -- -j0
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
	@alr run
	@echo "$(C_GREEN)==> Program zakończył działanie.$(C_RESET)"

## clean: Usuwanie plików binarnych, obiektowych i artefaktów
clean:
	@echo "$(C_YELLOW)==> Czyszczenie projektu i artefaktów...$(C_RESET)"
	@# 1. Czyszczenie artefaktów (.stdout, .stderr, .cswi, .lexch) z lokalnego obj i cache Alire
	@find . ~/.local/share/alire/builds -type f \( -name "*.stdout" -o -name "*.stderr" -o -name "*.cswi" -o -name "*.lexch" \) -delete 2>/dev/null || true
	@# 2. Fizyczne usunięcie folderów build/obj przed alr clean
	$(RM) obj bin gnatcov_rts gnatcov_rts.gpr *.trace *.srctrace *.map context.txt
	@# 3. Wywołanie alr clean na już pustych strukturach
	@alr clean
	@echo "$(C_GREEN)==> Projekt został wyczyszczony.$(C_RESET)"

#  =============================================================================
#  ANALIZA STATYCZNA (SPARK)
#  =============================================================================

## prove-l1: Analiza przepływu danych (Stone level - Flow Analysis)
prove-l1:
	@echo "$(C_BLUE)==> SPARK: Analiza przepływu danych (Poziom 1)...$(C_RESET)"
	alr exec gnatprove -- -P $(GPR_FILE) --level=1 -XSPARK_MODE=On --timeout=30

## prove-l2: Dowód braku błędów wykonania (Silver level - AoRTE)
prove-l2:
	@echo "$(C_BLUE)==> SPARK: Dowód braku błędów wykonania (Poziom 2)...$(C_RESET)"
	alr exec gnatprove -- -P $(GPR_FILE) --level=2 -XSPARK_MODE=On --timeout=30

## prove-l3: Dowód poprawności kontraktów Pre/Post (Gold level)
prove-l3:
	@echo "$(C_BLUE)==> SPARK: Weryfikacja kontraktów Pre/Post (Poziom 3)...$(C_RESET)"
	alr exec gnatprove -- -P $(GPR_FILE) --level=3 -XSPARK_MODE=On --timeout=30

#  =============================================================================
#  ANALIZA POKRYCIA KODU (COVERAGE)
#  =============================================================================
COV_LEVEL := stmt+decision

## coverage: Generuje raport pokrycia kodu testami (XCOV)
coverage: clean
	@echo "$(C_BLUE)==> KROK 0: Inicjalizacja lokalnego runtime GNATcov...$(C_RESET)"
	alr exec -- gnatcov setup --prefix=$(COV_RTS_DIR)
	@echo "$(C_BLUE)==> KROK 1: Instrumentacja kodu źródłowego...$(C_RESET)"
	alr exec -- sh -c 'GPR_PROJECT_PATH="$(COV_RTS_DIR)/share/gpr:$$GPR_PROJECT_PATH" \
		gnatcov instrument -P $(GPR_FILE) --level=$(COV_LEVEL) --projects=gabyx'
	@echo "$(C_BLUE)==> KROK 2: Kompilacja instrumentowanych plików...$(C_RESET)"
	alr exec -- sh -c 'GPR_PROJECT_PATH="$(COV_RTS_DIR)/share/gpr:$$GPR_PROJECT_PATH" \
		gprbuild -P $(GPR_FILE) -j0 --src-subdirs=gnatcov-instr --implicit-with=gnatcov_rts.gpr'
	@echo "$(C_BLUE)==> KROK 3: Uruchomienie i generowanie śladu...$(C_RESET)"
	alr exec -- sh -c 'GNATCOV_TRACE_FILE=game.trace ./bin/gabyx'
	@echo "$(C_BLUE)==> KROK 4: Generowanie raportu HTML...$(C_RESET)"
	@mkdir -p $(COV_REPORT)
	alr exec -- sh -c 'gnatcov coverage -P $(GPR_FILE) --level=$(COV_LEVEL) \
		--annotate=xcov --output-dir=$(COV_REPORT) game.trace'
	@echo "$(C_GREEN)==> Analiza pokrycia zakończona. Raport w: $(COV_REPORT)/$(C_RESET)"

## show-coverage: Otwiera katalog z raportami pokrycia XCOV
show-coverage:
	@if [ -d $(COV_REPORT) ]; then \
		echo "$(C_BLUE)==> Otwieranie raportów XCOV...$(C_RESET)"; \
		if [ "$(UNAME_S)" = "Darwin" ]; then open $(COV_REPORT); else xdg-open $(COV_REPORT); fi; \
	else \
		echo "$(C_RED)Błąd: Raport nie istnieje. Uruchom 'make coverage'.$(C_RESET)"; \
	fi

#  =============================================================================
#  TESTY JEDNOSTKOWE (AUNIT)
#  =============================================================================

## test: Uruchamia domyślny zestaw testów Alire
test:
	@echo "$(C_BLUE)==> Uruchamianie pakietu testowego Alire...$(C_RESET)"
	alr test

## test-gen: Generuje szkielety testów AUnit (gnattest)
test-gen:
	@echo "$(C_BLUE)==> Generowanie infrastruktury testowej AUnit...$(C_RESET)"
	@if ! alr exec which gnattest >/dev/null 2>&1; then \
		echo "$(C_RED)Błąd: gnattest nie znaleziony. Zainstaluj libadalang_tools.$(C_RESET)"; \
		exit 1; \
	fi
	alr exec gnattest -- -P $(GPR_FILE)
	@echo "$(C_GREEN)==> Szkielety testów gotowe w katalogu tests/$(C_RESET)"

## test-aunit: Kompilacja i uruchomienie uprzęży testowej AUnit
test-aunit:
	@echo "$(C_BLUE)==> Kompilacja i uruchamianie uprzęży AUnit...$(C_RESET)"
	@if [ ! -d tests/harness ]; then \
		echo "$(C_RED)Błąd: Uruchom najpierw 'make test-gen'$(C_RESET)"; \
		exit 1; \
	fi
	alr exec gprbuild -- -P tests/harness/test_driver.gpr -j0
	@./tests/harness/test_runner
	@echo "$(C_GREEN)==> Wszystkie testy AUnit zakończone sukcesem!$(C_RESET)"

#  =============================================================================
#  NARZĘDZIA DEWELOPERSKIE (DX)
#  =============================================================================

## syntax: Szybkie sprawdzenie poprawności semantyki (gnatc)
syntax:
	@echo "$(C_BLUE)==> Sprawdzanie składni i semantyki...$(C_RESET)"
	alr exec gprbuild -- -c -gnatc -P $(GPR_FILE)

## format: Automatyczne formatowanie kodu źródłowego (gnatpp)
format:
	@echo "$(C_BLUE)==> Automatyczne formatowanie kodu (gnatpp)...$(C_RESET)"
	alr exec gnatpp -- -P $(GPR_FILE) -r
	@echo "$(C_GREEN)==> Formatowanie zakończone pomyślnie.$(C_RESET)"

## metrics: Analizuje złożoność cyklomatyczną i kontrakty (mt)
metrics mt:
	@echo "$(C_BLUE)==> Analiza metryk kodu (gnatmetric)...$(C_RESET)"
	alr exec gnatmetric -- -P $(GPR_FILE)

## info: Wyświetla informacje o środowisku i ścieżkach
info:
	@echo "$(C_BLUE)==> Diagnostyka środowiska Ada (gprls)...$(C_RESET)"
	alr exec gprls -- -P $(GPR_FILE)

## setup-editor: Skanuje system i pozwala wybrać edytor
setup-editor: _scan-tools
	@echo "$(C_YELLOW)Znalezione edytory:$(C_RESET)"
	@awk '/^\[editors\]/{f=1;next}/^\[/{f=0}f && NF{print "  - " $$0}' $(ENV_CONFIG)
	@printf "$(C_GREEN)Wybierz edytor: $(C_RESET)"; read CHOSEN; \
	awk -v v="$$CHOSEN" 'BEGIN{FS=OFS="="}/^default_editor/{$$2=v}1' $(ENV_CONFIG) \
		> $(ENV_CONFIG).tmp && mv $(ENV_CONFIG).tmp $(ENV_CONFIG)

#  =============================================================================
#  DYSTRYBUCJA I KONTEKST
#  =============================================================================

## package: Pakuje projekt do archiwum ZIP
package:
	@echo "$(C_BLUE)==> Archiwizacja projektu...$(C_RESET)"
	@mkdir -p dist
	@zip -r dist/gabyx_v$(VERSION).zip \
		src configs Makefile alire.toml \
		$(GPR_FILE) README.md VERSION LICENSE .dev_env.ini
	@echo "$(C_GREEN)==> Archiwum ZIP gotowe w dist/$(C_RESET)"

## dump-context: Agreguje architekturę dla AI (Alias: ctx)
dump-context ctx:
	@echo "$(C_BLUE)==> Agregacja kontekstu architektury dla AI...$(C_RESET)"
	@printf "=== STRUKTURA PROJEKTU GABYX (%s) ===\n" "$$(date)" > $(CONTEXT_OUT)
	@find . -maxdepth 3 -not -path '*/.*' -not -path './obj*' -not -path './bin*' >> $(CONTEXT_OUT)
	@printf "\n=== KONFIGURACJA GPRBUILD (%s) ===\n" "$(GPR_FILE)" >> $(CONTEXT_OUT)
	@cat $(GPR_FILE) >> $(CONTEXT_OUT)
	@printf "\n=== INTERFEJSY I SPECYFIKACJE (.ads) ===\n" >> $(CONTEXT_OUT)
	@find src -name "*.ads" -type f | while read f; do \
		printf "\n--- PLIK: %s ---\n" "$$f" >> $(CONTEXT_OUT); \
		cat "$$f" >> $(CONTEXT_OUT); \
	done
	@echo "$(C_GREEN)==> Kontekst spakowany do: $(CONTEXT_OUT)$(C_RESET)"

#  Wewnętrzny target skanujący system (Ukryty)
_scan-tools:
	@echo "$(C_BLUE)==> Skanowanie systemu w poszukiwaniu narzędzi...$(C_RESET)"
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

#  =============================================================================
#  GIT
#  =============================================================================

git-init:
	@if [ ! -d .git ]; then \
		echo "-> Inicjalizacja repozytorium Git..."; \
		git init -b main; \
	else \
		echo "-> Repozytorium Git już istnieje."; \
	fi
	@echo "-> Konfigurowanie hooka post-commit..."
	@mkdir -p .git/hooks
	@echo '#!/bin/sh' > .git/hooks/post-commit
	@echo 'LAST_MSG=$$(git log -1 --pretty=%B)' >> .git/hooks/post-commit
	@echo 'case "$$LAST_MSG" in' >> .git/hooks/post-commit
	@echo '  bump:*|bump\(*))' >> .git/hooks/post-commit
	@echo '    exit 0' >> .git/hooks/post-commit
	@echo '    ;;' >> .git/hooks/post-commit
	@echo '  *)' >> .git/hooks/post-commit
	@echo '    cz bump --yes --files-only' >> .git/hooks/post-commit
	@echo '    GIT_HASH=$$(git rev-parse --short HEAD)' >> .git/hooks/post-commit
	@echo '    BASE_VER=$$(cat VERSION | cut -d"+" -f1)' >> .git/hooks/post-commit
	@echo '    echo "$${BASE_VER}+git.$${GIT_HASH}" > VERSION' >> .git/hooks/post-commit
	@echo '    NEW_VER=$$(cat VERSION | cut -d"+" -f1)' >> .git/hooks/post-commit
	@echo '    git add VERSION alire.toml .cz.toml 2>/dev/null' >> .git/hooks/post-commit
	@echo '    git commit -m "bump: version -> $${NEW_VER}"' >> .git/hooks/post-commit
	@echo '    git tag "v$${NEW_VER}"' >> .git/hooks/post-commit
	@echo '    ;;' >> .git/hooks/post-commit
	@echo 'esac' >> .git/hooks/post-commit
	@chmod +x .git/hooks/post-commit
	@echo "-> Gotowe! Git i automatyczne wersjonowanie zostały skonfigurowane."

git-reset:
	@echo "-> Usuwanie historii i folderu .git..."
	@rm -rf .git
	@echo "-> Przywracanie wersji bazowej 0.1.0..."
	@echo "0.1.0" > VERSION
	@sed -i '' 's/version = ".*"/version = "0.1.0"/' .cz.toml 2>/dev/null || true
	@sed -i '' 's/version = ".*"/version = "0.1.0"/' alire.toml 2>/dev/null || true
	@$(MAKE) git-init

.PHONY: help workflow wf setup build build-prod run clean prove-l1 prove-l2 \
        prove-l3 coverage show-coverage test test-gen test-aunit syntax \
        format metrics mt info setup-editor setup-terminal package \
        git-tag-add ctx dump-context
