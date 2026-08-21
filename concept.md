# 📄 DOKUMENT KONCEPCYJNY: PROJEKT GABYX

| Parametr         | Wartość                         |
| :--------------- | :------------------------------ |
| **Nazwa Projektu | Gabyx                           |
| **               |                                 |
| **Wersja         | `[0.1.0]`                       |
| Projektu **      |                                 |
| **Autor*         | PyCoder Gabryl                  |
| *                | (https://github.com/PyCoder-Gab |
|                  | ryl/)                           |
| **Licenc ja**    | Apache License 2.0              |
| **Główna         | Ada 2022, SPARK                 |
| Technolo gia**   |                                 |
| **Docelo         | macOS M1 (Apple Silicon /       |
|                  | Tahoe), Linux                   |
| we Platform y**  | (Debian), Windows               |

---

## 🎮 1. WIZJA GRY I INSPIRACJE

**Gabyx** to wielopłaszczyznowa, hybrydowa gra RPG z widokiem kafelkowym / znakowym (Dungeon Crawler / Roguelike), zintegrowana z rozbudowanym modułem strategicznym typu City-Builder oraz głęboką symulacją żyjącego świata.

### Główne Filary Rozgrywki:
1. **Hybrydowy Gameplay**: Płynne połączenie czasu rzeczywistego (RTS) podczas zarządzania osadą, ekonomią i obroną z systemem turowym podczas bezpośredniej eksploracji podziemi, walki taktycznej i eksploracji lochów.
2. **Dynamiczny, Reagujący Świat**: Pełna symulacja królestw, lokalnych osad, zróżnicowanych ras i unikalnych biomów. Każda akcja gracza niesie za sobą konsekwencje (tzw. efekt motyla), wpływając na nastroje frakcji, dyplomację, szlaki handlowe oraz stabilność geopolityczną.
3. **Złożone Systemy RPG i Handlu**: Rozbudowane drzewa dialogowe, zaawansowane mechaniki negocjacji kontraktów handlowych, sojusze polityczne oraz systemy rzemiosła (crafting) i budowy struktur.
4. **Inspiracje Projektowe**:
   * **Baldur's Gate**: Głębia fabularna, wielowątkowe dialogi i wpływ relacji na zachowanie towarzyszy.
   * **Dwarf Fortress**: Złożoność symulacji świata, autonomiczni agenci, generowanie historii i procedury ekonomiczne.
   * **ADOM (Ancient Domains of Mystery)**: Tradycyjny duch gatunku roguelike, rygorystyczne zasady przetrwania i proceduralna eksploracja.
   * **Stardew Valley / Terraria**: Systemy progresji ekonomicznej, budowania struktur oraz zbieractwa i rozwoju majątku.

---

## 📑 2. PIĘCIOWARSTWOWA ARCHITEKTURA DANYCH I LOGIKI

W celu uniknięcia kosztownej i częstej rekompilacji kodu silnika napisanego w języku Ada, cała logika danych, fabuły i stanów świata została oddelegowana do zewnętrznych plików skryptowych i konfiguracyjnych.

```
┌────────────────────────────────────────────────────────┐
│                   SILNIK GRY (ADA 2022)                │
│                                                        │
│   ┌────────────────────────────────────────────────┐   │
│   │   RDZEŃ GRY (Core - SPARK Mode: On)            │   │
│   └───────────────▲────────────────▲───────────────┘   │
│                   │                │                   │
│  Wczytuje fakty   │                │ Wywołuje API      │
│  i wnioskuje      │                │ i pobiera obiekty │
│                   │                │                   │
│   ┌───────────────▼────────────────▼───────────────┐   │
│   │   INTERFEJSY (Drivers - SPARK Mode: Off)       │   │
│   └───────▲───────────────▲───────────────▲─────────┘   │
└───────────┼───────────────┼───────────────┼────────────┘
│               │               │
┌─────▼─────┐   ┌─────▼─────┐   ┌─────▼─────┐
│   TOML    │   │    LUA    │   │  GETTEXT  │
│ (Technic) │   │ (Obiekty) │   │   (.po)   │
└───────────┘   │     +     │   └───────────┘
│    INK    │
│ (Dialogi) │
└───────────┘
```

### 1. Warstwa Konfiguracyjna: TOML 📑
* **Zastosowanie**: Stałe ustawienia techniczne silnika gry (rozdzielczość okna, mapowanie klawiszy, ścieżki zasobów, flagi diagnostyczne).
* **Obsługa w Adzie**: Biblioteka `ada_toml` (toml-ada) pobierana bezpośrednio przez Alire. Jest napisana w czystej Adzie, co eliminuje problemy z kompilacją skrośną (cross-compilation) i linkowaniem dynamicznym na macOS M1.

### 2. Warstwa Definicji Obiektów: LUA 🌙
* **Zastosowanie**: Kompletny opis encji (potwory, przedmioty, budynki, kafelki mapy) oraz definicje zdarzeń zwrotnych (callbacks). Wszystkie obiekty są strukturami danych w Lua.
* **Obsługa w Adzie**: Integracja przez API C biblioteki Lua (`Interfaces.C`), z zachowaniem warstwy izolacji (SPARK_Mode => Off dla adaptera Lua).

### 3. Warstwa Relacji i Wiedzy: DATALOG 🧠
* **Zastosowanie**: Silnik reguł logicznych odpowiedzialny za całą wiedzę o świecie gry. Przechowuje relacje polityczne, sekrety, wiedzę NPC o graczu, zaszłe wydarzenia historyczne oraz służy do wnioskowania logicznego.
* **Obsługa w Adzie**: Ze względu na brak stabilnych bibliotek Datalog w ekosystemie Alire, zaimplementujemy **własny, minimalistyczny silnik Datalog w czystej Adzie i SPARK** (Forward-Chaining / Bottom-Up Evaluation). Gwarantuje to bezpieczeństwo matematyczne (SPARK_Mode => On) i brak ryzyka nieskończonych pętli.

### 4. Warstwa Fabularna i Questy: INK 🖋️
* **Zastosowanie**: Tworzenie nieliniowych dialogów, drzew rozmów z NPC, negocjacji handlowych oraz skryptowania wielowariantowych zadań.
* **Obsługa w Adzie**: Narzędzie `inklecate` kompiluje pliki `.ink` do formatu JSON. Pliki te będą odczytywane i interpretowane wewnątrz maszyny wirtualnej Lua przy użyciu lekkiego, stabilnego parsera Ink napisanego w Lua (np. *Narrator* lub *Tinta*). Ada komunikuje się z Lua wyłącznie przez proste i bezpieczne API.

### 5. Warstwa Lokalizacji: GNU gettext (.po) 🌐
* **Zastosowanie**: Internacjonalizacja (i18n) interfejsu oraz komunikatów systemowych. Wspiera odmiany przez liczby (plurale) i nazwane parametry (named placeholders).
* **Obsługa w Adzie**: Zaimplementowana poprzez moduł `GnatCOLL.Refp` lub dedykowany adapter parsujący z pliku `.po`, w pełni przyjazny dla systemów tłumaczeniowych.
* **Przykład formatowania komunikatów**:
  ```po
  msgid "{attacker} dealt {damage} points of {damage_type} damage to {target}."
  msgstr "{attacker} zadał {damage} pkt. obrażeń typu {damage_type} celowi {target}."
  ```

---

## 📊 3. PORÓWNANIE I ANALIZA STRATEGICZNA STEROWNIKÓW GRAFICZNYCH

Silnik gry zostanie zaprojektowany jako architektura wielo-sterownikowa (Omni-Engine). Poniższe tabele stanowią techniczną analizę opcji prezentacji graficznej i tekstowej na macOS M1 i Debian Linux.

### Tabela 1: Sterowniki Graficzne (Okienkowe)

| Kryterium | Raylib-Ada 🎨 | SDLAda (SDL2) 🕹️ | GtkAda (GTK3/4) 🪟 | ASFML (SFML) 👾 |
| :--- | :--- | :--- | :--- | :--- |
| **Kompatybilność macOS M1** | **Bardzo dobra** (Natywny ARM64 via Brew) | **Dobra** (Metal backend wspierany) | **Trudna** (Poważne problemy z linkowaniem) | **Umiarkowana** (Wymaga kompilacji CSFML) |
| **Integracja z Alire** | Bezproblemowa (`alr with raylib`) | Bezproblemowa (`alr with sdlada`) | Wymaga ręcznej ścieżki deweloperskiej | Ręczna instalacja zależności |
| **Główne Zalety** | Wbudowana obsługa czcionek TTF; rysowanie 2D kafelków; prosta pętla gry. | Bardzo wysoka wydajność; natywny dostęp do sprzętu; standard branżowy gier 2D. | Gotowy zestaw kontrolek UI; oficjalne wsparcie AdaCore [1.1.8, 1.4.4]. | Zorientowane obiektowo API; łatwe zarządzanie dźwiękiem i oknem. |
| **Największe Ryzyka** | Mniej elastyczny niskopoziomowo niż SDL2. | Brak wbudowanego renderowania tekstu (wymaga trudnego `SDL_ttf` [1.2.5, 1.2.9]). | Paradygmat obiektowy C wyklucza SPARK [1.4.4]; trudna konfiguracja na macOS M1. | Przestarzałe bindingi Ady; konieczność kompilowania warstwy CSFML w C++. |
| **Status w Gabyx** | **Główny Sterownik Graficzny** | **Sterownik Opcjonalny (Atrapa na start)** | **Wykluczony** (Brak zgodności ze SPARK) | **Wykluczony** |

### Tabela 2: Sterowniki Terminalowe (Tekstowe)

| Kryterium | Ncurses (Ada Binding) ⌨️ | AnsiAda / PragmARC 🖥️ | Trendy_Terminal 📊 |
| :--- | :--- | :--- | :--- |
| **Zgodność ze SPARK** | **Niska** (Opiera się na surowych wskaźnikach C) | **Maksymalna (100% SPARK Mode On)** | **Umiarkowana** (Zależności I/O) |
| **Przenośność systemowa** | Bardzo wysoka (Standard POSIX / Terminale Unix) | Absolutna (Zwykły strumień znaków ANSI) | Średnia (Zależna od bazy terminfo) |
| **Wydajność Odświeżania** | Maksymalna (Optymalizuje zmiany na ekranie) | Średnia (Wymaga przemyślanego buforowania) | Średnia |
| **Stopień Skomplikowania** | Wysoki (API specyficzne dla C) | Bardzo niski (Wysyłanie stringów ANSI) | Średni |
| **Status w Gabyx** | **Alternatywny Sterownik Wydajnościowy** | **Główny Sterownik Terminalowy (SPARK)** | **Zbadany (Rezerwowy)** |

---

## 🧠 4. SILNIK LOGICZNY: DATALOG VS PROLOG

Wybór silnika reguł logicznych ma kluczowe znaczenie dla stabilności symulacji dynamicznej wiedzy w grze City-Builder.

```
       PROLOG (Backward Chaining)                  DATALOG (Forward Chaining)

        [Cel: Czy król nienawidzi?]               [Zestaw Faktów: Akcje Gracza]
                    │                                          │
                    ▼ (Szukanie w głąb)                        ▼ (Generowanie wniosków)
         [Reguła 1: Konflikt]                       [Wnioskowanie o relacjach]
                    │                                          │
        ┌───────────┴───────────┐                              ▼ (Stan stabilny)
        ▼                       ▼                         [Zapis Faktów Pochodnych]
   [Fakt: Wojna]         [Pętla Rekurencyjna!]
                             (Zawieszenie gry)            (Gwarantowane zakończenie)
```

### Porównanie Paradygmatów:

1. **Prolog (Wnioskowanie wsteczne - Backward Chaining)**:
    * **Zasada**: Próbuje udowodnić cel poprzez przeszukiwanie bazy reguł w głąb (ang. *depth-first search with backtracking*).
    * **Wada w symulacjach**: Podatny na pętle nieskończone przy rekurencyjnych relacjach społecznych (np. sojuszach). Kolejność reguł w pliku decyduje o zakończeniu programu. Trudno zagwarantować stabilny czas trwania klatki (tick) symulacji.
2. **Datalog (Wnioskowanie w przód - Forward Chaining / Bottom-Up Evaluation)**:
    * **Zasada**: Iteracyjnie generuje wszystkie poprawne wnioski (fakty pochodne) z zestawu faktów bazowych, aż do osiągnięcia punktu stałego (ang. *fixed-point*).
    * **Zaleta dla Gabyx**: Wyklucza złożone terminy funkcyjne, co **gwarantuje matematyczne zakończenie obliczeń w skończonym czasie**. Jest wysoce przewidywalny i idealny do modelowania jako bezpieczna struktura danych w SPARK (brak dynamicznego zarządzania pamięcią i wskaźników).

---

## ⏳ 5. WYDAJNOŚĆ I SKALOWANIE SYMULACJI (SIM-LoD)

Symulacja tysięcy agentów w grze City-Builder wymaga wdrożenia mechanizmu **Simulation Level of Detail (Sim-LoD)**, aby uniknąć przeciążenia procesora.

```
 ┌────────────────────────────────────────────────────────────────────────┐
 │                           ŚWIAT GRY GABYX                              │
 │                                                                        │
 │  ┌─────────────────────────────────┐   ┌────────────────────────────┐  │
 │  │        STREFA AKTYWNA           │   │       STREFA PASYWNA       │  │
 │  │  (Blisko gracza - Mikroskala)   │   │  (Daleko - Makroskala)     │  │
 │  │                                 │   │                            │  │
 │  │  • Pełne ścieżki A*             │   │  • Symulacja statystyczna  │  │
 │  │  • Indywidualne decyzje Lua     │   │  • Brak fizycznych agentów │  │
 │  │  • Sprawdzanie kolizji          │   │  • Proste równania makro   │  │
 │  └─────────────────┬───────────────┘   └─────────────▲──────────────┘  │
 │                    │                                 │                 │
 │                    │  Abstrakcja (Zatarcie szczeg.)  │                 │
 │                    └─────────────────────────────────┘                 │
 │                       Reifikacja (Ucieleśnienie)                       │
 └────────────────────────────────────────────────────────────────────────┘
```

### Mechanika Działania Sim-LoD:
* **Strefa Aktywna (Mikroskala)**: Agenci znajdujący się w pobliżu kamery gracza są w pełni symulowani. Wykonują skrypty Lua (tick), posiadają fizyczne współrzędne, wykonują wyszukiwanie ścieżek (A*) i generują kolizje.
* **Strefa Pasywna (Makroskala)**: Sektory oddalone od gracza są symulowane czysto matematycznie/statystycznie. Zamiast symulować pojedynczych rolników, silnik wykonuje proste równanie akumulacji zasobów raz na określony interwał (np. 1 minutę).
* **Reifikacja (Ucieleśnienie)**: Gdy gracz zbliża się do strefy pasywnej, silnik "materializuje" statystyki w fizycznych agentów, przydzielając im spójne z historią parametry.
* **Abstrakcja (Dematerializacja)**: Gdy gracz oddala się, agenci są niszczeni w pamięci, a ich aktualny status ulega agregacji do zmiennych statystycznych.

---

## 🧵 6. WIELOWĄTKOWOŚĆ I ZRÓWNOLEGLENIE (ADA TASKS)

Wykorzystamy natywny, zaimplementowany na poziomie języka Ada model wielowątkowości oparty na **Zadaniach (Tasks)** i **Obiektach Chronionych (Protected Objects)**. Gwarantuje to bezpieczne zrównoleglenie bez ryzyka wystąpienia hazardów (race conditions).

```
 ┌────────────────────────────────────────┐
 │          WĄTEK GRAFICZNY (Core)        │
 │  - Obsługa okna (Raylib/Terminal)      │
 │  - Pobieranie wejścia (Klawiatura/Mysz)│
 │  - Renderowanie klatek (60 FPS)        │
 └──────────────────┬───▲─────────────────┘
                    │   │
  Wstrzykuje akcje  │   │ Pobiera aktualny stan renderowania
                    ▼   │
 ┌────────────────────────────────────────┐
 │   BUFOR CHRONIONY (Protected Object)   │
 │  - Bezpieczna synchronizacja pamięci   │
 │  - Brak blokowania wątków (lock-free)  │
 └──────────────────▲───│─────────────────┘
                    │   │
  Wypycha nowy stan │   │ Pobiera rozkazy/wejście
                    │   ▼
 ┌────────────────────────────────────────┐
 │      WĄTEK SYMULACJI (Background)      │
 │  - Tick ekonomii i biologii (Sim-LoD)  │
 │  - Wnioskowanie logiczne (Datalog)     │
 │  - Skrypty zachowań (Lua VM)           │
 └────────────────────────────────────────┘
```

* **Zaleta**: Podział ten sprawia, że powolny krok symulacji makroskopowej lub zapytanie logiczne Datalogu w tle nigdy nie spowoduje "szarpnięcia" (dropu klatek) w renderowaniu grafiki Raylib lub terminala ANSI.

---

## 🛠️ 7. NARZĘDZIA POMOCNICZE (SVELTE + TAURI)

W celu przyspieszenia prac deweloperskich i umożliwienia łatwego modowania gry przez społeczność, odrzucamy pisanie edytorów w języku Ada.

* **Svelte**: Zapewnia ultra-szybki czas ładowania interfejsu wizualnego edytora. Brak wirtualnego DOM sprawia, że pliki wynikowe są minimalistyczne i działają bez narzutu.
* **Tauri**: Wykorzystuje natywny silnik przeglądarki systemu operacyjnego, a backend w języku Rust kompiluje się do minimalnej wersji binarnej (<10MB). Odpowiada za bezpieczny zapis i odczyt plików `.lua` oraz `.json` bezpośrednio na dysku twardym dewelopera lub modera.
* **Efekt**: Twórcy zawartości otrzymują piękne, nowoczesne edytory wizualne o znikomym apetycie na zasoby systemowe.

---

## 💻 8. ROZWIĄZANIE PROBLEMÓW GIT & STATUS ROZRUCHU

### Skorygowanie Powiązania ze Zdalnym Repozytorium:
Jeśli podczas inicjalizacji wystąpił konflikt powiązań `origin`, wykonaj poniższe komendy w katalogu projektu, aby poprawnie skonfigurować uwierzytelnianie kluczem SSH:

```bash
cd /Users/pygamiq/Documents/InteliIDEA/Ada/gabyx

# 1. Zmiana adresu URL repozytorium na format SSH
git remote set-url origin git@github.com:PyCoder-Gabryl/gabyx.git

# 2. Bezpieczne wypchnięcie pierwszej gałęzi main
git push -u origin main
```

---

## 🎓 9. WSKAZÓWKI DO MATERIAŁÓW WIDEO (DLA TWOICH WIDZÓW)

Podczas nagrywania pierwszego odcinka serii o grze **Gabyx**, warto wyjaśnić widzom następujące zagadnienia inżynieryjne:

1. **Magia Podziału (Specification vs Body)**: Pokaż na przykładzie pliku `.ads` i `.adb`, jak Ada perfekcyjnie rozdziela interfejs (to, co widzą inne moduły) od implementacji (to, co jest ukryte). To fundament naszej architektury Omni-Engine.
2. **Kompilacja Warunkowa w GPRbuild**: Wyjaśnij, jak za pomocą jednego pliku projektu `.gpr` zarządzamy wieloma silnikami graficznymi, odcinając nieobsługiwane biblioteki na macOS M1 i linkując tylko to, co jest wymagane.
3. **Prolog vs Datalog**: Opowiedz widzom o pułapkach wnioskowania w grach – dlaczego klasyczny Prolog z szukaniem w głąb potrafi zawiesić grę i dlaczego nasz własny, napisany w SPARK silnik Datalog (Forward-Chaining) gwarantuje stabilność rozgrywki.
4. **Dlaczego SPARK to "Święty Graal" Programowania**: Zademonstruj, że kompilator potrafi dowieść matematycznie poprawności kodu bez pisania setek asercji runtime i testów jednostkowych dla sytuacji skrajnych.

---

### PODSUMOWANIE I STATUS PRZEJŚCIA

Koncepcja gry **Gabyx** została w pełni sformalizowana, a ryzyka technologiczne zidentyfikowane i zneutralizowane. Twoje zdalne repozytorium jest gotowe na przyjęcie pierwszych plików projektu.
