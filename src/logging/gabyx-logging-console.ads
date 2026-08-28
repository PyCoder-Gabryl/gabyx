--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł wyjścia terminalowego z kolorowaniem sekwencjami ANSI.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging-console.ads
--  CREATED:         2026-08-28
--  ============================================================================


with Gabyx.Logging.Types;

package Gabyx.Logging.Console is

   use Gabyx.Logging.Types;

   --  Wypisuje sformatowany log do standardowego wyjścia konsoli
   procedure Print
     (Timestamp  : String;
      Level      : Log_Level;
      Domain     : Log_Domain;
      Message    : String;
      Use_Colors : Boolean);

end Gabyx.Logging.Console;
