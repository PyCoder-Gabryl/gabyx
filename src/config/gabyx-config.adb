--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja modułu odczytu konfiguracji TOML.
--                   Wykorzystuje bibliotekę ada_toml do bezpiecznego
--                   parsowania plików konfiguracyjnych, oferując pełną
--                   odporność na brakujące klucze, błędne typy i brak pliku.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config.adb
--  CREATED:         2026-08-22
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;

package body Gabyx.Config is

   --  Otwarcie widoczności operatorów dla typu wyliczeniowego z pakietu TOML
   use type TOML.Any_Value_Kind;

   --  ============================================================================
   --  DEKLARACJE FUNKCJI WEWNĘTRZNYCH (WYMÓG STYLU -gnatys)
   --  ============================================================================

   function Read_String
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : String) return String;

   function Read_Boolean
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Boolean) return Boolean;

   function Read_Integer
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Integer) return Integer;

   --  ============================================================================
   --  POMOCNICZE FUNKCJE WEWNĘTRZNE (BEZPIECZNY ODCZYT TOML)
   --  ============================================================================

   function Read_String
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : String) return String
   is
   begin
      if Table.Kind = TOML.TOML_Table and then Table.Has (Key) then
         declare
            Val : constant TOML.TOML_Value := Table.Get (Key);
         begin
            if Val.Kind = TOML.TOML_String then
               return Val.As_String;
            end if;
         end;
      end if;
      return Default;
   end Read_String;

   function Read_Boolean
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Boolean) return Boolean
   is
   begin
      if Table.Kind = TOML.TOML_Table and then Table.Has (Key) then
         declare
            Val : constant TOML.TOML_Value := Table.Get (Key);
         begin
            if Val.Kind = TOML.TOML_Boolean then
               return Val.As_Boolean;
            end if;
         end;
      end if;
      return Default;
   end Read_Boolean;

   function Read_Integer
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Integer) return Integer
   is
   begin
      if Table.Kind = TOML.TOML_Table and then Table.Has (Key) then
         declare
            Val : constant TOML.TOML_Value := Table.Get (Key);
         begin
            if Val.Kind = TOML.TOML_Integer then
               return Integer (Val.As_Integer);
            end if;
         end;
      end if;
      return Default;
   end Read_Integer;

   --  ============================================================================
   --  IMPLEMENTACJA INTERFEJSU PUBLICZNEGO
   --  ============================================================================

   function Get_Default_Configuration return Window_Configuration is
      Config : Window_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Load_Window_Configuration
     (File_Path : String := Default_Config_Path) return Window_Configuration
   is
      Config : Window_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line
           ("[CONFIG] Nie odnaleziono pliku " & File_Path & " - uzyto konfiguracji domyslnej.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         --  1. Sekcja [window]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("window") then
            declare
               Window_Tab : constant TOML.TOML_Value := Root.Get ("window");
               Preset_Num : constant Integer := Read_Integer (Window_Tab, "active_preset", 0);
            begin
               Config.Title := To_Unbounded_String
                 (Read_String (Window_Tab, "title", Default_Window_Title));
               Config.Fullscreen    := Read_Boolean (Window_Tab, "fullscreen", False);
               Config.Resizable     := Read_Boolean (Window_Tab, "resizable", False);
               Config.Borderless    := Read_Boolean (Window_Tab, "borderless", False);
               Config.High_DPI      := Read_Boolean (Window_Tab, "high_dpi", True);
               Config.Always_On_Top := Read_Boolean (Window_Tab, "always_on_top", False);

               case Preset_Num is
                  when 1 => Config.Active_Preset := Preset_1;
                  when 2 => Config.Active_Preset := Preset_2;
                  when 3 => Config.Active_Preset := Preset_3;
                  when 4 => Config.Active_Preset := Preset_4;
                  when others => Config.Active_Preset := Auto_Default;
               end case;
            end;
         end if;

         --  2. Sekcja [presets] - dopasowanie wymiarów
         if Root.Kind = TOML.TOML_Table and then Root.Has ("presets") then
            declare
               Presets_Tab : constant TOML.TOML_Value := Root.Get ("presets");
               Sub_Key     : constant String :=
                 (case Config.Active_Preset is
                     when Preset_1     => "preset_1",
                     when Preset_2     => "preset_2",
                     when Preset_3     => "preset_3",
                     when Preset_4     => "preset_4",
                     when Auto_Default => "preset_3");
            begin
               if Presets_Tab.Kind = TOML.TOML_Table and then Presets_Tab.Has (Sub_Key) then
                  declare
                     Preset_Tab : constant TOML.TOML_Value := Presets_Tab.Get (Sub_Key);
                     Raw_W      : constant Integer := Read_Integer (Preset_Tab, "width", 1280);
                     Raw_H      : constant Integer := Read_Integer (Preset_Tab, "height", 720);
                  begin
                     if Raw_W in Width_Type'Range then
                        Config.Width := Width_Type (Raw_W);
                     end if;
                     if Raw_H in Height_Type'Range then
                        Config.Height := Height_Type (Raw_H);
                     end if;
                  end;
               end if;
            end;
         end if;

         --  3. Sekcja [graphics]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("graphics") then
            declare
               Gfx_Tab : constant TOML.TOML_Value := Root.Get ("graphics");
               Raw_FPS : constant Integer := Read_Integer (Gfx_Tab, "target_fps", 0);
            begin
               Config.VSync := Read_Boolean (Gfx_Tab, "vsync", True);
               Config.Maintain_Aspect_Ratio :=
                 Read_Boolean (Gfx_Tab, "maintain_aspect_ratio", True);

               if Raw_FPS in 0 | 30 | 60 | 75 | 120 then
                  Config.Target_FPS := Target_FPS_Type (Raw_FPS);
               else
                  Config.Target_FPS := 0;
               end if;
            end;
         end if;

         --  4. Sekcja [background]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("background") then
            declare
               Bg_Tab : constant TOML.TOML_Value := Root.Get ("background");
               Raw_R  : constant Integer := Read_Integer (Bg_Tab, "r", 18);
               Raw_G  : constant Integer := Read_Integer (Bg_Tab, "g", 22);
               Raw_B  : constant Integer := Read_Integer (Bg_Tab, "b", 26);
               Raw_A  : constant Integer := Read_Integer (Bg_Tab, "a", 255);
            begin
               if Raw_R in Color_Component'Range then
                  Config.Clear_Color.R := Color_Component (Raw_R);
               end if;
               if Raw_G in Color_Component'Range then
                  Config.Clear_Color.G := Color_Component (Raw_G);
               end if;
               if Raw_B in Color_Component'Range then
                  Config.Clear_Color.B := Color_Component (Raw_B);
               end if;
               if Raw_A in Color_Component'Range then
                  Config.Clear_Color.A := Color_Component (Raw_A);
               end if;
            end;
         end if;

      end;

      return Config;
   end Load_Window_Configuration;

end Gabyx.Config;
