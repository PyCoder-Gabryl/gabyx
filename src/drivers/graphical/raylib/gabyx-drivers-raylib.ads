--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib.ads
--  CREATED:         2026-08-22
--  ============================================================================


with Gabyx.Config;

package Gabyx.Drivers.Raylib is

   --  ============================================================================
   --  PUBLICZNY INTERFEJS STEROWNIKA RAYLIB
   --  ============================================================================

   --  Uruchamia okno graficzne Raylib i pętlę renderowania na podstawie konfiguracji
   procedure Run (Config : Gabyx.Config.Window_Configuration);

end Gabyx.Drivers.Raylib;

