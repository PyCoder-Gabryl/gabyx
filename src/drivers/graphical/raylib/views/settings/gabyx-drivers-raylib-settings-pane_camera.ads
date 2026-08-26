--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł widoku zakładki Siatka & Kamera w oknie Ustawień.
--                   Zarządza martwą strefą, czasem LERP, widocznością i kolorami siatki.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_camera.ads
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.Config.Camera;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Settings.Pane_Camera is

   procedure Render_Pane
     (Pane_X     : Integer;
      Pane_Y     : Integer;
      Pane_W     : Integer;
      Pane_H     : Integer;
      Camera_Cfg : in out Gabyx.Config.Camera.Camera_Configuration;
      Font_Cfg   : Gabyx.Config.Fonts.Font_Configuration;
      Changed    : out Boolean);

end Gabyx.Drivers.Raylib.Settings.Pane_Camera;
