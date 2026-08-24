--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł renderowania i interakcji Menu Głównego w Raylib.
--                   Obsługuje centrowanie 8 przycisków, podświetlenie kursorem myszy
--                   (hover) oraz wyszarzanie pozycji zablokowanych (np. Kontynuuj/Zapisz).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/gabyx-drivers-raylib-menu.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Menu is

   procedure Initialize;

   procedure Process_Frame (Font_Cfg : Gabyx.Config.Fonts.Font_Configuration);

   procedure Set_Active_Game (Active : Boolean);

end Gabyx.Drivers.Raylib.Menu;
