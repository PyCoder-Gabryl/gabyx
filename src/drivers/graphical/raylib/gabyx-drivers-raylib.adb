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


with Ada.Text_IO;
with Interfaces.C;
with Ada.Strings.Unbounded;
with Gabyx.Types;
with Raylib;

package body Gabyx.Drivers.Raylib is

   procedure Run
     (Config   : Gabyx.Config.Window_Configuration;
      Font_Cfg : Gabyx.Config.Font_Configuration)
   is
      use Interfaces.C;
      use Gabyx.Types;

      --  Struktura opisująca predefiniowany zestaw rozdzielczości
      type Preset_Info is record
         Width  : int;
         Height : int;
         Name   : String (1 .. 28);
      end record;

      Presets_Table : constant array (1 .. 8) of Preset_Info :=
        (1 => (Width => 1280, Height => 720,  Name => "16:9 HD (Baza 1280x720)     "),
         2 => (Width => 1440, Height => 900,  Name => "16:10 WXGA (Mac 1440x900)   "),
         3 => (Width => 1920, Height => 1080, Name => "16:9 FHD (Full HD 1080p)   "),
         4 => (Width => 1920, Height => 1200, Name => "16:10 WUXGA (1920x1200)    "),
         5 => (Width => 2560, Height => 1080, Name => "21:9 UW-HD (Ultra-Wide)    "),
         6 => (Width => 2560, Height => 1440, Name => "16:9 QHD (2K 2560x1440)    "),
         7 => (Width => 3440, Height => 1440, Name => "21:9 UW-QHD (3440x1440)    "),
         8 => (Width => 3840, Height => 2160, Name => "16:9 4K UHD (3840x2160)    "));

      --  Stan bieżącego trybu okna i wirtualnego viewportu
      Current_Mode : Display_Mode_Type := Config.Display_Mode;
      Virtual_W    : int := int (Config.Width);
      Virtual_H    : int := int (Config.Height);
      Is_Frameless : Boolean := (Config.Display_Mode /= Windowed);

      --  Kolory
      Game_Area_Color : constant Standard.Raylib.Color :=
        (r => unsigned_char (Config.Clear_Color.R),
         g => unsigned_char (Config.Clear_Color.G),
         b => unsigned_char (Config.Clear_Color.B),
         a => unsigned_char (Config.Clear_Color.A));

      Border_Bars_Color : constant Standard.Raylib.Color :=
        (r => unsigned_char (Config.Border_Bars_Color.R),
         g => unsigned_char (Config.Border_Bars_Color.G),
         b => unsigned_char (Config.Border_Bars_Color.B),
         a => unsigned_char (Config.Border_Bars_Color.A));

      Text_White : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Text_Gray  : constant Standard.Raylib.Color := (r => 180, g => 180, b => 180, a => 255);
      Text_Gold  : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0,   a => 255);
      Text_Cyan  : constant Standard.Raylib.Color := (r => 80,  g => 220, b => 240, a => 255);

      Title_Str : constant String :=
        Ada.Strings.Unbounded.To_String (Config.Title);
      Font_Path : constant String :=
        Ada.Strings.Unbounded.To_String (Font_Cfg.Regular_Path);

      FPS : constant int :=
        (if Config.Target_FPS > 0 then int (Config.Target_FPS) else 60);

      --  Uchwyt czcionki i zmienne monitora
      Game_Font  : Standard.Raylib.Font;
      Cur_Mon    : int := 0;
      Mon_W      : int := 1920;
      Mon_H      : int := 1080;

      --  Procedura centrowania okna na monitorze
      procedure Center_Window (Target_W, Target_H : int) is
         Pos_X : constant int := (Mon_W - Target_W) / 2;
         Pos_Y : constant int := (Mon_H - Target_H) / 2;
      begin
         Standard.Raylib.SetWindowPosition (Pos_X, Pos_Y);
      end Center_Window;

      --  Procedura bezpiecznej zmiany presetu
      procedure Apply_Preset (Index : Positive) is
         Req_W : constant int := Presets_Table (Index).Width;
         Req_H : constant int := Presets_Table (Index).Height;
      begin
         if Current_Mode = Borderless_Fullscreen then
            --  W pełnym ekranie okno ma rozmiar monitora, zmieniamy tylko wirtualny viewport
            Virtual_W := Req_W;
            Virtual_H := Req_H;
            Ada.Text_IO.Put_Line
              ("[PRESET] Zmieniono wirtualny Viewport na: " & Presets_Table (Index).Name);
         else
            --  W trybie okienkowym sprawdzamy czy okno mieści się na monitorze
            if Req_W <= Mon_W and then Req_H <= Mon_H then
               Virtual_W := Req_W;
               Virtual_H := Req_H;
               Standard.Raylib.SetWindowSize (Virtual_W, Virtual_H);
               Center_Window (Virtual_W, Virtual_H);
               Ada.Text_IO.Put_Line
                 ("[PRESET] Zmieniono rozmiar okna na: " & Presets_Table (Index).Name);
            else
               Ada.Text_IO.Put_Line
                 ("[OSTRZEZENIE] Rozdzielczosc " & Presets_Table (Index).Name &
                  " przekracza wymiary monitora (" & Integer (Mon_W)'Image & "x" &
                  Integer (Mon_H)'Image & ")!");
            end if;
         end if;
      end Apply_Preset;

   begin
      --  1. Wstępna konfiguracja flag przed otwarciem okna
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
           (Standard.Raylib.FLAG_WINDOW_UNDECORATED + Standard.Raylib.FLAG_WINDOW_TOPMOST);
      end if;

      --  2. Inicjalizacja bazowego okna
      Standard.Raylib.InitWindow (Virtual_W, Virtual_H, Title_Str);
      Standard.Raylib.SetTargetFPS (FPS);

      --  3. Odczyt właściwości monitora i dopasowanie pozycji/rozmiaru
      Cur_Mon := Standard.Raylib.GetCurrentMonitor;
      Mon_W   := Standard.Raylib.GetMonitorWidth (Cur_Mon);
      Mon_H   := Standard.Raylib.GetMonitorHeight (Cur_Mon);

      if Current_Mode = Borderless_Fullscreen then
         --  Pełny ekran bezramkowy: okno wypełnia cały pulpit
         Standard.Raylib.SetWindowSize (Mon_W, Mon_H);
         Standard.Raylib.SetWindowPosition (0, 0);
      else
         --  Bezpiecznik startowy: jeśli preset z TOML przekracza monitor, zredukuj do bezpiecznego
         if Virtual_W > Mon_W or else Virtual_H > Mon_H then
            Ada.Text_IO.Put_Line
              ("[CONFIG] Wybrany preset przekracza monitor. Dopasowanie do 1280x720...");
            Virtual_W := 1280;
            Virtual_H := 720;
            Standard.Raylib.SetWindowSize (Virtual_W, Virtual_H);
         end if;

         if Config.Center_On_Screen then
            Center_Window (Virtual_W, Virtual_H);
         end if;
      end if;

      --  4. Wczytanie czcionki i włączenie filtru dwuliniowego
      Ada.Text_IO.Put_Line ("[RAYLIB] Ladowanie czcionki: " & Font_Path);
      Game_Font := Standard.Raylib.LoadFont (Font_Path);
      Standard.Raylib.SetTextureFilter
        (Game_Font.texture_f,
         Standard.Raylib.TEXTURE_FILTER_BILINEAR);

      --  5. Główna pętla renderowania i testów interaktywnych
      while not Boolean (Standard.Raylib.WindowShouldClose) loop

         --  Obsługa klawiszy wyboru rozdzielczości [1]..[8]
         if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ONE)) then
            Apply_Preset (1);
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_TWO)) then
            Apply_Preset (2);
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_THREE)) then
            Apply_Preset (3);
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FOUR)) then
            Apply_Preset (4);
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FIVE)) then
            Apply_Preset (5);
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SIX)) then
            Apply_Preset (6);
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SEVEN)) then
            Apply_Preset (7);
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_EIGHT)) then
            Apply_Preset (8);
         end if;

         --  Obsługa klawisza [B] - Przełączanie ramki okna
         if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_B)) then
            if Current_Mode /= Borderless_Fullscreen then
               Is_Frameless := not Is_Frameless;
               if Is_Frameless then
                  Standard.Raylib.SetWindowState (Standard.Raylib.FLAG_WINDOW_UNDECORATED);
                  Current_Mode := Borderless;
                  Ada.Text_IO.Put_Line ("[OKNO] Przelaczono na: Bezramkowe (Borderless)");
               else
                  Standard.Raylib.ClearWindowState (Standard.Raylib.FLAG_WINDOW_UNDECORATED);
                  Current_Mode := Windowed;
                  Ada.Text_IO.Put_Line ("[OKNO] Przelaczono na: Z ramka (Windowed)");
               end if;
               Center_Window (Virtual_W, Virtual_H);
            end if;
         end if;

         --  Krok Rysowania
         Standard.Raylib.BeginDrawing;

         declare
            Screen_W : constant int := Standard.Raylib.GetScreenWidth;
            Screen_H : constant int := Standard.Raylib.GetScreenHeight;

            --  Obliczenie wycentrowanego wirtualnego obszaru gry
            Vp_X : constant int := (Screen_W - Virtual_W) / 2;
            Vp_Y : constant int := (Screen_H - Virtual_H) / 2;

            Offset_X : constant C_float := C_float (Vp_X);
            Offset_Y : constant C_float := C_float (Vp_Y);

            Pos_Title : constant Standard.Raylib.Vector2 := (x => Offset_X + 40.0, y => Offset_Y + 40.0);
            Pos_Mode  : constant Standard.Raylib.Vector2 := (x => Offset_X + 40.0, y => Offset_Y + 80.0);
            Pos_Res   : constant Standard.Raylib.Vector2 := (x => Offset_X + 40.0, y => Offset_Y + 115.0);
            Pos_Mon   : constant Standard.Raylib.Vector2 := (x => Offset_X + 40.0, y => Offset_Y + 150.0);
            Pos_Fps   : constant Standard.Raylib.Vector2 := (x => Offset_X + 40.0, y => Offset_Y + 185.0);
            Pos_Keys  : constant Standard.Raylib.Vector2 := (x => Offset_X + 40.0, y => Offset_Y + 230.0);
            Pos_List  : constant Standard.Raylib.Vector2 := (x => Offset_X + 40.0, y => Offset_Y + 265.0);
            Pos_Esc   : constant Standard.Raylib.Vector2 := (x => Offset_X + 40.0, y => Offset_Y + 440.0);

            Mode_Name : constant String :=
              (case Current_Mode is
                  when Windowed              => "Windowed (Z ramka OS)",
                  when Borderless            => "Borderless (Bezramkowe)",
                  when Borderless_Fullscreen => "Borderless Fullscreen (Pulpit z pasami)");
         begin
            if Current_Mode = Borderless_Fullscreen then
               --  Czyszczenie całego ekranu kolorem pasów obramowania (bordo)
               Standard.Raylib.ClearBackground (Border_Bars_Color);

               --  Rysowanie wycentrowanego obszaru właściwego gry (grafit)
               Standard.Raylib.DrawRectangle
                 (Vp_X, Vp_Y, Virtual_W, Virtual_H, Game_Area_Color);

               --  Ramka konturowa oddzielająca wirtualny ekran od pasów
               Standard.Raylib.DrawRectangleLines
                 (Vp_X, Vp_Y, Virtual_W, Virtual_H, Text_Gray);
            else
               --  W trybie okienkowym tłem całego okna jest kolor gry
               Standard.Raylib.ClearBackground (Game_Area_Color);
            end if;

            --  Prezentacja diagnostyki wewnątrz wycentrowanego Viewportu
            Standard.Raylib.DrawTextEx
              (Game_Font,
               "GABYX OMNI-ENGINE // TEST ROZDZIELCZOSCI",
               Pos_Title,
               C_float (Font_Cfg.Size_Title),
               C_float (Font_Cfg.Spacing),
               Text_White);

            Standard.Raylib.DrawTextEx
              (Game_Font,
               "Tryb wyswietlania: " & Mode_Name,
               Pos_Mode,
               C_float (Font_Cfg.Size_Regular),
               C_float (Font_Cfg.Spacing),
               Text_Cyan);

            Standard.Raylib.DrawTextEx
              (Game_Font,
               "Wymiary okna: " & Integer (Screen_W)'Image & " x " & Integer (Screen_H)'Image &
               " px (Viewport: " & Integer (Virtual_W)'Image & " x " & Integer (Virtual_H)'Image & " px)",
               Pos_Res,
               C_float (Font_Cfg.Size_Regular),
               C_float (Font_Cfg.Spacing),
               Text_Gray);

            Standard.Raylib.DrawTextEx
              (Game_Font,
               "Monitor glowny: " & Integer (Mon_W)'Image & " x " & Integer (Mon_H)'Image & " px",
               Pos_Mon,
               C_float (Font_Cfg.Size_Regular),
               C_float (Font_Cfg.Spacing),
               Text_Gray);

            Standard.Raylib.DrawTextEx
              (Game_Font,
               "Docelowy klatkarz: " & Integer (FPS)'Image & " FPS (V-Sync: Aktywny)",
               Pos_Fps,
               C_float (Font_Cfg.Size_Regular),
               C_float (Font_Cfg.Spacing),
               Text_Gray);

            Standard.Raylib.DrawTextEx
              (Game_Font,
               "STEROWANIE DIAGNOSTYCZNE:",
               Pos_Keys,
               C_float (Font_Cfg.Size_Regular),
               C_float (Font_Cfg.Spacing),
               Text_Gold);

            Standard.Raylib.DrawTextEx
              (Game_Font,
               "[1] 1280x720  [2] 1440x900   [3] 1920x1080  [4] 1920x1200" & ASCII.LF &
               "[5] 2560x1080 [6] 2560x1440  [7] 3440x1440  [8] 3840x2160" & ASCII.LF &
               "[B] Przelacz ramke okna (Windowed <-> Borderless)",
               Pos_List,
               C_float (Font_Cfg.Size_Small),
               C_float (Font_Cfg.Spacing),
               Text_White);

            Standard.Raylib.DrawTextEx
              (Game_Font,
               "Nacisnij ESC lub zamknij okno, aby zakonczyc test.",
               Pos_Esc,
               C_float (Font_Cfg.Size_Regular),
               C_float (Font_Cfg.Spacing),
               Text_Gold);

         end;

         Standard.Raylib.EndDrawing;
      end loop;

      --  6. Zwolnienie zasobów GPU i zamknięcie okna
      Standard.Raylib.UnloadFont (Game_Font);
      Standard.Raylib.CloseWindow;
   end Run;

end Gabyx.Drivers.Raylib;
