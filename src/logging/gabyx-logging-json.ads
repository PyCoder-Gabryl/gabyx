--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Formater pojedynczych linii JSON (NDJSON) w czystym SPARK.
--                   Konwertuje wpis logu na ustrukturyzowany, jednowierszowy obiekt JSON.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging-json.ads
--  CREATED:         2026-08-28
--  ============================================================================


package Gabyx.Logging.JSON with
   SPARK_Mode => On
is

   --  Formatuje wpis jako jednowierszowy obiekt JSON Lines (NDJSON)
   function Format_NDJSON
     (Timestamp : String;
      Level     : Log_Level;
      Domain    : Log_Domain;
      Message   : String) return String;

end Gabyx.Logging.JSON;
