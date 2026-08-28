--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Główna fasada publicznego API podsystemu logowania Gabyx.
--                   Udostępnia procedury Log_Trace..Log_Critical dla całego silnika.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging.ads
--  CREATED:         2026-08-28
--  ============================================================================


with Gabyx.Config.Logger;

package Gabyx.Logging is

   --  6 poziomów wag zdarzeń (RFC 5424 / Syslog standard)
   type Log_Level is
     (Level_Trace,
      Level_Debug,
      Level_Info,
      Level_Warning,
      Level_Error,
      Level_Critical);

   --  Domeny architektoniczne silnika Gabyx
   type Log_Domain is
     (Domain_Engine,
      Domain_Config,
      Domain_Window,
      Domain_Render,
      Domain_Audio,
      Domain_Input,
      Domain_UI,
      Domain_Game,
      Domain_Save);

   function Level_To_String (Level : Log_Level) return String;
   function Domain_To_String (Domain : Log_Domain) return String;
   function String_To_Level (Str : String; Default : Log_Level) return Log_Level;

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
