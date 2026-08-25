--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł widoku zakładki Dźwięk & Audio w oknie Ustawień.
--                   Renderuje suwaki głośności, checkboxy opcji oraz przycisk testowy SFX.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/gabyx-drivers-raylib-settings-pane_audio.ads
--  CREATED:         2026-08-25
--  ============================================================================


with Gabyx.Config.Audio;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Settings.Pane_Audio is

   --  Renderuje zawartość zakładki Audio, obsługuje suwaki, checkboxy i przycisk testowy
   procedure Render_Pane
     (Pane_X    : Integer;
      Pane_Y    : Integer;
      Pane_W    : Integer;
      Pane_H    : Integer;
      Audio_Cfg : in out Gabyx.Config.Audio.Audio_Configuration;
      Font_Cfg  : Gabyx.Config.Fonts.Font_Configuration;
      Changed   : out Boolean);

end Gabyx.Drivers.Raylib.Settings.Pane_Audio;
