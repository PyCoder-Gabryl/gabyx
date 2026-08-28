--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja parsera pliku logger.toml z defensywnym fallbackiem.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/app/gabyx-config-logger.adb
--  CREATED:         2026-08-28
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;
with Gabyx.Config.Helpers;

package body Gabyx.Config.Logger is

   use type TOML.Any_Value_Kind;
   use Gabyx.Config.Helpers;

   function Get_Default_Configuration return Logger_Configuration is
      Config : Logger_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Logger_Configuration
   is
      Config : Logger_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line ("[CONFIG] Brak pliku " & File_Path & " - uzyto konfiguracji loggera domyslnej.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         --  1. Sekcja [console]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("console") then
            declare
               Con_Tab : constant TOML.TOML_Value := Root.Get ("console");
            begin
               Config.Console_Min_Level := To_Unbounded_String
                 (Read_String (Con_Tab, "min_level", "INFO"));
               Config.Console_Colored := Read_Boolean (Con_Tab, "colored_output", True);
            end;
         end if;

         --  2. Sekcja [file]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("file") then
            declare
               Fil_Tab : constant TOML.TOML_Value := Root.Get ("file");
            begin
               Config.File_Min_Level := To_Unbounded_String
                 (Read_String (Fil_Tab, "min_level", "DEBUG"));
               Config.File_Enabled := Read_Boolean (Fil_Tab, "enabled", True);
               Config.File_Path := To_Unbounded_String
                 (Read_String (Fil_Tab, "file_path", "logs/gabyx.json"));
            end;
         end if;

         --  3. Sekcja [retention]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("retention") then
            declare
               Ret_Tab : constant TOML.TOML_Value := Root.Get ("retention");
               Days    : constant Integer := Read_Integer (Ret_Tab, "max_archive_days", 90);
               Size_MB : constant Integer := Read_Integer (Ret_Tab, "max_total_size_mb", 50);
            begin
               if Days > 0 then Config.Max_Archive_Days := Positive (Days); end if;
               if Size_MB > 0 then Config.Max_Total_Size_MB := Positive (Size_MB); end if;
            end;
         end if;
      end;

      return Config;
   end Load_Configuration;

end Gabyx.Config.Logger;
