--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja panelu Typografia z suwakami rozmiarów i wyborem krojów.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_fonts.adb
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Widgets;
with Raylib;

package body Gabyx.Drivers.Raylib.Settings.Pane_Fonts is

   procedure Render_Pane
     (Pane_X   : Integer;
      Pane_Y   : Integer;
      Pane_W   : Integer;
      Pane_H   : Integer;
      Font_Cfg : in out Gabyx.Config.Fonts.Font_Configuration;
      Changed  : out Boolean)
   is
      pragma Unreferenced (Pane_H);

      Cur_Font   : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Font_Sz    : constant Float := Float (Font_Cfg.Size_Small);
      F_Size     : constant Float := (if Font_Sz > 14.0 then 14.0 else Font_Sz);

      Cur_Fam    : constant String := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font_Name;
      Radio_Fam  : Positive := (if Cur_Fam = "Intel One Mono" then 1 else 2);

      Small_Nat  : Natural := Natural (Font_Cfg.Size_Small);
      Reg_Nat    : Natural := Natural (Font_Cfg.Size_Regular);
      Title_Nat  : Natural := Natural (Font_Cfg.Size_Title);

      Mod_R      : Boolean := False;
      Mod_Sld    : Boolean := False;
      Mod_Sw     : Boolean := False;
   begin
      Changed := False;

      --  1. Wybór Rodziny Czcionki
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y, W => Pane_W, H => 80,
         Title => "KROJ PISMA (NERD FONTS)",
         Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Radio_3
        (X => Pane_X + 15, Y => Pane_Y + 38, W => Pane_W - 30,
         Opt1 => "Intel One Mono",
         Opt2 => "JetBrains Mono",
         Opt3 => "Monospace (Auto)",
         Selected => Radio_Fam,
         Font => Cur_Font, Font_Size => F_Size,
         Changed => Mod_R);

      if Mod_R then
         if (Radio_Fam = 1 and then Cur_Fam /= "Intel One Mono")
            or else (Radio_Fam = 2 and then Cur_Fam /= "JetBrains Mono")
         then
            Gabyx.Drivers.Raylib.Fonts.Toggle_Font;
         end if;
         Changed := True;
      end if;

      --  2. Rozmiary Czcionek UI
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y + 95, W => Pane_W, H => 155,
         Title => "ROZMIARY GLIFOW INTERFEJSU",
         Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Slider
        (X => Pane_X + 15, Y => Pane_Y + 128, W => Pane_W - 30,
         Label => "Maly tekst (HUD / Hinty):",
         Value => Small_Nat, Min_Val => 10, Max_Val => 20,
         Font => Cur_Font, Font_Size => F_Size, Changed => Mod_Sld);
      if Mod_Sld then Font_Cfg.Size_Small := Font_Size_Type (Small_Nat); Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Slider
        (X => Pane_X + 15, Y => Pane_Y + 168, W => Pane_W - 30,
         Label => "Standardowy (Menu / Opcje):",
         Value => Reg_Nat, Min_Val => 14, Max_Val => 28,
         Font => Cur_Font, Font_Size => F_Size, Changed => Mod_Sld);
      if Mod_Sld then Font_Cfg.Size_Regular := Font_Size_Type (Reg_Nat); Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Slider
        (X => Pane_X + 15, Y => Pane_Y + 208, W => Pane_W - 30,
         Label => "Naglowki (Tytuly sekcji):",
         Value => Title_Nat, Min_Val => 20, Max_Val => 40,
         Font => Cur_Font, Font_Size => F_Size, Changed => Mod_Sld);
      if Mod_Sld then Font_Cfg.Size_Title := Font_Size_Type (Title_Nat); Changed := True; end if;

      --  3. Wygładzanie
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y + 265, W => Pane_W, H => 75,
         Title => "JAKOSC RENDEROWANIA TEKSTU",
         Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Toggle_Switch
        (X => Pane_X + 15, Y => Pane_Y + 298,
         Label => "Wygladzanie krawedzi glifow (Bilinear Filtering)",
         State => Font_Cfg.Smooth_Filter,
         Font => Cur_Font, Font_Size => F_Size,
         Changed => Mod_Sw);
      if Mod_Sw then Changed := True; end if;
   end Render_Pane;

end Gabyx.Drivers.Raylib.Settings.Pane_Fonts;
