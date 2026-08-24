--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja parsera pliku window.toml. Odczytuje tryby okna,
--                    presety rozdzielczosci, parametry V-Sync oraz kolory tla i pasow.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/display/gabyx-config-window.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;
with Gabyx.Config.Helpers;

package body Gabyx.Config.Window is

   use type TOML.Any_Value_Kind;
   use Gabyx.Config.Helpers;

   --  Wcześniejsza deklaracja funkcji wewnętrznej (wymóg stylu -gnatys)
   function Parse_Display_Mode (Mode_Str : String) return Display_Mode_Type;

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

   function Get_Default_Configuration return Window_Configuration is
      Config : Window_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Window_Configuration
   is
      Config : Window_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line ("[CONFIG] Brak pliku " & File_Path & " - uzyto wartosci domyslnych okna.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         --  1. Sekcja [window]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("window") then
            declare
               Win_Tab    : constant TOML.TOML_Value := Root.Get ("window");
               Preset_Num : constant Integer := Read_Integer (Win_Tab, "active_preset", 0);
               Mode_Raw   : constant String  := Read_String (Win_Tab, "display_mode", "windowed");
            begin
               Config.Title            := To_Unbounded_String (Read_String (Win_Tab, "title", Default_Window_Title));
               Config.Display_Mode     := Parse_Display_Mode (Mode_Raw);
               Config.Center_On_Screen := Read_Boolean (Win_Tab, "center_on_screen", True);
               Config.Monitor_Index    := Natural (Read_Integer (Win_Tab, "monitor_index", 0));
               Config.Resizable        := Read_Boolean (Win_Tab, "resizable", False);
               Config.Always_On_Top    := Read_Boolean (Win_Tab, "always_on_top", False);
               Config.High_DPI         := Read_Boolean (Win_Tab, "high_dpi", True);

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

         --  2. Sekcja [presets]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("presets") then
            declare
               Pre_Tab : constant TOML.TOML_Value := Root.Get ("presets");
               Sub_Key : constant String :=
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
               if Pre_Tab.Kind = TOML.TOML_Table and then Pre_Tab.Has (Sub_Key) then
                  declare
                     P_Tab : constant TOML.TOML_Value := Pre_Tab.Get (Sub_Key);
                     Raw_W : constant Integer := Read_Integer (P_Tab, "width", 1280);
                     Raw_H : constant Integer := Read_Integer (P_Tab, "height", 720);
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
               Config.Maintain_Aspect_Ratio := Read_Boolean (Gfx_Tab, "maintain_aspect_ratio", True);
               if Raw_FPS in 0 | 30 | 60 | 75 | 100 | 120 | 144 | 165 then
                  Config.Target_FPS := Target_FPS_Type (Raw_FPS);
               end if;
            end;
         end if;

         --  4. Sekcja [background] i [border_bars]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("background") then
            declare
               Bg_Tab : constant TOML.TOML_Value := Root.Get ("background");
            begin
               Config.Clear_Color.R := Color_Component (Read_Integer (Bg_Tab, "r", 18));
               Config.Clear_Color.G := Color_Component (Read_Integer (Bg_Tab, "g", 22));
               Config.Clear_Color.B := Color_Component (Read_Integer (Bg_Tab, "b", 26));
            end;
         end if;

         if Root.Kind = TOML.TOML_Table and then Root.Has ("border_bars") then
            declare
               Bar_Tab : constant TOML.TOML_Value := Root.Get ("border_bars");
            begin
               Config.Border_Bars_Color.R := Color_Component (Read_Integer (Bar_Tab, "r", 90));
               Config.Border_Bars_Color.G := Color_Component (Read_Integer (Bar_Tab, "g", 20));
               Config.Border_Bars_Color.B := Color_Component (Read_Integer (Bar_Tab, "b", 35));
            end;
         end if;
      end;

      return Config;
   end Load_Configuration;

end Gabyx.Config.Window;
