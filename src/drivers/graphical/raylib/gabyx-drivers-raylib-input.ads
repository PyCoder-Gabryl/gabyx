--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Sterownik wejścia dla biblioteki Raylib. Odpytuje
--                    stan klawiatury i tłumaczy kombinacje klawiszy na
--                    domenowe polecenia Game_Command (Command Pattern).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib-input.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Commands;

package Gabyx.Drivers.Raylib.Input is

   --  Odpytuje stan wejścia Raylib i zwraca pojedyncze polecenie gry
   function Poll_Command return Gabyx.Commands.Game_Command;

end Gabyx.Drivers.Raylib.Input;
