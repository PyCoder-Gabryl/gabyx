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
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib-audio.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Config.Audio;

package Gabyx.Drivers.Raylib.Audio is

   --  Inicjalizuje urządzenie audio oraz syntetyzuje efekty w pamięci RAM
   procedure Initialize (Audio_Cfg : Gabyx.Config.Audio.Audio_Configuration);

   --  Odtwarza krótki syntetyczny dźwięk nawigacji po menu (blip)
   procedure Play_Menu_Move;

   --  Odtwarza syntetyczny dźwięk zatwierdzenia wyboru (chime)
   procedure Play_Menu_Select;

   --  Zamyka podsystem audio i zwalnia zasoby
   procedure Close;

end Gabyx.Drivers.Raylib.Audio;
