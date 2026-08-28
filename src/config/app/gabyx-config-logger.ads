--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Specyfikacja modułu konfiguracji loggera i poziomów diagnostycznych.
--                   Definiuje rekord Logger_Configuration oraz interfejs odczytu logger.toml.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/app/gabyx-config-logger.ads
--  CREATED:         2026-08-28
--  ============================================================================


with Ada.Strings.Unbounded;

package Gabyx.Config.Logger is

   use Ada.Strings.Unbounded;

   Default_Config_Path : constant String := "data/config/logger.toml";

   type Logger_Configuration is record
      Console_Min_Level : Unbounded_String := To_Unbounded_String ("INFO");
      Console_Colored   : Boolean          := True;
      File_Min_Level    : Unbounded_String := To_Unbounded_String ("DEBUG");
      File_Enabled      : Boolean          := True;
      File_Path         : Unbounded_String := To_Unbounded_String ("logs/gabyx.json");
      Max_Archive_Days  : Positive         := 90;
      Max_Total_Size_MB : Positive         := 50;
   end record;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Logger_Configuration;

   function Get_Default_Configuration return Logger_Configuration;

end Gabyx.Config.Logger;
