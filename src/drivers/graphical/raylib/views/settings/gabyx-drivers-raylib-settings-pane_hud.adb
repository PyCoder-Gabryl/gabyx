--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_hud.adb
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.UI.Types;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Widgets;
with Raylib;

package body Gabyx.Drivers.Raylib.Settings.Pane_HUD is

   use Gabyx.UI.Types;

   procedure Render_Pane
     (Pane_X   : Integer;
      Pane_Y   : Integer;
      Pane_W   : Integer;
      Pane_H   : Integer;
      HUD_Cfg  : in out Gabyx.Config.HUD.HUD_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration;
      Changed  : out Boolean)
   is
      pragma Unreferenced (Pane_H);

      Cur_Font : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Font_Sz  : constant Float := Float (Font_Cfg.Size_Small);
      F_Size   : constant Float := (if Font_Sz > 14.0 then 14.0 else Font_Sz);

      Tier_Idx : Positive :=
        (case HUD_Cfg.Active_Tier is
            when HUD_Auto     => 1,
            when HUD_Compact  => 2,
            when HUD_Standard => 3,
            when HUD_HiDPI    => 4);

      Mod_R : Boolean := False;
   begin
      Changed := False;

      --  1. Profile Skalowania HUD-u
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y, W => Pane_W, H => 85,
         Title => "PROFIL SKALOWANIA PASKOW (HUD TIER)",
         Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Radio_4
        (X => Pane_X + 15, Y => Pane_Y + 38, W => Pane_W - 30,
         Opt1 => "Auto",
         Opt2 => "Compact (32/96)",
         Opt3 => "Standard (40/120)",
         Opt4 => "HiDPI (80/240)",
         Selected => Tier_Idx,
         Font => Cur_Font, Font_Size => F_Size,
         Changed => Mod_R);

      if Mod_R then
         HUD_Cfg.Active_Tier :=
           (case Tier_Idx is
               when 1 => HUD_Auto,
               when 2 => HUD_Compact,
               when 3 => HUD_Standard,
               when others => HUD_HiDPI);
         Changed := True;
      end if;

      --  2. Opis Funkcjonalny
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y + 100, W => Pane_W, H => 210,
         Title => "ROZKLAD BLOKOW I FORMAT ULTRA-WIDE (21:9)",
         Font => Cur_Font, Font_Size => F_Size);

      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "• Format 16:9 / 16:10:" & Ada.Characters.Latin_1.LF &
         "  Dolny pasek wyswietla naprzemiennie Widok A (Bohater) lub Widok B (Dziennik)." & Ada.Characters.Latin_1.LF &
         "  Skrot [D] przelacza aktywny blok ze zmiana odcienia tla." & Ada.Characters.Latin_1.LF & Ada.Characters.Latin_1.LF &
         "• Format 21:9 Ultra-Wide:" & Ada.Characters.Latin_1.LF &
         "  Wszystkie 3 bloki (Swiat | Bohater | Dziennik) rozsuwaja sie w jednym rzedzie!",
         (x => Float (Pane_X + 18), y => Float (Pane_Y + 140)),
         F_Size, 1.0, (r => 180, g => 180, b => 180, a => 255));
   end Render_Pane;

end Gabyx.Drivers.Raylib.Settings.Pane_HUD;
