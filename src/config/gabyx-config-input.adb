--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja parsera pliku input.toml. Odczytuje przypisania
--                    klawiszy dla systemu, przelacznikow HUD-u, presetow i ruchu WSAD.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-input.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;
with Gabyx.Config.Helpers;

package body Gabyx.Config.Input is

   use Gabyx.Config.Helpers;

   function Get_Default_Configuration return Input_Configuration is
      Config : Input_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Input_Configuration
   is
      Config : Input_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line ("[CONFIG] Brak pliku " & File_Path & " - uzyto konfiguracji wejscia domyslnej.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         --  1. Sekcja [system]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("system") then
            declare
               Sys_Tab : constant TOML.TOML_Value := Root.Get ("system");
            begin
               Config.Quit := To_Unbounded_String (Read_String (Sys_Tab, "quit", "ESCAPE"));
               Config.Toggle_Borderless := To_Unbounded_String (Read_String (Sys_Tab, "toggle_borderless", "B"));
            end;
         end if;

         --  2. Sekcja [hud]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("hud") then
            declare
               HUD_Tab : constant TOML.TOML_Value := Root.Get ("hud");
            begin
               Config.Toggle_Top_View    := To_Unbounded_String (Read_String (HUD_Tab, "toggle_top_view", "G"));
               Config.Toggle_Bottom_View := To_Unbounded_String (Read_String (HUD_Tab, "toggle_bottom_view", "D"));
               Config.Toggle_Font_Family := To_Unbounded_String (Read_String (HUD_Tab, "toggle_font_family", "F"));
               Config.Tier_Auto          := To_Unbounded_String (Read_String (HUD_Tab, "tier_auto", "ALT+0"));
               Config.Tier_Compact       := To_Unbounded_String (Read_String (HUD_Tab, "tier_compact", "ALT+1"));
               Config.Tier_Standard      := To_Unbounded_String (Read_String (HUD_Tab, "tier_standard", "ALT+2"));
               Config.Tier_HiDPI         := To_Unbounded_String (Read_String (HUD_Tab, "tier_hidpi", "ALT+3"));
            end;
         end if;

         --  3. Sekcja [presets]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("presets") then
            declare
               Pre_Tab : constant TOML.TOML_Value := Root.Get ("presets");
            begin
               Config.Preset_1 := To_Unbounded_String (Read_String (Pre_Tab, "preset_1", "1"));
               Config.Preset_2 := To_Unbounded_String (Read_String (Pre_Tab, "preset_2", "2"));
               Config.Preset_3 := To_Unbounded_String (Read_String (Pre_Tab, "preset_3", "3"));
               Config.Preset_4 := To_Unbounded_String (Read_String (Pre_Tab, "preset_4", "4"));
               Config.Preset_5 := To_Unbounded_String (Read_String (Pre_Tab, "preset_5", "5"));
               Config.Preset_6 := To_Unbounded_String (Read_String (Pre_Tab, "preset_6", "6"));
               Config.Preset_7 := To_Unbounded_String (Read_String (Pre_Tab, "preset_7", "7"));
               Config.Preset_8 := To_Unbounded_String (Read_String (Pre_Tab, "preset_8", "8"));
               Config.Preset_9 := To_Unbounded_String (Read_String (Pre_Tab, "preset_9", "9"));
            end;
         end if;

         --  4. Sekcja [gameplay]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("gameplay") then
            declare
               Game_Tab : constant TOML.TOML_Value := Root.Get ("gameplay");
            begin
               Config.Move_North  := To_Unbounded_String (Read_String (Game_Tab, "move_north", "W"));
               Config.Move_South  := To_Unbounded_String (Read_String (Game_Tab, "move_south", "S"));
               Config.Move_West   := To_Unbounded_String (Read_String (Game_Tab, "move_west", "A"));
               Config.Move_East   := To_Unbounded_String (Read_String (Game_Tab, "move_east", "E"));
               Config.Action_Wait := To_Unbounded_String (Read_String (Game_Tab, "action_wait", "SPACE"));
            end;
         end if;
      end;

      return Config;
   end Load_Configuration;

end Gabyx.Config.Input;
