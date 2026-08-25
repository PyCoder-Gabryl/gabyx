--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja widoku Ustawień Raylib z układem Master-Detail (1000x600 px).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/gabyx-drivers-raylib-settings.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Interfaces.C;
with Ada.Characters.Latin_1;
with Gabyx.State_Machine;
with Gabyx.UI.Settings;
with Gabyx.Config.Audio;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Audio;
with Gabyx.Drivers.Raylib.Settings.Pane_Audio;
with Raylib;

package body Gabyx.Drivers.Raylib.Settings is

   use Interfaces.C;
   use Gabyx.UI.Settings;

   Settings_Data : Gabyx.UI.Settings.Settings_State;
   Audio_Cfg     : Gabyx.Config.Audio.Audio_Configuration :=
     Gabyx.Config.Audio.Load_Configuration;

   procedure Open_From (Caller : App_State) is
   begin
      Settings_Data.Previous_State := Caller;
      Gabyx.Drivers.Raylib.Audio.Play_Settings_Open;
   end Open_From;

   procedure Process_Frame (Font_Cfg : Gabyx.Config.Fonts.Font_Configuration) is
      Close_Req : Boolean := False;

      Screen_W : constant int := Standard.Raylib.GetScreenWidth;
      Screen_H : constant int := Standard.Raylib.GetScreenHeight;
      Cur_Font : constant Standard.Raylib.Font :=
        Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Mouse_X  : constant int := Standard.Raylib.GetMouseX;
      Mouse_Y  : constant int := Standard.Raylib.GetMouseY;
      LMB_Down : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Dlg_W : constant int := 1000;
      Dlg_H : constant int := 600;
      Dlg_X : constant int := (Screen_W - Dlg_W) / 2;
      Dlg_Y : constant int := (Screen_H - Dlg_H) / 2;

      Pane_Changed : Boolean := False;
   begin
      --  1. Wejście z klawiatury
      if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ESCAPE)) then
         Close_Req := True;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_DOWN))
         or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_S))
      then
         Select_Next (Settings_Data);
         Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_UP))
         or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_W))
      then
         Select_Prev (Settings_Data);
         Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ONE)) then
         Settings_Data.Selected_Category := Cat_Window;
         Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_TWO)) then
         Settings_Data.Selected_Category := Cat_Graphics;
         Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_THREE)) then
         Settings_Data.Selected_Category := Cat_Fonts;
         Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FOUR)) then
         Settings_Data.Selected_Category := Cat_HUD;
         Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FIVE)) then
         Settings_Data.Selected_Category := Cat_Camera_Grid;
         Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SIX)) then
         Settings_Data.Selected_Category := Cat_Audio;
         Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SEVEN)) then
         Settings_Data.Selected_Category := Cat_Input;
         Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
      end if;

      --  2. Renderowanie okna i obsługa myszy
      Standard.Raylib.BeginDrawing;
      Standard.Raylib.DrawRectangle
        (0, 0, Screen_W, Screen_H, (r => 0, g => 0, b => 0, a => 190));
      Standard.Raylib.DrawRectangle
        (Dlg_X, Dlg_Y, Dlg_W, Dlg_H, (r => 18, g => 22, b => 26, a => 255));
      Standard.Raylib.DrawRectangleLines
        (Dlg_X, Dlg_Y, Dlg_W, Dlg_H, (r => 60, g => 75, b => 95, a => 255));
      Standard.Raylib.DrawRectangleLines
        (Dlg_X + 2, Dlg_Y + 2, Dlg_W - 4, Dlg_H - 4, (r => 60, g => 75, b => 95, a => 255));

      Standard.Raylib.DrawRectangle
        (Dlg_X + 2, Dlg_Y + 2, Dlg_W - 4, 48, (r => 26, g => 34, b => 45, a => 255));
      Standard.Raylib.DrawLine
        (Dlg_X, Dlg_Y + 50, Dlg_X + Dlg_W, Dlg_Y + 50, (r => 255, g => 203, b => 0, a => 255));

      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "USTAWIENIA SILNIKA GABYX (SETTINGS)",
         (x => C_float (Dlg_X + 24), y => C_float (Dlg_Y + 14)),
         C_float (Font_Cfg.Size_Title),
         1.0,
         (r => 255, g => 203, b => 0, a => 255));

      --  Przycisk [X] Wróć
      declare
         Btn_X       : constant int := Dlg_X + Dlg_W - 160;
         Btn_Y       : constant int := Dlg_Y + 10;
         Btn_W       : constant int := 140;
         Btn_H       : constant int := 30;
         Btn_Hovered : constant Boolean :=
           (Mouse_X >= Btn_X and then Mouse_X <= Btn_X + Btn_W and then
            Mouse_Y >= Btn_Y and then Mouse_Y <= Btn_Y + Btn_H);
         Btn_Color   : constant Standard.Raylib.Color :=
           (if Btn_Hovered then (r => 255, g => 203, b => 0, a => 255)
            else (r => 245, g => 245, b => 245, a => 255));
      begin
         if Btn_Hovered then
            Standard.Raylib.DrawRectangle
              (Btn_X, Btn_Y, Btn_W, Btn_H, (r => 38, g => 50, b => 65, a => 255));
            if LMB_Down then
               Close_Req := True;
            end if;
         end if;

         Standard.Raylib.DrawRectangleLines
           (Btn_X, Btn_Y, Btn_W, Btn_H, (r => 60, g => 75, b => 95, a => 255));
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            "[X] WROC (ESC)",
            (x => C_float (Btn_X + 15), y => C_float (Btn_Y + 6)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            Btn_Color);
      end;

      --  Lewy panel kategorii
      Standard.Raylib.DrawRectangle
        (Dlg_X + 10, Dlg_Y + 60, 300, 485, (r => 22, g => 27, b => 34, a => 255));
      Standard.Raylib.DrawRectangleLines
        (Dlg_X + 10, Dlg_Y + 60, 300, 485, (r => 60, g => 75, b => 95, a => 255));

      for Cat in Settings_Category_ID loop
         declare
            Idx    : constant Integer := Settings_Category_ID'Pos (Cat);
            Row_Y  : constant int := Dlg_Y + 70 + int (Idx * 54);
            Is_Act : constant Boolean := (Settings_Data.Selected_Category = Cat);
            Is_Hover : constant Boolean :=
              (Mouse_X >= Dlg_X + 20 and then Mouse_X <= Dlg_X + 300 and then
               Mouse_Y >= Row_Y and then Mouse_Y <= Row_Y + 44);

            Bg       : constant Standard.Raylib.Color :=
              (if Is_Act then (r => 38, g => 50, b => 65, a => 255)
               elsif Is_Hover then (r => 26, g => 34, b => 45, a => 255)
               else (r => 22, g => 27, b => 34, a => 255));

            Txt      : constant Standard.Raylib.Color :=
              (if Is_Act then (r => 255, g => 203, b => 0, a => 255)
               elsif Is_Hover then (r => 80, g => 220, b => 240, a => 255)
               else (r => 245, g => 245, b => 245, a => 255));
         begin
            if Is_Hover and then LMB_Down and then not Is_Act then
               Settings_Data.Selected_Category := Cat;
               Gabyx.Drivers.Raylib.Audio.Play_Settings_Move;
            end if;

            Standard.Raylib.DrawRectangle (Dlg_X + 20, Row_Y, 280, 44, Bg);
            if Is_Act then
               Standard.Raylib.DrawRectangleLines
                 (Dlg_X + 20, Row_Y, 280, 44, (r => 255, g => 203, b => 0, a => 255));
            end if;

            Standard.Raylib.DrawTextEx
              (Cur_Font,
               (if Is_Act then "> " else "  ") & Get_Category_Name (Cat),
               (x => C_float (Dlg_X + 35), y => C_float (Row_Y + 12)),
               C_float (Font_Cfg.Size_Regular),
               1.0,
               Txt);
         end;
      end loop;

      --  Prawy panel szczegółów
      Standard.Raylib.DrawRectangle
        (Dlg_X + 320, Dlg_Y + 60, 670, 485, (r => 14, g => 17, b => 20, a => 255));
      Standard.Raylib.DrawRectangleLines
        (Dlg_X + 320, Dlg_Y + 60, 670, 485, (r => 60, g => 75, b => 95, a => 255));

      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "KATEGORIA: " & Get_Category_Name (Settings_Data.Selected_Category),
         (x => C_float (Dlg_X + 340), y => C_float (Dlg_Y + 80)),
         C_float (Font_Cfg.Size_Title),
         1.0,
         (r => 80, g => 220, b => 240, a => 255));

      Standard.Raylib.DrawTextEx
        (Cur_Font,
         Get_Category_Description (Settings_Data.Selected_Category),
         (x => C_float (Dlg_X + 340), y => C_float (Dlg_Y + 115)),
         C_float (Font_Cfg.Size_Small),
         1.0,
         (r => 170, g => 170, b => 170, a => 255));

      Standard.Raylib.DrawLine
        (Dlg_X + 340, Dlg_Y + 140, Dlg_X + 960, Dlg_Y + 140, (r => 60, g => 75, b => 95, a => 255));

      --  Renderowanie aktywnej zawartości
      case Settings_Data.Selected_Category is
         when Cat_Audio =>
            Gabyx.Drivers.Raylib.Settings.Pane_Audio.Render_Pane
              (Pane_X    => Integer (Dlg_X + 340),
               Pane_Y    => Integer (Dlg_Y + 160),
               Pane_W    => 630,
               Pane_H    => 365,
               Audio_Cfg => Audio_Cfg,
               Font_Cfg  => Font_Cfg,
               Changed   => Pane_Changed);

         when others =>
            Standard.Raylib.DrawRectangleLines
              (Dlg_X + 340, Dlg_Y + 160, 630, 365, (r => 26, g => 34, b => 45, a => 255));
            Standard.Raylib.DrawTextEx
              (Cur_Font,
               "[KONTROLKI DLA TEJ KATEGORII ZOSTANA DODANE W KOLEJNYM KROKU]" & Ada.Characters.Latin_1.LF &
               "Wybierz '6. DZWIEK & AUDIO', aby przetestowac suwaki i przycisk SFX.",
               (x => C_float (Dlg_X + 360), y => C_float (Dlg_Y + 220)),
               C_float (Font_Cfg.Size_Regular),
               1.0,
               (r => 120, g => 120, b => 120, a => 255));
      end case;

      --  Pasek dolny
      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "[1..7 / Strzalki / W/S] Wybierz kategorie   [Mysz] Suwaki / Kliknij   [ESC] Wroc",
         (x => C_float (Dlg_X + 24), y => C_float (Dlg_Y + Dlg_H - 30)),
         C_float (Font_Cfg.Size_Small),
         1.0,
         (r => 120, g => 120, b => 120, a => 255));

      Standard.Raylib.EndDrawing;

      --  3. Powrót do poprzedniego stanu
      if Close_Req then
         Gabyx.Drivers.Raylib.Audio.Play_Menu_Select;
         Gabyx.State_Machine.Set_State (Settings_Data.Previous_State);
      end if;
   end Process_Frame;

end Gabyx.Drivers.Raylib.Settings;
