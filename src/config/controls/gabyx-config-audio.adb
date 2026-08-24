--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja parsera pliku audio.toml. Bezpiecznie odczytuje
--                   poziomy głośności suwaków z gwarancją bezpiecznych wartości.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/controls/gabyx-config-audio.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;
with Gabyx.Config.Helpers;

package body Gabyx.Config.Audio is

   use type TOML.Any_Value_Kind;
   use Gabyx.Config.Helpers;

   function Get_Default_Configuration return Audio_Configuration is
      Config : Audio_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Audio_Configuration
   is
      Config : Audio_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line ("[CONFIG] Brak pliku " & File_Path & " - uzyto konfiguracji audio domyslnej.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         --  1. Sekcja [volume]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("volume") then
            declare
               Vol_Tab : constant TOML.TOML_Value := Root.Get ("volume");
               Raw_M   : constant Integer := Read_Integer (Vol_Tab, "master", 80);
               Raw_Mus : constant Integer := Read_Integer (Vol_Tab, "music", 70);
               Raw_SFX : constant Integer := Read_Integer (Vol_Tab, "sfx", 90);
               Raw_Amb : constant Integer := Read_Integer (Vol_Tab, "ambient", 60);
            begin
               if Raw_M in Volume_Level'Range then Config.Master_Volume := Volume_Level (Raw_M); end if;
               if Raw_Mus in Volume_Level'Range then Config.Music_Volume := Volume_Level (Raw_Mus); end if;
               if Raw_SFX in Volume_Level'Range then Config.SFX_Volume := Volume_Level (Raw_SFX); end if;
               if Raw_Amb in Volume_Level'Range then Config.Ambient_Volume := Volume_Level (Raw_Amb); end if;
               Config.Is_Muted := Read_Boolean (Vol_Tab, "muted", False);
            end;
         end if;

         --  2. Sekcja [sfx]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("sfx") then
            declare
               SFX_Tab : constant TOML.TOML_Value := Root.Get ("sfx");
            begin
               Config.UI_Clicks_Enabled := Read_Boolean (SFX_Tab, "ui_clicks_enabled", True);
            end;
         end if;
      end;

      return Config;
   end Load_Configuration;

end Gabyx.Config.Audio;
