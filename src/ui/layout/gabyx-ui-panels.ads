--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł logiki prezentacji treści paneli interfejsu użytkownika.
--                   Przygotowuje sformatowane łańcuchy tekstowe dla pasków HUD,
--                   obsługuje podział na sloty w formacie Ultra-Wide (21:9)
--                   oraz kalkuluje zwężanie czcionki (Font Auto-Shrink).
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/layout/gabyx-ui-panels.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Types;
with Gabyx.UI.Types;

package Gabyx.UI.Panels is

   use Gabyx.Types;
   use Gabyx.UI.Types;

   --  ============================================================================
   --  PUBLICZNY INTERFEJS FORMATERÓW TREŚCI
   --  ============================================================================

   --  Zwraca sformatowany tekst dla Górnego Paska w zależności od widoku A/B
   function Get_Top_Bar_Text
     (View          : HUD_View_Type;
      Virtual_W     : Positive;
      Virtual_H     : Positive;
      Screen_W      : Positive;
      Screen_H      : Positive;
      Is_Ultra_Wide : Boolean;
      Active_Tier   : HUD_Tier_Type;
      Font_Family   : String;
      FPS           : Natural) return String;

   --  Zwraca sformatowany tekst dla Dolnego Paska w zależności od widoku A/B
   function Get_Bottom_Bar_Text
     (View          : HUD_View_Type;
      Is_Ultra_Wide : Boolean) return String;

   --  Oblicza optymalny rozmiar czcionki z uwzględnieniem Auto-Shrink (1..3 px)
   function Calculate_Auto_Shrink
     (Base_Size    : Font_Size_Type;
      Text_Width   : Float;
      Max_Slot_W   : Float) return Font_Size_Type;

end Gabyx.UI.Panels;
