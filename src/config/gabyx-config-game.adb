--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja parsera pliku game.toml. Bezpiecznie odczytuje
--                   parametry startowe, profil gracza oraz generuje ścieżkę zapisu.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-game.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;
with Gabyx.Config.Helpers;

package body Gabyx.Config.Game is

   use type TOML.Any_Value_Kind;
   use Gabyx.Config.Helpers;

   function Get_Default_Configuration return Game_Configuration is
      Config : Game_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Get_Active_Save_Directory
     (Config : Game_Configuration) return String
   is
   begin
      return "data/saves/" & To_String (Config.Active_Profile) & "/";
   end Get_Active_Save_Directory;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Game_Configuration
   is
      Config : Game_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line ("[CONFIG] Brak pliku " & File_Path & " - uzyto konfiguracji gry domyslnej.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         --  1. Sekcja [app]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("app") then
            declare
               App_Tab : constant TOML.TOML_Value := Root.Get ("app");
            begin
               Config.Splash_Duration_Sec := Read_Float (App_Tab, "splash_duration_sec", 1.0);
               Config.Language := To_Unbounded_String (Read_String (App_Tab, "language", "pl"));
               Config.Dev_Mode := Read_Boolean (App_Tab, "dev_mode", True);
            end;
         end if;

         --  2. Sekcja [profile]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("profile") then
            declare
               Prof_Tab : constant TOML.TOML_Value := Root.Get ("profile");
            begin
               Config.Active_Profile := To_Unbounded_String
                 (Read_String (Prof_Tab, "active_profile", "default"));
            end;
         end if;
      end;

      return Config;
   end Load_Configuration;

end Gabyx.Config.Game;
