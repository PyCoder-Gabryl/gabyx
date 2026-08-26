--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł widoku zakładki Ekran & Okno w oknie Ustawień.
--                   Obsługuje wybór rozdzielczości (1..9), tryby okna, centrowanie ON/OFF,
--                   skalowanie HUD-u (Auto/Compact/Standard/HiDPI) oraz zoom siatki (24..96 px).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_window.ads
--  CREATED:         2026-08-25
--  ============================================================================


with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Settings.Pane_Window is

   procedure Render_Pane
     (Pane_X          : Integer;
      Pane_Y          : Integer;
      Pane_W          : Integer;
      Pane_H          : Integer;
      Staged_Preset   : in out Positive;
      Staged_Mode_Idx : in out Positive;
      Staged_Center   : in out Boolean;
      Staged_HUD_Idx  : in out Positive;
      Staged_Zoom_Idx : in out Positive;
      Font_Cfg        : Gabyx.Config.Fonts.Font_Configuration;
      Apply_Clicked   : out Boolean;
      Changed         : out Boolean);

end Gabyx.Drivers.Raylib.Settings.Pane_Window;
