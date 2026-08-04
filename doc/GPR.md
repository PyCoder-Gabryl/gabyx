# 📘 Omówienie pliku projektu GNAT (`gabyx.gpr`)

Plik projektu GNAT jest centralnym elementem profesjonalnego projektu Ada. To nie jest zwykła konfiguracja kompilatora – to **deklaratywny opis całego środowiska budowania**, obejmujący:

* strukturę katalogów,
* scenariusze i zmienne środowiskowe,
* profile kompilacji,
* integrację z SPARK,
* konfigurację linkera i binder’a,
* narzędzia formatowania kodu,
* integrację z IDE i systemem kontroli wersji.

W praktyce plik `.gpr` pełni rolę **manifestu projektu Ada**.

# 🧩 1. Importy projektów zależnych

ada

```
with "ada_toml";
with "raylib";
```

To deklaracje zależności projektowych. GNAT Project Manager pozwala na **kompozycję projektów** – każdy z nich może mieć własne źródła, flagi, katalogi i konfigurację.

* `ada_toml` – biblioteka do obsługi TOML w Ada.
* `raylib` – binding do Raylib, biblioteki graficznej.

Dzięki temu projekt Gabyx automatycznie dziedziczy konfigurację tych projektów.

# 🧭 2. Scenariusze i zmienne środowiskowe

To jedna z najpotężniejszych funkcji GNAT Project Managera. Pozwalają one na **parametryzację projektu** zależnie od systemu, trybu budowania, narzędzi analitycznych itd.

## 🖥 Host\_OS – typ systemu operacyjnego

ada

```
type Host_OS_Type is ("macos", "windows", "linux", "others");
Host_OS : Host_OS_Type := external ("ALIRE_HOST_OS", "others");
```

* `external` pobiera wartość z:
  * zmiennej środowiskowej,
  * lub parametru `-XALIRE_HOST_OS=...`.

To pozwala na **warunkowe ustawianie flag kompilatora i linkera** zależnie od platformy.

## 🛠 Build\_Mode – profil kompilacji

ada

```
type Build_Mode_Type is ("debug", "release", "test");
Build_Mode : Build_Mode_Type := external ("BUILD_MODE", "debug");
```

To klasyczny mechanizm znany z dużych projektów:

* **debug** – pełne sprawdzanie poprawności, asercje, brak optymalizacji,
* **release** – maksymalna optymalizacja, inlining,
* **test** – profil diagnostyczny.

## 🔐 SPARK\_Mode – tryb dowodzenia SPARK

ada

```
SPARK_Mode := external ("SPARK_MODE", "Off");
```

SPARK nie wspiera niektórych flag kompilatora (np. `-isysroot` na macOS). Dlatego projekt musi **warunkowo ukrywać** pewne opcje przed narzędziem `gnatprove`.

To jest przykład świadomej integracji kompilatora z narzędziem formalnej analizy.

# 📁 3. Struktura katalogów projektu

ada

```
for Source_Dirs use ("src/**");
for Object_Dir use "obj";
for Create_Missing_Dirs use "True";
for Exec_Dir use "bin";
for Main use ("main.adb");
```

To jest **profesjonalny układ projektu Ada**:

* `src/**` – rekurencyjne źródła,
* `obj` – pliki `.o`, `.ali`, zależności,
* `bin` – pliki wykonywalne,
* `main.adb` – główny punkt wejścia.

Separacja źródeł od artefaktów kompilacji jest kluczowa dla czystości repozytorium.

# ⚙️ 4. Pakiet Compiler – konfiguracja kompilatora GNAT

To najważniejsza część projektu.

## 🎛 Base\_Switches – rygor projektu

ada

```
Base_Switches := ("-gnat2022",
                  "-gnatW8",
                  "-gnatf",
                  "-gnatwa",
                  "-gnatyy",
                  "-gnatybchiklmnprst",
                  "-gnatyM120",
                  "-fno-strict-aliasing");
```

### Najważniejsze flagi:

* `-gnat2022` – włącza standard Ada 2022.
* `-gnatW8` – wymusza UTF‑8 (ważne dla polskich komentarzy).
* `-gnatwa` – wszystkie ostrzeżenia.
* `-gnatyy` – rygorystyczny test stylu.
* `-gnaty...` – zestaw reguł stylu (indentacja, casing, spacing).
* `-fno-strict-aliasing` – bezpieczniejsze aliasowanie.

To jest zestaw flag charakterystyczny dla **projektów o wysokiej jakości kodu**.

## 🧪 Tryby kompilacji – debug/test vs release

ada

```
case Build_Mode is
   when "debug" | "test" =>
      Base_Switches := Base_Switches &
        ("-g", "-gnata", "-gnato", "-gnatVa", "-O0");

   when "release" =>
      Base_Switches := Base_Switches &
        ("-O3", "-gnatn");
end case;
```

### Tryb debug/test:

* `-g` – debug info,
* `-gnata` – asercje,
* `-gnato` – overflow checks,
* `-gnatVa` – wszystkie sprawdzenia poprawności,
* `-O0` – brak optymalizacji.

### Tryb release:

* `-O3` – maksymalna optymalizacja,
* `-gnatn` – inlining.

To jest klasyczny podział znany z dużych projektów AdaCore.

## 🍏 Konfiguracja specyficzna dla macOS

ada

```
case Host_OS is
   when "macos" =>
      case SPARK_Mode is
         when "Off" =>
            for Default_Switches ("Ada") use Base_Switches &
               ("-isysroot", "/Library/.../MacOSX.sdk");
         when others =>
            for Default_Switches ("Ada") use Base_Switches;
      end case;
```

macOS wymaga jawnego wskazania SDK (`-isysroot`). SPARK tego nie wspiera → projekt musi to ukryć.

To jest **bardzo świadome i poprawne podejście**.

# 🏗 5. Builder – zarządzanie procesem budowania

ada

```
for Executable ("main.adb") use "gabyx";

for Switches ("Ada") use (
   "-s",
   "-j0",
   "-gnatQ");
```

* `-s` – tryb smart (kompiluje tylko zmienione pliki),
* `-j0` – użycie wszystkich rdzeni,
* `-gnatQ` – generowanie plików bibliotecznych nawet przy błędach.

To przyspiesza pracę i poprawia integrację z IDE.

---

# 🔗 6. Binder – łączenie jednostek kompilacji

ada

```
for Switches ("Ada") use ("-Es");
```

* `-Es` – **symboliczny traceback**. W razie wyjątku dostajesz ścieżkę plików i linii, a nie adresy.

To jest absolutnie kluczowe dla debugowania.

# 🧬 7. Linker – tworzenie pliku wykonywalnego

ada

```
case Host_OS is
   when "macos" =>
      for Default_Switches ("Ada") use (
         "-isysroot", "...",
         "-Wl,-syslibroot,..."
      );
```

macOS wymaga:

* `-isysroot` – dla kompilatora,
* `-Wl,-syslibroot` – dla linkera.

To jest poprawna konfiguracja zgodna z dokumentacją Apple i AdaCore.

# 🖋 8. Pretty\_Printer – formatowanie kodu

ada

```
for Switches ("Ada") use (
   "-M120",
   "-nD");
```

* `-M120` – maksymalna szerokość linii,
* `-nD` – zachowaj komentarze dokumentacyjne.

To zapewnia **spójny styl kodu w całym projekcie**.

# 🧠 9. Prove – konfiguracja SPARK

ada

```
for Proof_Switches ("Ada") use (
   "--report=all",
   "--level=1",
   "--steps=0",
   "--prover=z3,cvc5");
```

To jest bardzo dobra konfiguracja dla projektów SPARK:

* pełne raportowanie,
* analiza przepływu danych,
* brak limitu kroków,
* dwa silniki SMT: Z3 i CVC5.

Projekt jest gotowy do **formalnej weryfikacji**.

# 🛠 10. IDE – integracja z narzędziami

ada

```
for VCS_Kind use "git";

case Host_OS is
   when "macos"   => for Debugger_Command use "lldb";
   when "windows" => for Debugger_Command use "gdb";
   when others    => for Debugger_Command use "gdb";
end case;
```

* integracja z Git,
* wybór debuggera zależnie od systemu.

To pozwala IDE (np. GNAT Studio) automatycznie dobrać właściwe narzędzia.

# 📚 Źródła eksperckie (oficjalne)

* **GNAT Project Manager** GNAT Project Manager
* **GPRbuild Reference Manual** GPRbuild
* **GNAT User’s Guide – compiler switches** Przelaczniki\_GNAT
* **SPARK User’s Guide** SPARK
* **gnatpp – pretty printer** gnatpp

# 🧠 Podsumowanie

Plik `gabyx.gpr` jest **bardzo dobrze zaprojektowany**:

* wykorzystuje scenariusze,
* rozdziela profile kompilacji,
* poprawnie obsługuje macOS,
* integruje SPARK,
* zapewnia rygor stylu,
* wspiera IDE i Git,
* ma czystą strukturę katalogów.

To jest projekt na poziomie **AdaCore / przemysłowym**, gotowy do pracy w zespołach, CI/CD i formalnej weryfikacji.
