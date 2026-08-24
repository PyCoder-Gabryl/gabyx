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
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib-menu.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.UI.Menu;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Menu is

   --  Renderuje ekran Menu Głównego oraz sprawdza interakcję kursora myszy
   procedure Render
     (State    : in out Gabyx.UI.Menu.Menu_State;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration;
      Selected : out Boolean);

end Gabyx.Drivers.Raylib.Menu;
