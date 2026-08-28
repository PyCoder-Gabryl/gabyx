--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja składania rekordu JSON Lines w SPARK.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging-json.adb
--  CREATED:         2026-08-28
--  ============================================================================


package body Gabyx.Logging.JSON with
   SPARK_Mode => On
is

   function Format_NDJSON
     (Timestamp : String;
      Level     : Log_Level;
      Domain    : Log_Domain;
      Message   : String) return String
   is
   begin
      return "{""timestamp"":""" & Timestamp &
             """,""level"":""" & Level_To_String (Level) &
             """,""domain"":""" & Domain_To_String (Domain) &
             """,""message"":""" & Message & """}";
   end Format_NDJSON;

end Gabyx.Logging.JSON;
