--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Czyste definicje typów dla podsystemu logowania w SPARK.
--                   Definiuje 6 poziomów wag zdarzeń (Trace..Critical) oraz domeny silnika.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging-types.ads
--  CREATED:         2026-08-28
--  ============================================================================


package Gabyx.Logging.Types with
   SPARK_Mode => On,
   Pure
is

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

end Gabyx.Logging.Types;
