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
      Static_Predicate => Target_FPS_Type in 0 | 30 | 60 | 75 | 120;

   --  Dostępne indeksy predefiniowanych zestawów rozdzielczości
   type Preset_ID is (Auto_Default, Preset_1, Preset_2, Preset_3, Preset_4);

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

end Gabyx.Types;
