--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja parsera pliku hud.toml. Odczytuje profile
--                    wysokosci kontenerow oraz kolory dla widokow A i B.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-hud.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;
with Gabyx.Config.Helpers;

package body Gabyx.Config.HUD is

   use Gabyx.Config.Helpers;

   function Get_Default_Configuration return HUD_Configuration is
      Config : HUD_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return HUD_Configuration
   is
      Config : HUD_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line ("[CONFIG] Brak pliku " & File_Path & " - uzyto konfiguracji HUD domyslnej.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         if Root.Kind = TOML.TOML_Table and then Root.Has ("hud") then
            declare
               HUD_Tab  : constant TOML.TOML_Value := Root.Get ("hud");
               Tier_Str : constant String := Read_String (HUD_Tab, "active_tier", "auto");
            begin
               if Tier_Str = "compact" then
                  Config.Active_Tier := HUD_Compact;
               elsif Tier_Str = "standard" then
                  Config.Active_Tier := HUD_Standard;
               elsif Tier_Str = "hidpi" then
                  Config.Active_Tier := HUD_HiDPI;
               else
                  Config.Active_Tier := HUD_Auto;
               end if;
            end;
         end if;
      end;

      return Config;
   end Load_Configuration;

end Gabyx.Config.HUD;
