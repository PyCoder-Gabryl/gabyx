--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł widoku zakładki Interfejs HUD w oknie Ustawień.
--                   Zarządza profilami Compact/Standard/HiDPI oraz widokami A/B.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_hud.ads
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.Config.HUD;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Settings.Pane_HUD is

   procedure Render_Pane
     (Pane_X   : Integer;
      Pane_Y   : Integer;
      Pane_W   : Integer;
      Pane_H   : Integer;
      HUD_Cfg  : in out Gabyx.Config.HUD.HUD_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration;
      Changed  : out Boolean);

end Gabyx.Drivers.Raylib.Settings.Pane_HUD;
