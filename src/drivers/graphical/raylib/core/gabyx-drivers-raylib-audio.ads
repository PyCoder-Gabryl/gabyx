--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł obsługi audio i syntetycznych efektów dźwiękowych w Raylib.
--                   Generuje proceduralne fale dźwiękowe PCM w pamięci RAM dla kliknięć
--                   i nawigacji w menu bez konieczności posiadania zewnętrznych plików audio.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/core/gabyx-drivers-raylib-audio.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Config.Audio;

package Gabyx.Drivers.Raylib.Audio is

   procedure Initialize (Audio_Cfg : Gabyx.Config.Audio.Audio_Configuration);

   --  Dźwięki Menu Głównego
   procedure Play_Menu_Move;
   procedure Play_Menu_Select;

   --  Dedykowane dźwięki panelu Ustawień (niższe tony i miękkie przejścia)
   procedure Play_Settings_Open;
   procedure Play_Settings_Move;

   procedure Close;

end Gabyx.Drivers.Raylib.Audio;
