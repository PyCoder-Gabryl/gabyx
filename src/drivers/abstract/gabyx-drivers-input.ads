--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Abstrakcyjny interfejs wejścia dla architektury Omni-Engine.
--                   Definiuje wspólny kontrakt pobierania poleceń gry (Game_Command)
--                   dla wszystkich sterowników prezentacji (Raylib, ANSI, Ncurses).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/abstract/gabyx-drivers-input.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Commands;

package Gabyx.Drivers.Input is

   --  ============================================================================
   --  ABSTRAKCYJNY INTERFEJS STEROWNIKA WEJŚCIA
   --  ============================================================================

   type Input_Driver is interface;

   --  Pobiera i tłumaczy bieżące zdarzenie wejściowe na domenowe polecenie gry
   function Poll_Command
     (Driver : in out Input_Driver) return Gabyx.Commands.Game_Command is abstract;

end Gabyx.Drivers.Input;
