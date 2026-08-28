--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  --  DESCRIPTION:     Główna fasada publicznego API podsystemu logowania Gabyx.
--                   Udostępnia procedury Log_Trace..Log_Critical dla całego silnika.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging.ads
--  CREATED:         2026-08-28
--  ============================================================================


with Gabyx.Logging.Types;
with Gabyx.Config.Logger;

package Gabyx.Logging is

   use Gabyx.Logging.Types;

   procedure Initialize (Cfg : Gabyx.Config.Logger.Logger_Configuration);

   procedure Log
     (Level   : Log_Level;
      Domain  : Log_Domain;
      Message : String);

   procedure Log_Trace (Domain : Log_Domain; Message : String);
   procedure Log_Debug (Domain : Log_Domain; Message : String);
   procedure Log_Info (Domain : Log_Domain; Message : String);
   procedure Log_Warn (Domain : Log_Domain; Message : String);
   procedure Log_Error (Domain : Log_Domain; Message : String);
   procedure Log_Critical (Domain : Log_Domain; Message : String);

   procedure Shutdown;

end Gabyx.Logging;
