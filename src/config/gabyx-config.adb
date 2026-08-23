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

   function Read_Float
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Float) return Float;

   function Parse_Display_Mode (Mode_Str : String) return Display_Mode_Type;

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

   function Read_Float
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Float) return Float
   is
   begin
      if Table.Kind = TOML.TOML_Table and then Table.Has (Key) then
         declare
            Val : constant TOML.TOML_Value := Table.Get (Key);
         begin
            if Val.Kind = TOML.TOML_Integer then
               return Float (Val.As_Integer);
            end if;
         end;
      end if;
      return Default;
   end Read_Float;

   function Parse_Display_Mode (Mode_Str : String) return Display_Mode_Type is
   begin
      if Mode_Str = "borderless" then
         return Borderless;
      elsif Mode_Str = "borderless_fullscreen" then
         return Borderless_Fullscreen;
      else
         return Windowed;
      end if;
   end Parse_Display_Mode;

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
               Mode_Raw   : constant String := Read_String (Window_Tab, "display_mode", "windowed");
            begin
               Config.Title := To_Unbounded_String
                 (Read_String (Window_Tab, "title", Default_Window_Title));
               Config.Display_Mode     := Parse_Display_Mode (Mode_Raw);
               Config.Center_On_Screen := Read_Boolean (Window_Tab, "center_on_screen", True);
               Config.Monitor_Index    := Natural (Read_Integer (Window_Tab, "monitor_index", 0));
               Config.Resizable        := Read_Boolean (Window_Tab, "resizable", False);
               Config.Always_On_Top    := Read_Boolean (Window_Tab, "always_on_top", False);
               Config.High_DPI         := Read_Boolean (Window_Tab, "high_dpi", True);

               case Preset_Num is
                  when 1 => Config.Active_Preset := Preset_1;
                  when 2 => Config.Active_Preset := Preset_2;
                  when 3 => Config.Active_Preset := Preset_3;
                  when 4 => Config.Active_Preset := Preset_4;
                  when 5 => Config.Active_Preset := Preset_5;
                  when 6 => Config.Active_Preset := Preset_6;
                  when 7 => Config.Active_Preset := Preset_7;
                  when 8 => Config.Active_Preset := Preset_8;
                  when 9 => Config.Active_Preset := Preset_9;
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
                     when Preset_5     => "preset_5",
                     when Preset_6     => "preset_6",
                     when Preset_7     => "preset_7",
                     when Preset_8     => "preset_8",
                     when Preset_9     => "preset_9",
                     when Auto_Default => "preset_1");
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

               if Raw_FPS in 0 | 30 | 60 | 75 | 120 | 144 then
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

         --  5. Sekcja [border_bars]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("border_bars") then
            declare
               Bars_Tab : constant TOML.TOML_Value := Root.Get ("border_bars");
               Raw_R    : constant Integer := Read_Integer (Bars_Tab, "r", 90);
               Raw_G    : constant Integer := Read_Integer (Bars_Tab, "g", 20);
               Raw_B    : constant Integer := Read_Integer (Bars_Tab, "b", 35);
               Raw_A    : constant Integer := Read_Integer (Bars_Tab, "a", 255);
            begin
               if Raw_R in Color_Component'Range then
                  Config.Border_Bars_Color.R := Color_Component (Raw_R);
               end if;
               if Raw_G in Color_Component'Range then
                  Config.Border_Bars_Color.G := Color_Component (Raw_G);
               end if;
               if Raw_B in Color_Component'Range then
                  Config.Border_Bars_Color.B := Color_Component (Raw_B);
               end if;
               if Raw_A in Color_Component'Range then
                  Config.Border_Bars_Color.A := Color_Component (Raw_A);
               end if;
            end;
         end if;

      end;

      return Config;
   end Load_Window_Configuration;

   function Get_Default_Font_Configuration return Font_Configuration is
      Config : Font_Configuration;
   begin
      return Config;
   end Get_Default_Font_Configuration;

   function Load_Font_Configuration
     (File_Path : String := Default_Fonts_Config_Path) return Font_Configuration
   is
      Config : Font_Configuration := Get_Default_Font_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line
           ("[CONFIG] Nie odnaleziono pliku " & File_Path & " - uzyto czcionki domyslnej.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         declare
            Fonts_Tab : constant TOML.TOML_Value :=
              (if Root.Has ("fonts") then Root.Get ("fonts")
               elsif Root.Has ("font") then Root.Get ("font")
               else Root);

            Preset_Choice : constant Integer :=
              Read_Integer (Fonts_Tab, "active_preset", 1);

            Sub_Key : constant String :=
              (if Preset_Choice = 2 then "preset_2" else "preset_1");
         begin
            if Root.Kind = TOML.TOML_Table and then Root.Has ("presets") then
               declare
                  Presets_Tab : constant TOML.TOML_Value := Root.Get ("presets");
               begin
                  if Presets_Tab.Kind = TOML.TOML_Table and then Presets_Tab.Has (Sub_Key) then
                     declare
                        Font_Tab : constant TOML.TOML_Value := Presets_Tab.Get (Sub_Key);
                     begin
                        Config.Family := To_Unbounded_String
                          (Read_String (Font_Tab, "family", Default_Font_Family));
                        Config.Regular_Path := To_Unbounded_String
                          (Read_String (Font_Tab, "regular_path", Default_Regular_Path));
                        Config.Bold_Path := To_Unbounded_String
                          (Read_String (Font_Tab, "bold_path", Default_Bold_Path));
                        Config.Italic_Path := To_Unbounded_String
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
               if Raw_S in Font_Size_Type'Range then
                  Config.Size_Small := Font_Size_Type (Raw_S);
               end if;
               if Raw_R in Font_Size_Type'Range then
                  Config.Size_Regular := Font_Size_Type (Raw_R);
               end if;
               if Raw_T in Font_Size_Type'Range then
                  Config.Size_Title := Font_Size_Type (Raw_T);
               end if;
               if Raw_L in Font_Size_Type'Range then
                  Config.Size_Large := Font_Size_Type (Raw_L);
               end if;
            end;
         end if;

         if Root.Kind = TOML.TOML_Table and then Root.Has ("rendering") then
            declare
               Rend_Tab : constant TOML.TOML_Value := Root.Get ("rendering");
            begin
               Config.Spacing := Read_Float (Rend_Tab, "spacing", 1.0);
               Config.Smooth_Filter :=
                 Read_Boolean (Rend_Tab, "smooth_filter", True);
               Config.Polish_Diacritics :=
                 Read_Boolean (Rend_Tab, "polish_diacritics", True);
            end;
         end if;

      end;

      return Config;
   end Load_Font_Configuration;

   function Get_Default_HUD_Configuration return HUD_Configuration is
      Config : HUD_Configuration;
   begin
      return Config;
   end Get_Default_HUD_Configuration;

   function Load_HUD_Configuration
     (File_Path : String := Default_HUD_Config_Path) return HUD_Configuration
   is
      Config : HUD_Configuration := Get_Default_HUD_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line
           ("[CONFIG] Nie odnaleziono pliku " & File_Path & " - uzyto konfiguracji HUD domyslnej.");
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
   end Load_HUD_Configuration;

   function Get_Default_Input_Configuration return Input_Configuration is
      Config : Input_Configuration;
   begin
      return Config;
   end Get_Default_Input_Configuration;

   function Load_Input_Configuration
     (File_Path : String := Default_Input_Config_Path) return Input_Configuration
   is
      Config : Input_Configuration := Get_Default_Input_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line
           ("[CONFIG] Nie odnaleziono pliku " & File_Path & " - uzyto konfiguracji wejscia domyslnej.");
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
               Config.Quit := To_Unbounded_String
                 (Read_String (Sys_Tab, "quit", "ESCAPE"));
               Config.Toggle_Borderless := To_Unbounded_String
                 (Read_String (Sys_Tab, "toggle_borderless", "B"));
            end;
         end if;

         --  2. Sekcja [hud]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("hud") then
            declare
               HUD_Tab : constant TOML.TOML_Value := Root.Get ("hud");
            begin
               Config.Toggle_Top_View := To_Unbounded_String
                 (Read_String (HUD_Tab, "toggle_top_view", "G"));
               Config.Toggle_Bottom_View := To_Unbounded_String
                 (Read_String (HUD_Tab, "toggle_bottom_view", "D"));
               Config.Toggle_Font_Family := To_Unbounded_String
                 (Read_String (HUD_Tab, "toggle_font_family", "F"));
               Config.Tier_Auto := To_Unbounded_String
                 (Read_String (HUD_Tab, "tier_auto", "ALT+0"));
               Config.Tier_Compact := To_Unbounded_String
                 (Read_String (HUD_Tab, "tier_compact", "ALT+1"));
               Config.Tier_Standard := To_Unbounded_String
                 (Read_String (HUD_Tab, "tier_standard", "ALT+2"));
               Config.Tier_HiDPI := To_Unbounded_String
                 (Read_String (HUD_Tab, "tier_hidpi", "ALT+3"));
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
               Config.Move_North := To_Unbounded_String (Read_String (Game_Tab, "move_north", "W"));
               Config.Move_South := To_Unbounded_String (Read_String (Game_Tab, "move_south", "S"));
               Config.Move_West  := To_Unbounded_String (Read_String (Game_Tab, "move_west", "A"));
               Config.Move_East  := To_Unbounded_String (Read_String (Game_Tab, "move_east", "E"));
               Config.Action_Wait := To_Unbounded_String (Read_String (Game_Tab, "action_wait", "SPACE"));
            end;
         end if;

      end;

      return Config;
   end Load_Input_Configuration;

end Gabyx.Config;
