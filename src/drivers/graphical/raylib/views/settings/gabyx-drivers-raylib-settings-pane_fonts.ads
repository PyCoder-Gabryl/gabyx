--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł widoku zakładki Typografia & Czcionki w oknie Ustawień.
--                   Zarządza krojami Nerd Fonts, suwakami rozmiarów i filtrem dwuliniowym.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_fonts.ads
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Settings.Pane_Fonts is

   procedure Render_Pane
     (Pane_X   : Integer;
      Pane_Y   : Integer;
      Pane_W   : Integer;
      Pane_H   : Integer;
      Font_Cfg : in out Gabyx.Config.Fonts.Font_Configuration;
      Changed  : out Boolean);

end Gabyx.Drivers.Raylib.Settings.Pane_Fonts;
