--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Abstrakcyjny interfejs sterowników wyświetlania (Display Driver).
--                   Definiuje uniwersalny cykl życia (inicjalizacja, pętla wykonawcza,
--                   zamknięcie) dla dowolnego silnika renderowania (Raylib, SDL2, ANSI TUI).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/abstract/gabyx-drivers-display.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Config.Window;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Display is

   --  ============================================================================
   --  ABSTRAKCYJNY INTERFEJS STEROWNIKA WYŚWIETLANIA (OMNI-ENGINE)
   --  ============================================================================

   type Display_Driver is interface;

   --  Główna procedura uruchomieniowa sterownika wyświetlania
   procedure Start
     (Driver   : in out Display_Driver;
      Win_Cfg  : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration) is abstract;

end Gabyx.Drivers.Display;
