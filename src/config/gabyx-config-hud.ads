--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja konfiguracji interfejsu uzytkownika (HUD).
--                    Zarzadza profilami Compact, Standard, HiDPI oraz paleta
--                    kolorystyczna tla dla poszczegolnych stanow widokow A/B.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-hud.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Types;
with Gabyx.UI.Types;

package Gabyx.Config.HUD is

   use Gabyx.Types;
   use Gabyx.UI.Types;

   Default_Config_Path : constant String := "data/config/hud.toml";

   type HUD_Configuration is record
      Active_Tier         : HUD_Tier_Type       := HUD_Auto;
      Compact_Tier        : HUD_Tier_Dimensions := (Top_Height => 32, Bottom_Height => 96,  Font_Size => 14);
      Standard_Tier       : HUD_Tier_Dimensions := (Top_Height => 40, Bottom_Height => 120, Font_Size => 18);
      HiDPI_Tier          : HUD_Tier_Dimensions := (Top_Height => 80, Bottom_Height => 240, Font_Size => 24);
      Color_Top_View_A    : RGBA_Color          := (R => 42, G => 52, B => 65, A => 255);
      Color_Top_View_B    : RGBA_Color          := (R => 52, G => 48, B => 70, A => 255);
      Color_Bottom_View_A : RGBA_Color          := (R => 38, G => 44, B => 54, A => 255);
      Color_Bottom_View_B : RGBA_Color          := (R => 32, G => 50, B => 56, A => 255);
      Color_Viewport      : RGBA_Color          := (R => 90, G => 20, B => 35, A => 255);
   end record;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return HUD_Configuration;

   function Get_Default_Configuration return HUD_Configuration;

end Gabyx.Config.HUD;
