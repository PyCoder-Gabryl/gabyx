--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Definicje struktur danych i typów dla interfejsu użytkownika (UI).
--                   Zawiera profile skalowania HUD-u, dwustanowe widoki pasków,
--                   abstrakcyjne prostokąty kontenerów oraz strukturę pamięci
--                   podręcznej geometrii ekranu (Layout Cache) w czystym SPARK.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/types/gabyx-ui-types.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Types;

package Gabyx.UI.Types with
   SPARK_Mode => On,
   Pure
is

   use Gabyx.Types;

   --  ============================================================================
   --  PROFILE I WYMIARY PASKÓW HUD
   --  ============================================================================

   --  Profile rozmiarów HUD-u
   type HUD_Tier_Type is (HUD_Auto, HUD_Compact, HUD_Standard, HUD_HiDPI);

   --  Wymiary pasków dla danego profilu (Pure SPARK)
   type HUD_Tier_Dimensions is record
      Top_Height    : Positive       := 32;
      Bottom_Height : Positive       := 96;
      Font_Size     : Font_Size_Type := 14;
   end record;

   --  Dwustanowe widoki pasków interfejsu
   type HUD_View_Type is (View_A, View_B);

   --  ============================================================================
   --  GEOMETRIA KONTENERÓW I PAMIĘĆ PODRĘCZNA (LAYOUT CACHE)
   --  ============================================================================

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

end Gabyx.UI.Types;
