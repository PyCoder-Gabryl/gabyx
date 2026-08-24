--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja widoku Ustawień Raylib z układem Master-Detail (1000x600 px).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib-settings.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Interfaces.C;
with Ada.Characters.Latin_1;
with Gabyx.Drivers.Raylib.Fonts;
with Raylib;

package body Gabyx.Drivers.Raylib.Settings is

   use Interfaces.C;
   use Gabyx.UI.Settings;

   procedure Render
     (State          : in out Gabyx.UI.Settings.Settings_State;
      Font_Cfg       : Gabyx.Config.Fonts.Font_Configuration;
      Close_Clicked  : out Boolean;
      Option_Changed : out Boolean)
   is
      Screen_W : constant int := Standard.Raylib.GetScreenWidth;
      Screen_H : constant int := Standard.Raylib.GetScreenHeight;
      Cur_Font : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;

      Mouse_X  : constant int := Standard.Raylib.GetMouseX;
      Mouse_Y  : constant int := Standard.Raylib.GetMouseY;
      LMB_Down : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      --  Wymiary okna dialogowego 1000 x 600 px
      Dlg_W    : constant int := 1000;
      Dlg_H    : constant int := 600;
      Dlg_X    : constant int := (Screen_W - Dlg_W) / 2;
      Dlg_Y    : constant int := (Screen_H - Dlg_H) / 2;

      --  Kolorystyka
      Scrim_Color    : constant Standard.Raylib.Color := (r => 0,   g => 0,   b => 0,   a => 190);
      Dlg_Bg_Color   : constant Standard.Raylib.Color := (r => 18,  g => 22,  b => 26,  a => 255);
      Left_Pane_Bg   : constant Standard.Raylib.Color := (r => 22,  g => 27,  b => 34,  a => 255);
      Right_Pane_Bg  : constant Standard.Raylib.Color := (r => 14,  g => 17,  b => 20,  a => 255);
      Header_Bg      : constant Standard.Raylib.Color := (r => 26,  g => 34,  b => 45,  a => 255);
      Active_Row_Bg  : constant Standard.Raylib.Color := (r => 38,  g => 50,  b => 65,  a => 255);
      Border_Color   : constant Standard.Raylib.Color := (r => 60,  g => 75,  b => 95,  a => 255);
      Gold_Color     : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0,   a => 255);
      Cyan_Color     : constant Standard.Raylib.Color := (r => 80,  g => 220, b => 240, a => 255);
      Text_White     : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Text_Gray      : constant Standard.Raylib.Color := (r => 170, g => 170, b => 170, a => 255);
      Text_Muted     : constant Standard.Raylib.Color := (r => 120, g => 120, b => 120, a => 255);
   begin
      Close_Clicked  := False;
      Option_Changed := False;

      Standard.Raylib.BeginDrawing;

      --  1. Półprzezroczysta kurtyna przyciemniająca tło gry
      Standard.Raylib.DrawRectangle (0, 0, Screen_W, Screen_H, Scrim_Color);

      --  2. Główny prostokąt okna Ustawień (1000x600 px) z podwójną ramką
      Standard.Raylib.DrawRectangle (Dlg_X, Dlg_Y, Dlg_W, Dlg_H, Dlg_Bg_Color);
      Standard.Raylib.DrawRectangleLines (Dlg_X, Dlg_Y, Dlg_W, Dlg_H, Border_Color);
      Standard.Raylib.DrawRectangleLines (Dlg_X + 2, Dlg_Y + 2, Dlg_W - 4, Dlg_H - 4, Border_Color);

      --  3. Pasek nagłówka (Wysokość 50 px)
      Standard.Raylib.DrawRectangle (Dlg_X + 2, Dlg_Y + 2, Dlg_W - 4, 48, Header_Bg);
      Standard.Raylib.DrawLine (Dlg_X, Dlg_Y + 50, Dlg_X + Dlg_W, Dlg_Y + 50, Gold_Color);

      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "USTAWIENIA SILNIKA GABYX (SETTINGS)",
         (x => C_float (Dlg_X + 24), y => C_float (Dlg_Y + 14)),
         C_float (Font_Cfg.Size_Title),
         1.0,
         Gold_Color);

      --  Przycisk zamknięcia [X / Wroc] w prawym górnym rogu
      declare
         Btn_X       : constant int := Dlg_X + Dlg_W - 160;
         Btn_Y       : constant int := Dlg_Y + 10;
         Btn_W       : constant int := 140;
         Btn_H       : constant int := 30;
         Btn_Hovered : constant Boolean :=
           (Mouse_X >= Btn_X and then Mouse_X <= Btn_X + Btn_W and then
            Mouse_Y >= Btn_Y and then Mouse_Y <= Btn_Y + Btn_H);
      begin
         if Btn_Hovered then
            Standard.Raylib.DrawRectangle (Btn_X, Btn_Y, Btn_W, Btn_H, Active_Row_Bg);
            if LMB_Down then Close_Clicked := True; end if;
         end if;
         Standard.Raylib.DrawRectangleLines (Btn_X, Btn_Y, Btn_W, Btn_H, Border_Color);
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            "[X] WROC (ESC)",
            (x => C_float (Btn_X + 15), y => C_float (Btn_Y + 6)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            (if Btn_Hovered then Gold_Color else Text_White));
      end;

      --  4. LEWY PANEL: Lista 7 kategorii (Szerokość 300 px, Wysokość 500 px)
      Standard.Raylib.DrawRectangle (Dlg_X + 10, Dlg_Y + 60, 300, 485, Left_Pane_Bg);
      Standard.Raylib.DrawRectangleLines (Dlg_X + 10, Dlg_Y + 60, 300, 485, Border_Color);

      for Cat in Settings_Category_ID loop
         declare
            Idx      : constant Integer := Settings_Category_ID'Pos (Cat);
            Row_Y    : constant int := Dlg_Y + 70 + int (Idx * 54);
            Row_W    : constant int := 280;
            Row_H    : constant int := 44;
            Row_X    : constant int := Dlg_X + 20;
            Is_Act   : constant Boolean := (State.Selected_Category = Cat);
            Is_Hover : constant Boolean :=
              (Mouse_X >= Row_X and then Mouse_X <= Row_X + Row_W and then
               Mouse_Y >= Row_Y and then Mouse_Y <= Row_Y + Row_H);

            Row_Bg   : constant Standard.Raylib.Color :=
              (if Is_Act then Active_Row_Bg elsif Is_Hover then Header_Bg else Left_Pane_Bg);
            Text_Col : constant Standard.Raylib.Color :=
              (if Is_Act then Gold_Color elsif Is_Hover then Cyan_Color else Text_White);
            Prefix   : constant String := (if Is_Act then "> " else "  ");
            Label    : constant String := Prefix & Gabyx.UI.Settings.Get_Category_Name (Cat);
         begin
            if Is_Hover and then LMB_Down and then not Is_Act then
               State.Selected_Category := Cat;
               Option_Changed := True;
            end if;

            Standard.Raylib.DrawRectangle (Row_X, Row_Y, Row_W, Row_H, Row_Bg);
            if Is_Act then
               Standard.Raylib.DrawRectangleLines (Row_X, Row_Y, Row_W, Row_H, Gold_Color);
            end if;

            Standard.Raylib.DrawTextEx
              (Cur_Font,
               Label,
               (x => C_float (Row_X + 15), y => C_float (Row_Y + 12)),
               C_float (Font_Cfg.Size_Regular),
               1.0,
               Text_Col);
         end;
      end loop;

      --  5. PRAWY PANEL: Szczegóły aktywnej kategorii (Szerokość 660 px, Wysokość 485 px)
      Standard.Raylib.DrawRectangle (Dlg_X + 320, Dlg_Y + 60, 670, 485, Right_Pane_Bg);
      Standard.Raylib.DrawRectangleLines (Dlg_X + 320, Dlg_Y + 60, 670, 485, Border_Color);

      --  Nagłówek prawego panelu
      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "KATEGORIA: " & Gabyx.UI.Settings.Get_Category_Name (State.Selected_Category),
         (x => C_float (Dlg_X + 340), y => C_float (Dlg_Y + 80)),
         C_float (Font_Cfg.Size_Title),
         1.0,
         Cyan_Color);

      Standard.Raylib.DrawTextEx
        (Cur_Font,
         Gabyx.UI.Settings.Get_Category_Description (State.Selected_Category),
         (x => C_float (Dlg_X + 340), y => C_float (Dlg_Y + 115)),
         C_float (Font_Cfg.Size_Small),
         1.0,
         Text_Gray);

      Standard.Raylib.DrawLine (Dlg_X + 340, Dlg_Y + 140, Dlg_X + 960, Dlg_Y + 140, Border_Color);

      --  Obszar kontrolek (Przygotowany pod Krok 5)
      Standard.Raylib.DrawRectangleLines (Dlg_X + 340, Dlg_Y + 160, 630, 365, Header_Bg);
      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "[SZCZEGOLOWE KONTROLKI OPCJI ZOSTANA ZAINICJOWANE W KROKU 5]" & Ada.Characters.Latin_1.LF &
         "Ten obszar pomiesci suwaki, przelaczniki radiowe i listy wyboru." & Ada.Characters.Latin_1.LF &
         "Uzyj strzalek GORA/DOL lub cyfr [1..7], aby przelaczac kategorie.",
         (x => C_float (Dlg_X + 360), y => C_float (Dlg_Y + 220)),
         C_float (Font_Cfg.Size_Regular),
         1.0,
         Text_Muted);

      --  6. Pasek dolny (Wymiary i skróty)
      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "[1..7 / Strzalki / W/S] Wybierz kategorie   [Mysz] Kliknij   [ESC] Wroc",
         (x => C_float (Dlg_X + 24), y => C_float (Dlg_Y + Dlg_H - 30)),
         C_float (Font_Cfg.Size_Small),
         1.0,
         Text_Muted);

      Standard.Raylib.EndDrawing;
   end Render;

end Gabyx.Drivers.Raylib.Settings;
