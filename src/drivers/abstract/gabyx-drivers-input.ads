--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Abstrakcyjny interfejs wejscia dla architektury Omni-Engine.
--                    Definiuje wspolny kontrakt pobierania polecen gry (Game_Command)
--                    dla wszystkich sterownikow prezentacji (Raylib, ANSI, Ncurses).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/abstract/gabyx-drivers-input.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Commands;

package Gabyx.Drivers.Input is

   --  Pobiera i tlumaczy biezace zdarzenie wejsciowe na polecenie gry
   function Get_Next_Command return Gabyx.Commands.Game_Command is abstract;

end Gabyx.Drivers.Input;
