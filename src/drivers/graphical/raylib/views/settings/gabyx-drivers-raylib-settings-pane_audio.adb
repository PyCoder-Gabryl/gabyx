--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja panelu Audio. Aktualizuje głośność w czasie rzeczywistym
--                   oraz wyzwala proceduralny dźwięk testowy po kliknięciu przycisku.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/gabyx-drivers-raylib-settings-pane_audio.adb
--  CREATED:         2026-08-25
--  ============================================================================


with Interfaces.C;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Audio;
with Gabyx.Drivers.Raylib.Widgets;
with Raylib;

package body Gabyx.Drivers.Raylib.Settings.Pane_Audio is

   use Interfaces.C;

   procedure Render_Pane
     (Pane_X    : Integer;
      Pane_Y    : Integer;
      Pane_W    : Integer;
      Pane_H    : Integer;
      Audio_Cfg : in out Gabyx.Config.Audio.Audio_Configuration;
      Font_Cfg  : Gabyx.Config.Fonts.Font_Configuration;
      Changed   : out Boolean)
   is
      pragma Unreferenced (Pane_H);

      Cur_Font      : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Font_Sz       : constant Float := Float (Font_Cfg.Size_Small);
      F_Size        : constant Float := (if Font_Sz > 14.0 then 14.0 else Font_Sz);

      Master_Nat    : Natural := Natural (Audio_Cfg.Master_Volume);
      Music_Nat     : Natural := Natural (Audio_Cfg.Music_Volume);
      SFX_Nat       : Natural := Natural (Audio_Cfg.SFX_Volume);
      Amb_Nat       : Natural := Natural (Audio_Cfg.Ambient_Volume);

      Slider_Mod    : Boolean := False;
      Check_Mod     : Boolean := False;
      Test_Clicked  : Boolean := False;
   begin
      Changed := False;

      --  1. Sekcja Suwaków Głośności
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y, W => Pane_W, H => 215,
         Title => "POZIOMY GLOSNOSCI (0 - 100%)", Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Slider
        (X => Pane_X + 15, Y => Pane_Y + 40, W => Pane_W - 30,
         Label => "Glosnosc Glowna (Master):", Value => Master_Nat,
         Min_Val => 0, Max_Val => 100, Font => Cur_Font, Font_Size => F_Size, Changed => Slider_Mod);
      if Slider_Mod then Audio_Cfg.Master_Volume := Volume_Level (Master_Nat); Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Slider
        (X => Pane_X + 15, Y => Pane_Y + 80, W => Pane_W - 30,
         Label => "Muzyka w tle (Music):", Value => Music_Nat,
         Min_Val => 0, Max_Val => 100, Font => Cur_Font, Font_Size => F_Size, Changed => Slider_Mod);
      if Slider_Mod then Audio_Cfg.Music_Volume := Volume_Level (Music_Nat); Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Slider
        (X => Pane_X + 15, Y => Pane_Y + 120, W => Pane_W - 30,
         Label => "Efekty dzwiekowe (SFX):", Value => SFX_Nat,
         Min_Val => 0, Max_Val => 100, Font => Cur_Font, Font_Size => F_Size, Changed => Slider_Mod);
      if Slider_Mod then Audio_Cfg.SFX_Volume := Volume_Level (SFX_Nat); Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Slider
        (X => Pane_X + 15, Y => Pane_Y + 160, W => Pane_W - 30,
         Label => "Tlo otoczenia (Ambient):", Value => Amb_Nat,
         Min_Val => 0, Max_Val => 100, Font => Cur_Font, Font_Size => F_Size, Changed => Slider_Mod);
      if Slider_Mod then Audio_Cfg.Ambient_Volume := Volume_Level (Amb_Nat); Changed := True; end if;

      --  2. Sekcja Opcji Dźwiękowych i Testu
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y + 230, W => Pane_W, H => 125,
         Title => "OPCJE I PROBA DZWIEKU", Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Checkbox
        (X => Pane_X + 15, Y => Pane_Y + 265,
         Label => "Wycisz dzwiek calkowicie (Mute)", Checked => Audio_Cfg.Is_Muted,
         Font => Cur_Font, Font_Size => F_Size, Changed => Check_Mod);
      if Check_Mod then Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Checkbox
        (X => Pane_X + 15, Y => Pane_Y + 305,
         Label => "Dzwieki interfejsu (UI Clicks)", Checked => Audio_Cfg.UI_Clicks_Enabled,
         Font => Cur_Font, Font_Size => F_Size, Changed => Check_Mod);
      if Check_Mod then Changed := True; end if;

      --  3. Przycisk Testu Dźwięku
      Gabyx.Drivers.Raylib.Widgets.Draw_Button
        (X => Pane_X + Pane_W - 220, Y => Pane_Y + 270, W => 205, H => 45,
         Label => "[ > ] TESTUJ SFX", Font => Cur_Font, Font_Size => F_Size,
         Clicked => Test_Clicked);

      --  Natychmiastowa reakcja audio
      if Changed then
         Standard.Raylib.SetMasterVolume
           (if Audio_Cfg.Is_Muted then 0.0 else C_float (Audio_Cfg.Master_Volume) / 100.0);
      end if;

      if Test_Clicked then
         Standard.Raylib.SetMasterVolume
           (if Audio_Cfg.Is_Muted then 0.0 else C_float (Audio_Cfg.Master_Volume) / 100.0);
         Gabyx.Drivers.Raylib.Audio.Play_Menu_Select;
      end if;
   end Render_Pane;

end Gabyx.Drivers.Raylib.Settings.Pane_Audio;
