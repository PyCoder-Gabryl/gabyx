--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja parsera pliku theme.toml z defensywnym odczytem barw.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/display/gabyx-config-theme.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;
with Gabyx.Config.Helpers;

package body Gabyx.Config.Theme is

   use type TOML.Any_Value_Kind;
   use Gabyx.Config.Helpers;

   function Read_Color
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : RGBA_Color) return RGBA_Color
   is
   begin
      if Table.Kind = TOML.TOML_Table and then Table.Has (Key) then
         declare
            C_Tab : constant TOML.TOML_Value := Table.Get (Key);
            R_Val : constant Integer := Read_Integer (C_Tab, "r", Integer (Default.R));
            G_Val : constant Integer := Read_Integer (C_Tab, "g", Integer (Default.G));
            B_Val : constant Integer := Read_Integer (C_Tab, "b", Integer (Default.B));
            A_Val : constant Integer := Read_Integer (C_Tab, "a", Integer (Default.A));
         begin
            return
              (R => (if R_Val in Color_Component'Range then Color_Component (R_Val) else Default.R),
               G => (if G_Val in Color_Component'Range then Color_Component (G_Val) else Default.G),
               B => (if B_Val in Color_Component'Range then Color_Component (B_Val) else Default.B),
               A => (if A_Val in Color_Component'Range then Color_Component (A_Val) else Default.A));
         end;
      end if;
      return Default;
   end Read_Color;

   function Get_Default_Configuration return Theme_Configuration is
      Config : Theme_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Theme_Configuration
   is
      Config : Theme_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line ("[CONFIG] Brak pliku " & File_Path & " - uzyto motywu domyslnego.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         if Root.Kind = TOML.TOML_Table and then Root.Has ("backgrounds") then
            declare
               Bg_Tab : constant TOML.TOML_Value := Root.Get ("backgrounds");
            begin
               Config.Bg_App_Dark    := Read_Color (Bg_Tab, "app_dark", Config.Bg_App_Dark);
               Config.Bg_Header_Dark := Read_Color (Bg_Tab, "header_dark", Config.Bg_Header_Dark);
               Config.Bg_Pane_Left   := Read_Color (Bg_Tab, "pane_left", Config.Bg_Pane_Left);
               Config.Bg_Pane_Right  := Read_Color (Bg_Tab, "pane_right", Config.Bg_Pane_Right);
            end;
         end if;

         if Root.Kind = TOML.TOML_Table and then Root.Has ("accents") then
            declare
               Acc_Tab : constant TOML.TOML_Value := Root.Get ("accents");
            begin
               Config.Accent_Gold    := Read_Color (Acc_Tab, "gold", Config.Accent_Gold);
               Config.Accent_Cyan    := Read_Color (Acc_Tab, "cyan", Config.Accent_Cyan);
               Config.Accent_Crimson := Read_Color (Acc_Tab, "crimson", Config.Accent_Crimson);
            end;
         end if;

         if Root.Kind = TOML.TOML_Table and then Root.Has ("borders") then
            declare
               Bor_Tab : constant TOML.TOML_Value := Root.Get ("borders");
            begin
               Config.Border_Muted := Read_Color (Bor_Tab, "muted", Config.Border_Muted);
            end;
         end if;
      end;

      return Config;
   end Load_Configuration;

end Gabyx.Config.Theme;
