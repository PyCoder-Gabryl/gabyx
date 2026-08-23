
# 🗺️ DOKUMENT ARCHITEKTONICZNY I MAPA DROGOWA (ROADMAP)
## PROJEKT: GABYX – ROGUELIKE RPG / CITY-BUILDER
**Wersja dokumentu:** `1.0.0` | **Status:** Zatwierdzony do realizacji | **Technologia:** Ada 2022, SPARK, Raylib

---

## 🏛️ 1. FILOZOFIA ARCHITEKTURY I PODZIAŁ MODUŁÓW

Silnik gry opiera się na **architekturze warstwowej z absolutną separacją logiki od prezentacji (*Omni-Engine Principle*)**:
1. **Rdzeń i Mechanika (`src/core/`, `src/game/`, `src/world/`)**:
   * Zgodność w 100% z trybem **SPARK Mode: On**.
   * Całkowity brak zależności od bibliotek graficznych (Raylib, SDL, C).
   * Deterministyczny, dyskretny stan świata (logika kafelkowa).
2. **Warstwa Interfejsu i Układu (`src/ui/`)**:
   * Niezależna abstrakcja widżetów, slotów i responsywnego układu ekranu.
3. **Infrastruktura i Diagnostyka (`src/config/`, `src/logging/`)**:
   * Bezpieczne parsowanie TOML z gwarancją wartości domyślnych (*fallback*).
   * Formalny logger SPARK z mostem diagnostycznym do Rayliba (*Callback Bridge*).
4. **Sterowniki Prezentacji (`src/drivers/`)**:
   * Izolacja API zewnętrznych (Raylib w `src/drivers/graphical/raylib`, terminal w `src/drivers/terminal/ansi`).

---

## 📑 2. CZTERY FILARY KONFIGURACJI TOML (`data/config/`)

Konfiguracja gry została rozbita na 4 wyspecjalizowane domeny:

```
data/config/
├── window.toml   ──► Okno bezramkowe, detekcja monitora (16:9, 16:10, 21:9), V-Sync, FPS
├── fonts.toml    ──► Kwartety Nerd Fonts (JetBrains Mono, Intel One Mono), rozmiary tekstu
├── hud.toml      ──► 3 Profile HUD (Compact, Standard, HiDPI), wymiary pasków, sloty klocków
└── camera.toml   ──► 5 Poziomów Zoomu (20, 32, 48, 64, 96 px), martwa strefa, zachowanie kamery
```

---

## 📐 3. MATEMATYKA WYŚWIETLANIA, VIEWPORTU I SIATKI ŚWIATA

### A. Trzy Profile Interfejsu (HUD Tiers):
* **Profil Kompaktowy** ($W < 1600\text{ px}$ – laptopy 13", $1280\times 720$, $1440\times 900$):  
  Góra: **$32\text{ px}$** (czcionka $14\text{ px}$) | Dół: **$96\text{ px}$** (czcionka $14\text{ px}$) | Razem UI: **$128\text{ px}$**.
* **Profil Standardowy** ($1600\text{ px} \le W \le 2560\text{ px}$ – Full HD, Mac 16", QHD, Ultra-Wide):  
  Góra: **$40\text{ px}$** (czcionka $18\text{ px}$) | Dół: **$120\text{ px}$** (czcionka $16\text{--}18\text{ px}$) | Razem UI: **$160\text{ px}$**.
* **Profil HiDPI / 4K** ($W \ge 3400\text{ px}$ – ekrany 4K, 5K Studio Display):  
  Góra: **$80\text{ px}$** (czcionka $36\text{ px}$) | Dół: **$240\text{ px}$** (czcionka $32\text{ px}$) | Razem UI: **$320\text{ px}$** *(skala $\times 2.0$)*.

### B. Pięć Poziomów Zoomu Siatki Świata:
$$\text{Dostępne rozmiary kafelka: } \mathbf{20\text{ px}}, \mathbf{32\text{ px}}, \mathbf{48\text{ px}}, \mathbf{64\text{ px (Baza)}}, \mathbf{96\text{ px}}$$
* **Zasada pełnych pól**: Liczba kolumn i wierszy lochu jest zawsze zaokrąglana w dół do liczb całkowitych ($\lfloor W / T \rfloor$, $\lfloor H / T \rfloor$).
* **Automatyczny margines (*Auto-Padding*)**: Reszta pikseli tworzy symetryczną, ciemną ramkę wycentrowania wokół mapy.

---

## 🎮 4. KINEMATYKA POSTACI, KAMERA I STOS WARSTW WEJŚCIA

### A. Ruch Postaci i Płynna Interpolacja (Rozwiązanie problemu drgań):
1. **Krok Logiczny (SPARK)**: Natychmiastowe przestawienie współrzędnych $(X, Y)$ na siatce i sprawdzenie kolizji ze ścianą.
2. **Krok Wizualny (Render LERP)**: Płynna interpolacja liniowa pozycji pikseli w czasie $120\text{ ms}$ z mechanicznym zatrzaskiem na pozycji docelowej.

### B. Model Kamery: Martwa Strefa 4 Pól + Ograniczenie do Mapy (*Deadzone & Clamping*):
* **Zachowanie przy krawędzi**: Gracz ma swobodę ruchu w centrum. Gdy zbliży się na mniej niż **4 kafelki** do krawędzi widoku, kamera przesuwa się płynnie **o 1 kafelek** w stronę ruchu.
* **Krawędzie zewnętrzne świata**: Kamera zatrzymuje się na obwodzie mapy (zero czarnej pustki za zewnętrznymi ścianami lochu).

### C. Sterowanie i Swobodna Kamera:
* **`WSAD`**: Dyskretny ruch postaci o 1 pole.
* **`Kursory (Strzałki)`**: Przesunięcie kamery o cały widoczny panel / ekran (*Page Scroll*).
* **`Kursory + Shift`**: Precyzyjne przesunięcie kamery o 1 pole.
* **`Klawisz H (Home) / Spacja`**: Błyskawiczny, płynny powrót i wycentrowanie kamery na bohaterze.

### D. Stos Warstw Myszy z Czyszczeniem Bufora (*Layered Hit-Testing*):
* **Warstwa 4 (Wierzch)**: Okna modalne, wysunięte panele informacyjne.
* **Warstwa 3**: Górny Toolbar i Dolny Dashboard.
* **Warstwa 2**: Podświetlenie kafelka/potwora pod kursorem w świecie (*Hover*).
* **Warstwa 1 (Spód)**: Siatka lochu (kliknięcie rozkazu ruchu).
* **Reguła**: Trafienie w wyższą warstwę odpala jej akcję i natychmiast **pochłania zdarzenie myszy (*Consume Event*)**, zapobiegając klikaniu w świat pod spodem.

---

## 🎛️ 5. MODUŁOWY HUD (3 KLOCKI W SLOTACH) I LOKALIZACJA (i18N)

### A. Trzy Komponenty Dolnego Paska:
1. **`Blok_Swiat`** (Kalendarz, Pogoda, Fazy Księżyca, Surowce osady).
2. **`Blok_Bohater`** (Paski HP/MP/EXP, Hotbar akcji `[1]..[8]`).
3. **`Blok_Dziennik`** (Log walki, questy, narracja – rozwijany w górę klawiszem `L`).

### B. Układ w zależności od formatu:
* **Formaty 16:9 / 16:10**: `[Blok_Bohater]` + `[Blok_Dziennik]` w centrum (przełączanie na `[Blok_Swiat]` klawiszem `Tab`).
* **Format 21:9 Ultra-Wide**: Wszystkie 3 bloki rozsunięte w jednym rzędzie:  
  `[Blok_Swiat (Lewo)]` $\longleftrightarrow$ `[Blok_Bohater (Centrum)]` $\longleftrightarrow$ `[Blok_Dziennik (Prawo)]`.

### C. Zasady Typografii i Wielojęzyczności (i18n):
* **Zapas szerokości**: Wszystkie przyciski i etykiety projektujemy z **$+40\%$ zapasem szerokości** w stosunku do języka angielskiego (pod kątem języka niemieckiego i polskiego).
* **Dynamiczne skalowanie czcionki (*Font Auto-Shrink*)**: Jeśli w danym języku tekst przekracza ramy slotu, silnik automatycznie zmniejsza czcionkę o **$1\text{--}3\text{ px}$**, gwarantując brak ucinania słów.

---

## 🌳 6. DOCELOWA STRUKTURA KATALOGÓW PROJEKTU

```
gabyx/
├── data/
│   └── config/
│       ├── window.toml                     -- Okno bezramkowe, detekcja monitora
│       ├── fonts.toml                      -- Czcionki Nerd Fonts (Regular, Bold, Italic)
│       ├── hud.toml                        -- 3 Profile HUD, wymiary pasków, sloty
│       └── camera.toml                     -- 5 Poziomów zoomu, martwa strefa 4 pól
├── assets/
│   └── fonts/
│       ├── jetbrains_mono/                 -- Kwartet JetBrains Mono Nerd Font
│       └── intel_one_mono/                 -- Kwartet Intel One Mono Nerd Font
├── src/
│   ├── config/                             -- Parsery TOML z obronnym fallbackiem
│   │   ├── gabyx-config.ads
│   │   ├── gabyx-config.adb
│   │   ├── gabyx-config-camera.ads [nowy]
│   │   └── gabyx-config-hud.ads    [nowy]
│   ├── core/                               -- Niezmienne typy domenowe, SPARK, Launcher
│   │   ├── gabyx.ads
│   │   ├── gabyx-types.ads
│   │   ├── gabyx-launcher.ads
│   │   └── gabyx-launcher.adb
│   ├── game/                               -- Logika rozgrywki (100% SPARK)
│   │   ├── map/
│   │   │   ├── gabyx-game-map.ads  [nowy]  -- Struktura kafelków lochu
│   │   │   └── gabyx-game-map.adb  [nowy]  -- Generator planszy i kolizje
│   │   └── player/
│   │       ├── gabyx-game-player.ads [nowy] -- Stan gracza i ruch logiczny
│   │       └── gabyx-game-player.adb [nowy]
│   ├── world/                              -- [Przygotowane pod City-Builder / Biomy]
│   ├── ui/                                 -- Matematyka układu i slotów
│   │   ├── gabyx-ui-layout.ads     [nowy]  -- Przelicznik 3 profili HUD i slotów
│   │   └── gabyx-ui-layout.adb     [nowy]
│   ├── logging/                            -- Dedykowany logger silnika
│   │   ├── gabyx-logging.ads       [nowy]
│   │   └── gabyx-logging.adb       [nowy]
│   ├── drivers/
│   │   ├── abstract/
│   │   │   ├── gabyx-drivers.ads
│   │   │   └── gabyx-drivers-input.ads [nowy]
│   │   └── graphical/
│   │       └── raylib/
│   │           ├── gabyx-drivers-raylib.ads
│   │           ├── gabyx-drivers-raylib.adb
│   │           ├── gabyx-drivers-raylib-renderer.ads [nowy] -- Rysowanie lochu i LERP
│   │           └── gabyx-drivers-raylib-renderer.adb [nowy]
│   └── main.adb
```

---

## 🚀 7. PLAN REALIZACJI (KROKI MILOWE / MILESTONES)

* [x] **Kamień Milowy 1**: Architektura Omni-Engine, parser `window.toml` & `fonts.toml`, statyczne linkowanie Raylib na macOS M1, pierwsze okno graficzne.
* [ ] **Kamień Milowy 2 (Najbliższy cel)**:
  1. Utworzenie `data/config/camera.toml` oraz `data/config/hud.toml`.
  2. Implementacja pakietów domenowych `Gabyx.Game.Map` oraz `Gabyx.Game.Player` w SPARK.
  3. Moduł renderowania siatki (`Gabyx.Drivers.Raylib.Renderer`) – wyrysowanie pierwszego lochu z kafelków i postaci gracza `@` / ``.
  4. Obsługa ruchu `WSAD` z płynną interpolacją LERP ($120\text{ ms}$) oraz kolizjami ze ścianami.
* [ ] **Kamień Milowy 3**:
  1. Moduł kamery z martwą strefą (4 pola) oraz swobodny podgląd mapy (Strzałki + Klawisz `H`).
  2. Dynamiczny zoom kółkiem myszy / klawiszami `+` i `-` ($20, 32, 48, 64, 96\text{ px}$).
* [ ] **Kamień Milowy 4**:
  1. Wdrożenie 3 modułowych klocków HUD-u (Bohater, Świat, Dziennik).
  2. Obsługa warstw myszy (*Hit-Testing*) i rozwijany dziennik zdarzeń (`L`).
* [ ] **Kamień Milowy 5**:
  1. Generator proceduralny lochów (komnaty, korytarze).
  2. Mgła wojny (*Fog of War*) z 3 stanami komórek (Hidden, Explored, Visible).

---
