--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Główny punkt wejścia sterownika graficznego opartego na Raylib.
--                   Orkiestruje cyklem życia okna, pętlą zdarzeń, synchronizacją
--                   pamięci podręcznej układu (Layout Cache) oraz renderowaniem.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib.ads
--  CREATED:         2026-08-22
--  ============================================================================


with Gabyx.Config.Window;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib is

   --  Uruchamia pętlę główną sterownika graficznego Raylib
   procedure Run
     (Config   : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration);

end Gabyx.Drivers.Raylib;
