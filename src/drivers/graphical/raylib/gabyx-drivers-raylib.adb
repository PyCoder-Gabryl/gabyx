--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib.adb
--  CREATED:         2026-08-22
--  ============================================================================


with Ada.Characters.Latin_1;
with Interfaces.C;
with Ada.Strings.Unbounded;
with Gabyx.Types;
with Gabyx.Commands;
with Gabyx.UI.Layout;
with Gabyx.UI.Panels;
with Gabyx.Drivers.Raylib.Input;
with Raylib;

package body Gabyx.Drivers.Raylib is

   procedure Run
     (Config   : Gabyx.Config.Window_Configuration;
      Font_Cfg : Gabyx.Config.Font_Configuration)
   is
      use Interfaces.C;
      use Gabyx.Types;
      use Gabyx.Commands;
      use type Standard.Raylib.ConfigFlags;

      --  Struktura wymiarów predefiniowanego zestawu rozdzielczości
      type Preset_Dim is record
         Width  : int;
         Height : int;
      end record;

      Presets_Table : constant array (1 .. 9) of Preset_Dim :=
        [1 => (Width => 1280, Height => 720),
         2 => (Width => 1440, Height => 900),
         3 => (Width => 1600, Height => 900),
         4 => (Width => 1920, Height => 1080),
         5 => (Width => 1920, Height => 1200),
         6 => (Width => 2560, Height => 1080),
         7 => (Width => 2560, Height => 1440),
         8 => (Width => 3440, Height => 1440),
         9 => (Width => 3840, Height => 2160)];

      --  Deklaracje wcześniejsze procedur lokalnych (wymóg stylu -gnatys)
      procedure Center_Window (Target_W, Target_H : int);
      procedure Apply_Preset (Index : Positive);
      procedure Refresh_Layout;

      --  Konfiguracja i stany bieżące
      HUD_Cfg      : constant Gabyx.Config.HUD_Configuration := Gabyx.Config.Load_HUD_Configuration;
      Current_Mode : Display_Mode_Type := Config.Display_Mode;
      Virtual_W    : int := int (Config.Width);
      Virtual_H    : int := int (Config.Height);
      Is_Frameless : Boolean := (Config.Display_Mode /= Windowed);

      Forced_HUD_Tier : HUD_Tier_Type := HUD_Auto;
      Top_View        : HUD_View_Type := View_A;
      Bottom_View     : HUD_View_Type := View_A;
      Active_Font_ID  : Integer := 1; --  1 = Intel One Mono, 2 = JetBrains Mono

      Layout : Layout_Cache;

      --  Paleta Kolorów
      Color_Top_A : constant Standard.Raylib.Color :=
        (r => unsigned_char (HUD_Cfg.Color_Top_View_A.R),
         g => unsigned_char (HUD_Cfg.Color_Top_View_A.G),
         b => unsigned_char (HUD_Cfg.Color_Top_View_A.B),
         a => unsigned_char (HUD_Cfg.Color_Top_View_A.A));

      Color_Top_B : constant Standard.Raylib.Color :=
        (r => unsigned_char (HUD_Cfg.Color_Top_View_B.R),
         g => unsigned_char (HUD_Cfg.Color_Top_View_B.G),
         b => unsigned_char (HUD_Cfg.Color_Top_View_B.B),
         a => unsigned_char (HUD_Cfg.Color_Top_View_B.A));

      Color_Bottom_A : constant Standard.Raylib.Color :=
        (r => unsigned_char (HUD_Cfg.Color_Bottom_View_A.R),
         g => unsigned_char (HUD_Cfg.Color_Bottom_View_A.G),
         b => unsigned_char (HUD_Cfg.Color_Bottom_View_A.B),
         a => unsigned_char (HUD_Cfg.Color_Bottom_View_A.A));

      Color_Bottom_B : constant Standard.Raylib.Color :=
        (r => unsigned_char (HUD_Cfg.Color_Bottom_View_B.R),
         g => unsigned_char (HUD_Cfg.Color_Bottom_View_B.G),
         b => unsigned_char (HUD_Cfg.Color_Bottom_View_B.B),
         a => unsigned_char (HUD_Cfg.Color_Bottom_View_B.A));

      Color_Viewport : constant Standard.Raylib.Color :=
        (r => unsigned_char (HUD_Cfg.Color_Viewport.R),
         g => unsigned_char (HUD_Cfg.Color_Viewport.G),
         b => unsigned_char (HUD_Cfg.Color_Viewport.B),
         a => unsigned_char (HUD_Cfg.Color_Viewport.A));

      Border_Bars_Color : constant Standard.Raylib.Color :=
        (r => unsigned_char (Config.Border_Bars_Color.R),
         g => unsigned_char (Config.Border_Bars_Color.G),
         b => unsigned_char (Config.Border_Bars_Color.B),
         a => unsigned_char (Config.Border_Bars_Color.A));

      Text_White : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Text_Gray  : constant Standard.Raylib.Color := (r => 180, g => 180, b => 180, a => 255);
      Text_Gold  : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0,   a => 255);
      Text_Cyan  : constant Standard.Raylib.Color := (r => 80,  g => 220, b => 240, a => 255);

      Title_Str : constant String := Ada.Strings.Unbounded.To_String (Config.Title);
      FPS       : constant int := (if Config.Target_FPS > 0 then int (Config.Target_FPS) else 60);

      --  Zasoby czcionek
      Font_Intel     : Standard.Raylib.Font;
      Font_JetBrains : Standard.Raylib.Font;

      Cur_Mon : int := 0;
      Mon_W   : int := 1920;
      Mon_H   : int := 1080;

      procedure Refresh_Layout is
      begin
         Layout := Gabyx.UI.Layout.Calculate_Layout
           (Width       => Width_Type (Virtual_W),
            Height      => Height_Type (Virtual_H),
            Forced_Tier => Forced_HUD_Tier);
      end Refresh_Layout;

      procedure Center_Window (Target_W, Target_H : int) is
         Pos_X : constant int := (Mon_W - Target_W) / 2;
         Pos_Y : constant int := (Mon_H - Target_H) / 2;
      begin
         Standard.Raylib.SetWindowPosition (Pos_X, Pos_Y);
      end Center_Window;

      procedure Apply_Preset (Index : Positive) is
         Req_W : constant int := Presets_Table (Index).Width;
         Req_H : constant int := Presets_Table (Index).Height;
      begin
         if Current_Mode = Borderless_Fullscreen then
            Virtual_W := Req_W;
            Virtual_H := Req_H;
            Refresh_Layout;
         else
            if Req_W <= Mon_W and then Req_H <= Mon_H then
               Virtual_W := Req_W;
               Virtual_H := Req_H;
               Standard.Raylib.SetWindowSize (Virtual_W, Virtual_H);
               Center_Window (Virtual_W, Virtual_H);
               Refresh_Layout;
            end if;
         end if;
      end Apply_Preset;

   begin
      --  1. Konfiguracja flag okna
      if Config.High_DPI then
         Standard.Raylib.SetConfigFlags (Standard.Raylib.FLAG_WINDOW_HIGHDPI);
      end if;
      if Config.VSync then
         Standard.Raylib.SetConfigFlags (Standard.Raylib.FLAG_VSYNC_HINT);
      end if;
      if Current_Mode = Borderless then
         Standard.Raylib.SetConfigFlags (Standard.Raylib.FLAG_WINDOW_UNDECORATED);
      elsif Current_Mode = Borderless_Fullscreen then
         Standard.Raylib.SetConfigFlags
           (Standard.Raylib.FLAG_WINDOW_UNDECORATED or Standard.Raylib.FLAG_WINDOW_TOPMOST);
      end if;

      --  2. Inicjalizacja okna
      Standard.Raylib.InitWindow (Virtual_W, Virtual_H, Title_Str);
      Standard.Raylib.SetTargetFPS (FPS);

      Cur_Mon := Standard.Raylib.GetCurrentMonitor;
      Mon_W   := Standard.Raylib.GetMonitorWidth (Cur_Mon);
      Mon_H   := Standard.Raylib.GetMonitorHeight (Cur_Mon);

      if Current_Mode = Borderless_Fullscreen then
         Standard.Raylib.SetWindowSize (Mon_W, Mon_H);
         Standard.Raylib.SetWindowPosition (0, 0);
      else
         if Virtual_W > Mon_W or else Virtual_H > Mon_H then
            Virtual_W := 1280;
            Virtual_H := 720;
            Standard.Raylib.SetWindowSize (Virtual_W, Virtual_H);
         end if;
         if Config.Center_On_Screen then
            Center_Window (Virtual_W, Virtual_H);
         end if;
      end if;

      --  3. Wczytanie obu czcionek (Intel One Mono i JetBrains Mono)
      Font_Intel := Standard.Raylib.LoadFont
        (Ada.Strings.Unbounded.To_String (Font_Cfg.Regular_Path));
      Standard.Raylib.SetTextureFilter
        (Font_Intel.texture_f, Standard.Raylib.TEXTURE_FILTER_BILINEAR);

      Font_JetBrains := Standard.Raylib.LoadFont
        ("assets/fonts/jetbrains_mono/JetBrainsMonoNerdFont-Regular.ttf");
      Standard.Raylib.SetTextureFilter
        (Font_JetBrains.texture_f, Standard.Raylib.TEXTURE_FILTER_BILINEAR);

      Refresh_Layout;

      --  4. Pętla główna zdarzeń i poleceń
      while not Boolean (Standard.Raylib.WindowShouldClose) loop
         declare
            Cmd : constant Game_Command := Gabyx.Drivers.Raylib.Input.Poll_Command;
         begin
            case Cmd is
               when Cmd_Quit =>
                  exit;
               when Cmd_Select_Preset_1 => Apply_Preset (1);
               when Cmd_Select_Preset_2 => Apply_Preset (2);
               when Cmd_Select_Preset_3 => Apply_Preset (3);
               when Cmd_Select_Preset_4 => Apply_Preset (4);
               when Cmd_Select_Preset_5 => Apply_Preset (5);
               when Cmd_Select_Preset_6 => Apply_Preset (6);
               when Cmd_Select_Preset_7 => Apply_Preset (7);
               when Cmd_Select_Preset_8 => Apply_Preset (8);
               when Cmd_Select_Preset_9 => Apply_Preset (9);

               when Cmd_Toggle_Borderless =>
                  if Current_Mode /= Borderless_Fullscreen then
                     Is_Frameless := not Is_Frameless;
                     if Is_Frameless then
                        Standard.Raylib.SetWindowState (Standard.Raylib.FLAG_WINDOW_UNDECORATED);
                        Current_Mode := Borderless;
                     else
                        Standard.Raylib.ClearWindowState (Standard.Raylib.FLAG_WINDOW_UNDECORATED);
                        Current_Mode := Windowed;
                     end if;
                     Center_Window (Virtual_W, Virtual_H);
                  end if;

               when Cmd_HUD_Tier_Auto =>
                  Forced_HUD_Tier := HUD_Auto;
                  Refresh_Layout;
               when Cmd_HUD_Tier_Compact =>
                  Forced_HUD_Tier := HUD_Compact;
                  Refresh_Layout;
               when Cmd_HUD_Tier_Standard =>
                  Forced_HUD_Tier := HUD_Standard;
                  Refresh_Layout;
               when Cmd_HUD_Tier_HiDPI =>
                  Forced_HUD_Tier := HUD_HiDPI;
                  Refresh_Layout;

               when Cmd_Toggle_Top_View =>
                  Top_View := (if Top_View = View_A then View_B else View_A);

               when Cmd_Toggle_Bottom_View =>
                  Bottom_View := (if Bottom_View = View_A then View_B else View_A);

               when Cmd_Toggle_Font_Family =>
                  Active_Font_ID := (if Active_Font_ID = 1 then 2 else 1);

               when Cmd_None =>
                  null;
            end case;
         end;

         --  5. Renderowanie kontenerów i widoków
         Standard.Raylib.BeginDrawing;

         declare
            Screen_W : constant int := Standard.Raylib.GetScreenWidth;
            Screen_H : constant int := Standard.Raylib.GetScreenHeight;

            Vp_X : constant int := (Screen_W - Virtual_W) / 2;
            Vp_Y : constant int := (Screen_H - Virtual_H) / 2;

            Current_Font : constant Standard.Raylib.Font :=
              (if Active_Font_ID = 1 then Font_Intel else Font_JetBrains);

            Font_Name : constant String :=
              (if Active_Font_ID = 1 then "Intel One Mono" else "JetBrains Mono");

            Top_Color : constant Standard.Raylib.Color :=
              (if Top_View = View_A then Color_Top_A else Color_Top_B);

            Bottom_Color : constant Standard.Raylib.Color :=
              (if Bottom_View = View_A then Color_Bottom_A else Color_Bottom_B);
         begin
            if Current_Mode = Borderless_Fullscreen then
               Standard.Raylib.ClearBackground (Border_Bars_Color);
            else
               Standard.Raylib.ClearBackground (Color_Viewport);
            end if;

            --  A. GÓRNY PASEK (Top Toolbar)
            Standard.Raylib.DrawRectangle
              (Vp_X + int (Layout.Top_Bar_Rect.X),
               Vp_Y + int (Layout.Top_Bar_Rect.Y),
               int (Layout.Top_Bar_Rect.Width),
               int (Layout.Top_Bar_Rect.Height),
               Top_Color);

            --  B. VIEWPORT ŚWIATA (Środek - bordowy dla wyrazistości)
            Standard.Raylib.DrawRectangle
              (Vp_X + int (Layout.Viewport_Rect.X),
               Vp_Y + int (Layout.Viewport_Rect.Y),
               int (Layout.Viewport_Rect.Width),
               int (Layout.Viewport_Rect.Height),
               Color_Viewport);

            --  C. DOLNY PASEK (Bottom Dashboard)
            Standard.Raylib.DrawRectangle
              (Vp_X + int (Layout.Bottom_Bar_Rect.X),
               Vp_Y + int (Layout.Bottom_Bar_Rect.Y),
               int (Layout.Bottom_Bar_Rect.Width),
               int (Layout.Bottom_Bar_Rect.Height),
               Bottom_Color);

            --  Ramka konturowa oddzielająca wirtualny Viewport
            Standard.Raylib.DrawRectangleLines
              (Vp_X, Vp_Y, Virtual_W, Virtual_H, Text_Gray);

            --  TREŚĆ GÓRNEGO PASKA (Formatowana przez Gabyx.UI.Panels)
            Standard.Raylib.DrawTextEx
              (Current_Font,
               Gabyx.UI.Panels.Get_Top_Bar_Text
                 (View          => Top_View,
                  Virtual_W     => Positive (Virtual_W),
                  Virtual_H     => Positive (Virtual_H),
                  Screen_W      => Positive (Screen_W),
                  Screen_H      => Positive (Screen_H),
                  Is_Ultra_Wide => Layout.Is_Ultra_Wide,
                  Active_Tier   => Layout.Active_Tier,
                  Font_Family   => Font_Name,
                  FPS           => Natural (FPS)),
               (x => C_float (Vp_X + 20), y => C_float (Vp_Y + 8)),
               C_float (Font_Cfg.Size_Small),
               1.0,
               (if Top_View = View_A then Text_White else Text_Cyan));

            --  TREŚĆ ŚRODKOWEGO VIEWPORTU
            Standard.Raylib.DrawTextEx
              (Current_Font,
               "OBSZAR VIEWPORTU SWIATA (BORDOWE TLO TESTOWE)" & Ada.Characters.Latin_1.LF &
               "Wymiary bufora lochu: " & Layout.Viewport_Rect.Width'Image & " x " &
               Layout.Viewport_Rect.Height'Image & " px" & Ada.Characters.Latin_1.LF &
               "Gotowy na przyjecie siatki kafelkow i gracza @ w kolejnym kroku.",
               (x => C_float (Vp_X + 40),
                y => C_float (Vp_Y + int (Layout.Viewport_Rect.Y) + 40)),
               C_float (Font_Cfg.Size_Regular),
               1.0,
               Text_White);

            --  TREŚĆ DOLNEGO PASKA (Formatowana przez Gabyx.UI.Panels)
            Standard.Raylib.DrawTextEx
              (Current_Font,
               Gabyx.UI.Panels.Get_Bottom_Bar_Text
                 (View          => Bottom_View,
                  Is_Ultra_Wide => Layout.Is_Ultra_Wide),
               (x => C_float (Vp_X + 20),
                y => C_float (Vp_Y + int (Layout.Bottom_Bar_Rect.Y) + 12)),
               C_float (Font_Cfg.Size_Small),
               1.0,
               (if Bottom_View = View_A then Text_Gold else Text_White));

         end;

         Standard.Raylib.EndDrawing;
      end loop;

      --  6. Zwolnienie zasobów GPU i zamknięcie okna
      Standard.Raylib.UnloadFont (Font_Intel);
      Standard.Raylib.UnloadFont (Font_JetBrains);
      Standard.Raylib.CloseWindow;
   end Run;

end Gabyx.Drivers.Raylib;
