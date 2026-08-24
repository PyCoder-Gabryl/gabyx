--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Logiczny model okna Ustawień w czystym SPARK. Zarządza 7 kategoriami
--                   konfiguracyjnymi, nawigacją klawiaturą i myszą oraz zapamiętuje stan,
--                   z którego wywołano panel (Menu Główne lub aktywna rozgrywka).
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/gabyx-ui-settings.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Types;

package Gabyx.UI.Settings with
   SPARK_Mode => On,
   Pure
is

   use Gabyx.Types;

   --  7 kategorii ustawień odpowiadających domenom silnika
   type Settings_Category_ID is
     (Cat_Window,
      Cat_Graphics,
      Cat_Fonts,
      Cat_HUD,
      Cat_Camera_Grid,
      Cat_Audio,
      Cat_Input);

   type Settings_State is record
      Selected_Category : Settings_Category_ID := Cat_Window;
      Previous_State    : App_State            := State_Main_Menu;
   end record;

   --  Przechodzi do kolejnej kategorii w dół
   procedure Select_Next (State : in out Settings_State);

   --  Przechodzi do poprzedniej kategorii w górę
   procedure Select_Prev (State : in out Settings_State);

   --  Zwraca nazwę kategorii dla lewego panelu
   function Get_Category_Name (Cat : Settings_Category_ID) return String;

   --  Zwraca szczegółowy opis kategorii dla nagłówka prawego panelu
   function Get_Category_Description (Cat : Settings_Category_ID) return String;

end Gabyx.UI.Settings;
