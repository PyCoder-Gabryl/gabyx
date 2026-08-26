--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł widoku zakładki Grafika & FPS w oknie Ustawień.
--                   Obsługuje wybór klatkarza (30..165 FPS), synchronizację V-Sync oraz proporcje.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_graphics.ads
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.Config.Window;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Settings.Pane_Graphics is

   procedure Render_Pane
     (Pane_X   : Integer;
      Pane_Y   : Integer;
      Pane_W   : Integer;
      Pane_H   : Integer;
      Win_Cfg  : in out Gabyx.Config.Window.Window_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration;
      Changed  : out Boolean);

end Gabyx.Drivers.Raylib.Settings.Pane_Graphics;
