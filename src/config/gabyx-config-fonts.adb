--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja parsera pliku fonts.toml. Odczytuje sciezki
--                    plikow TTF dla krojow Nerd Fonts oraz konfiguracje rozmiarow.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-fonts.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;
with Gabyx.Config.Helpers;

package body Gabyx.Config.Fonts is

   use type TOML.Any_Value_Kind;
   use Gabyx.Config.Helpers;

   function Get_Default_Configuration return Font_Configuration is
      Config : Font_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Font_Configuration
   is
      Config : Font_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line ("[CONFIG] Brak pliku " & File_Path & " - uzyto czcionki domyslnej.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         declare
            Fonts_Tab     : constant TOML.TOML_Value := (if Root.Has ("fonts") then Root.Get ("fonts") else Root);
            Preset_Choice : constant Integer := Read_Integer (Fonts_Tab, "active_preset", 1);
            Sub_Key       : constant String  := (if Preset_Choice = 2 then "preset_2" else "preset_1");
         begin
            if Root.Kind = TOML.TOML_Table and then Root.Has ("presets") then
               declare
                  Presets_Tab : constant TOML.TOML_Value := Root.Get ("presets");
               begin
                  if Presets_Tab.Kind = TOML.TOML_Table and then Presets_Tab.Has (Sub_Key) then
                     declare
                        Font_Tab : constant TOML.TOML_Value := Presets_Tab.Get (Sub_Key);
                     begin
                        Config.Family           := To_Unbounded_String
                          (Read_String (Font_Tab, "family", Default_Font_Family));
                        Config.Regular_Path     := To_Unbounded_String
                          (Read_String (Font_Tab, "regular_path", Default_Regular_Path));
                        Config.Bold_Path        := To_Unbounded_String
                          (Read_String (Font_Tab, "bold_path", Default_Bold_Path));
                        Config.Italic_Path      := To_Unbounded_String
                          (Read_String (Font_Tab, "italic_path", Default_Italic_Path));
                        Config.Bold_Italic_Path := To_Unbounded_String
                          (Read_String (Font_Tab, "bold_italic_path", Default_Bold_Italic_Path));
                     end;
                  end if;
               end;
            end if;
         end;

         if Root.Kind = TOML.TOML_Table and then Root.Has ("sizes") then
            declare
               Sizes_Tab : constant TOML.TOML_Value := Root.Get ("sizes");
               Raw_S     : constant Integer := Read_Integer (Sizes_Tab, "small", 14);
               Raw_R     : constant Integer := Read_Integer (Sizes_Tab, "regular", 18);
               Raw_T     : constant Integer := Read_Integer (Sizes_Tab, "title", 24);
               Raw_L     : constant Integer := Read_Integer (Sizes_Tab, "large", 32);
            begin
               if Raw_S in Font_Size_Type'Range then Config.Size_Small := Font_Size_Type (Raw_S); end if;
               if Raw_R in Font_Size_Type'Range then Config.Size_Regular := Font_Size_Type (Raw_R); end if;
               if Raw_T in Font_Size_Type'Range then Config.Size_Title := Font_Size_Type (Raw_T); end if;
               if Raw_L in Font_Size_Type'Range then Config.Size_Large := Font_Size_Type (Raw_L); end if;
            end;
         end if;

         if Root.Kind = TOML.TOML_Table and then Root.Has ("rendering") then
            declare
               Rend_Tab : constant TOML.TOML_Value := Root.Get ("rendering");
            begin
               Config.Spacing           := Read_Float (Rend_Tab, "spacing", 1.0);
               Config.Smooth_Filter     := Read_Boolean (Rend_Tab, "smooth_filter", True);
               Config.Polish_Diacritics := Read_Boolean (Rend_Tab, "polish_diacritics", True);
            end;
         end if;
      end;

      return Config;
   end Load_Configuration;

end Gabyx.Config.Fonts;
