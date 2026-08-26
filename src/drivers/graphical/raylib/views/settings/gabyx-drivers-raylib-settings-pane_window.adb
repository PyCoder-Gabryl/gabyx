--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja panelu Ekran & Okno z belką metryk na żywo i kontrolkami.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_window.adb
--  CREATED:         2026-08-25
--  ============================================================================


with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Widgets;
with Raylib;

package body Gabyx.Drivers.Raylib.Settings.Pane_Window is

   Preset_Names : constant array (1 .. 9) of String (1 .. 26) :=
     [1 => "1280 x 720 (16:9 HD)      ",
      2 => "1440 x 900 (16:10 WXGA)   ",
      3 => "1600 x 900 (16:9 HD+)     ",
      4 => "1920 x 1080 (16:9 FHD)    ",
      5 => "1920 x 1200 (16:10 WUXGA)  ",
      6 => "2560 x 1080 (21:9 UW-HD)  ",
      7 => "2560 x 1440 (16:9 QHD)    ",
      8 => "3440 x 1440 (21:9 UW-QHD) ",
      9 => "3840 x 2160 (16:9 4K UHD) "];

   Zoom_Names : constant array (1 .. 6) of String (1 .. 18) :=
     [1 => "24 px             ",
      2 => "32 px             ",
      3 => "48 px             ",
      4 => "64 px (Baza)      ",
      5 => "80 px             ",
      6 => "96 px (HiDPI)     "];

   procedure Render_Pane
     (Pane_X          : Integer;
      Pane_Y          : Integer;
      Pane_W          : Integer;
      Pane_H          : Integer;
      Staged_Preset   : in out Positive;
      Staged_Mode_Idx : in out Positive;
      Staged_Center   : in out Boolean;
      Staged_HUD_Idx  : in out Positive;
      Staged_Zoom_Idx : in out Positive;
      Font_Cfg        : Gabyx.Config.Fonts.Font_Configuration;
      Apply_Clicked   : out Boolean;
      Changed         : out Boolean)
   is
      pragma Unreferenced (Pane_H);

      Cur_Font       : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Font_Sz        : constant Float := Float (Font_Cfg.Size_Small);
      F_Size         : constant Float := (if Font_Sz > 14.0 then 14.0 else Font_Sz);

      Prev_P, Next_P : Boolean := False;
      Prev_Z, Next_Z : Boolean := False;
      Mod_R1, Mod_R2 : Boolean := False;
      Mod_Switch     : Boolean := False;
   begin
      Apply_Clicked := False;
      Changed       := False;

      --  1. Belka podsumowania metryk na żywo
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y, W => Pane_W, H => 45,
         Title => "PODGLAD METRYK EKRANU NA ZYWO", Font => Cur_Font, Font_Size => F_Size);

      --  2. Sekcja 1: Rozdzielczość i tryb okna
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y + 55, W => Pane_W, H => 150,
         Title => "1. ROZDZIELCZOSC I TRYB WYSWIETLANIA", Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Cycle_Selector
        (X => Pane_X + 15, Y => Pane_Y + 90, W => Pane_W - 30,
         Label => "Rozdzielczosc okna:", Value_Text => Preset_Names (Staged_Preset),
         Font => Cur_Font, Font_Size => F_Size, Prev_Clicked => Prev_P, Next_Clicked => Next_P);

      if Prev_P then
         Staged_Preset := (if Staged_Preset = 1 then 9 else Staged_Preset - 1);
         Changed := True;
      elsif Next_P then
         Staged_Preset := (if Staged_Preset = 9 then 1 else Staged_Preset + 1);
         Changed := True;
      end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Radio_3
        (X => Pane_X + 15, Y => Pane_Y + 130, W => Pane_W - 30,
         Opt1 => "Okno z ramka", Opt2 => "Bezramkowe", Opt3 => "Pelny pulpit",
         Selected => Staged_Mode_Idx, Font => Cur_Font, Font_Size => F_Size, Changed => Mod_R1);
      if Mod_R1 then Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Toggle_Switch
        (X => Pane_X + 15, Y => Pane_Y + 172,
         Label => "Automatycznie centruj okno na srodku monitora",
         State => Staged_Center, Font => Cur_Font, Font_Size => F_Size, Changed => Mod_Switch);
      if Mod_Switch then Changed := True; end if;

      --  3. Sekcja 2: Skalowanie HUD-u
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y + 215, W => Pane_W, H => 75,
         Title => "2. SKALOWANIE INTERFEJSU HUD (PROFILE)", Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Radio_4
        (X => Pane_X + 15, Y => Pane_Y + 248, W => Pane_W - 30,
         Opt1 => "Auto", Opt2 => "Compact (32/96)", Opt3 => "Standard (40/120)", Opt4 => "HiDPI",
         Selected => Staged_HUD_Idx, Font => Cur_Font, Font_Size => F_Size, Changed => Mod_R2);
      if Mod_R2 then Changed := True; end if;

      --  4. Sekcja 3: Zoom kafelka siatki
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y + 300, W => Pane_W, H => 75,
         Title => "3. SKALOWANIE SIATKI SWIATA (ZOOM KAFELKA)", Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Cycle_Selector
        (X => Pane_X + 15, Y => Pane_Y + 332, W => Pane_W - 30,
         Label => "Rozmiar kafelka:", Value_Text => Zoom_Names (Staged_Zoom_Idx),
         Font => Cur_Font, Font_Size => F_Size, Prev_Clicked => Prev_Z, Next_Clicked => Next_Z);

      if Prev_Z then
         Staged_Zoom_Idx := (if Staged_Zoom_Idx = 1 then 6 else Staged_Zoom_Idx - 1);
         Changed := True;
      elsif Next_Z then
         Staged_Zoom_Idx := (if Staged_Zoom_Idx = 6 then 1 else Staged_Zoom_Idx + 1);
         Changed := True;
      end if;

      --  5. Przycisk Zastosowania Zmian
      Gabyx.Drivers.Raylib.Widgets.Draw_Button
        (X => Pane_X + Pane_W - 270, Y => Pane_Y + Pane_H + 8, W => 270, H => 40,
         Label => "[ * ] ZASTOSUJ ZMIANY", Font => Cur_Font, Font_Size => F_Size,
         Clicked => Apply_Clicked);
   end Render_Pane;

end Gabyx.Drivers.Raylib.Settings.Pane_Window;
