--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Podstawowe definicje typów domenowych silnika Gabyx.
--                   Zawiera silnie typowane ograniczenia wymiarów ekranu,
--                   strukturę składowych koloru RGBA oraz typy bazowe
--                   podlegające formalnej weryfikacji w trybie SPARK.
--  ----------------------------------------------------------------------------
--  PATH:            src/core/gabyx-types.ads
--  CREATED:         2026-08-22
--  ============================================================================


package Gabyx.Types with
   SPARK_Mode => On,
   Pure
is

   --  ============================================================================
   --  OGRANICZENIA WYMIARÓW I ROZDZIELCZOŚCI
   --  ============================================================================

   --  Minimalna i maksymalna dopuszczalna szerokość okna (piksele)
   subtype Width_Type is Positive range 640 .. 7680;

   --  Minimalna i maksymalna dopuszczalna wysokość okna (piksele)
   subtype Height_Type is Positive range 360 .. 4320;

   --  Dopuszczalne wartości klatkarza (0 oznacza automatyczny V-Sync)
   subtype Target_FPS_Type is Natural with
      Static_Predicate => Target_FPS_Type in 0 | 30 | 60 | 75 | 120 | 144;

   --  Dostępne tryby wyświetlania okna
   type Display_Mode_Type is (Windowed, Borderless, Borderless_Fullscreen);

   --  Dostępne indeksy 8 predefiniowanych zestawów rozdzielczości
   type Preset_ID is
     (Auto_Default,
      Preset_1,
      Preset_2,
      Preset_3,
      Preset_4,
      Preset_5,
      Preset_6,
      Preset_7,
      Preset_8,
      Preset_9);

   --  Bezpieczny zakres rozmiaru czcionki w pikselach
   subtype Font_Size_Type is Positive range 8 .. 128;

   --  ============================================================================
   --  STRUKTURY KOLORÓW
   --  ============================================================================

   subtype Color_Component is Natural range 0 .. 255;

   type RGBA_Color is record
      R : Color_Component := 0;
      G : Color_Component := 0;
      B : Color_Component := 0;
      A : Color_Component := 255;
   end record;

   --  Domyślny kolor tła silnika (ciemny grafit: #12161A)
   Default_Background_Color : constant RGBA_Color :=
     (R => 18, G => 22, B => 26, A => 255);

   --  Domyślny kolor pasów centrujących do testów wizualnych (bordo: #5A1423)
   Default_Border_Bars_Color : constant RGBA_Color :=
     (R => 90, G => 20, B => 35, A => 255);

   --  ============================================================================
   --  KONTEKST ZMIANY W: src/core/gabyx-types.ads
   --  ============================================================================

   --  Profile rozmiarów HUD-u
   type HUD_Tier_Type is (HUD_Auto, HUD_Compact, HUD_Standard, HUD_HiDPI);

   --  Dwustanowe widoki pasków interfejsu
   type HUD_View_Type is (View_A, View_B);

   --  Generyczna struktura prostokąta dla kontenerów UI (100% SPARK)
   type UI_Rectangle is record
      X      : Integer := 0;
      Y      : Integer := 0;
      Width  : Integer := 0;
      Height : Integer := 0;
   end record;

   --  Pamięć podręczna przeliczonej geometrii (Layout Cache)
   type Layout_Cache is record
      Screen_Width    : Width_Type    := 1280;
      Screen_Height   : Height_Type   := 720;
      Active_Tier     : HUD_Tier_Type := HUD_Compact;
      Is_Ultra_Wide   : Boolean       := False;
      Top_Bar_Rect    : UI_Rectangle  := (X => 0, Y => 0, Width => 1280, Height => 32);
      Viewport_Rect   : UI_Rectangle  := (X => 0, Y => 32, Width => 1280, Height => 592);
      Bottom_Bar_Rect : UI_Rectangle  := (X => 0, Y => 624, Width => 1280, Height => 96);
   end record;

end Gabyx.Types;
