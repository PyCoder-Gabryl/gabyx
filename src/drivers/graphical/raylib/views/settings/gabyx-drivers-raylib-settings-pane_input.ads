--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł widoku zakładki Sterowanie & Klawiatura w oknie Ustawień.
--                   Wyświetla podgląd przypisań klawiszy oraz przycisk resetu do domyślnych.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_input.ads
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.Config.Input;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Settings.Pane_Input is

   procedure Render_Pane
     (Pane_X    : Integer;
      Pane_Y    : Integer;
      Pane_W    : Integer;
      Pane_H    : Integer;
      Input_Cfg : in out Gabyx.Config.Input.Input_Configuration;
      Font_Cfg  : Gabyx.Config.Fonts.Font_Configuration;
      Changed   : out Boolean);

end Gabyx.Drivers.Raylib.Settings.Pane_Input;
