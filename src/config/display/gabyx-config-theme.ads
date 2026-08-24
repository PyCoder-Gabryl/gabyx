--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Specyfikacja modułu konfiguracji motywu graficznego i kolorów.
--                   Zarządza centralną paletą barw (tła, akcenty, ramki, tekst)
--                   z gwarancją defensywnego ładowania z pliku data/config/theme.toml.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/display/gabyx-config-theme.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Types;

package Gabyx.Config.Theme is

   use Gabyx.Types;

   Default_Config_Path : constant String := "data/config/theme.toml";

   type Theme_Configuration is record
      Bg_App_Dark    : RGBA_Color := (R => 18,  G => 22,  B => 26,  A => 255);
      Bg_Header_Dark : RGBA_Color := (R => 26,  G => 34,  B => 45,  A => 255);
      Bg_Pane_Left   : RGBA_Color := (R => 22,  G => 27,  B => 34,  A => 255);
      Bg_Pane_Right  : RGBA_Color := (R => 14,  G => 17,  B => 20,  A => 255);
      Accent_Gold    : RGBA_Color := (R => 255, G => 203, B => 0,   A => 255);
      Accent_Cyan    : RGBA_Color := (R => 80,  G => 220, B => 240, A => 255);
      Accent_Crimson : RGBA_Color := (R => 90,  G => 20,  B => 35,  A => 255);
      Border_Muted   : RGBA_Color := (R => 60,  G => 75,  B => 95,  A => 255);
      Text_Primary   : RGBA_Color := (R => 245, G => 245, B => 245, A => 255);
      Text_Secondary : RGBA_Color := (R => 170, G => 170, B => 170, A => 255);
      Text_Disabled  : RGBA_Color := (R => 90,  G => 95,  B => 105, A => 255);
   end record;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Theme_Configuration;

   function Get_Default_Configuration return Theme_Configuration;

end Gabyx.Config.Theme;
