--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł zapisu ustrukturyzowanych linii NDJSON do pliku logs/gabyx.json.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging-file.ads
--  CREATED:         2026-08-28
--  ============================================================================


package Gabyx.Logging.File is

   procedure Initialize (Target_Path : String);

   procedure Write_Entry (JSON_Line : String);

   procedure Close;

   function Is_Active return Boolean;

end Gabyx.Logging.File;
