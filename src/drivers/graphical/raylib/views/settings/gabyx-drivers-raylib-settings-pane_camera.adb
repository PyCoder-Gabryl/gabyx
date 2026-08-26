--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja panelu Siatka & Kamera z suwakami kinematyki i selektorem kolorów.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_camera.adb
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Widgets;
with Raylib;

package body Gabyx.Drivers.Raylib.Settings.Pane_Camera is

   function Get_Color_Name (Index : Positive) return String is
     (case Index is
         when 1 => "Szmaragdowa zielen CRT",
         when 2 => "Bursztynowe zloto",
         when 3 => "Morski cyjan",
         when 4 => "Jaskrawa magenta",
         when 5 => "Subtelna stal",
         when others => "Dozwolony Kolor");

   procedure Render_Pane
     (Pane_X     : Integer;
      Pane_Y     : Integer;
      Pane_W     : Integer;
      Pane_H     : Integer;
      Camera_Cfg : in out Gabyx.Config.Camera.Camera_Configuration;
      Font_Cfg   : Gabyx.Config.Fonts.Font_Configuration;
      Changed    : out Boolean)
   is
      pragma Unreferenced (Pane_H);

      Cur_Font : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Font_Sz  : constant Float := Float (Font_Cfg.Size_Small);
      F_Size   : constant Float := (if Font_Sz > 14.0 then 14.0 else Font_Sz);

      Dead_Nat : Natural := Natural (Camera_Cfg.Deadzone_Tiles);
      Lerp_Nat : Natural := Natural (Camera_Cfg.Lerp_Duration_Ms);

      Prev_C, Next_C : Boolean := False;
      Mod_Sld        : Boolean := False;
      Mod_Sw         : Boolean := False;
   begin
      Changed := False;

      --  1. Parametry Siatki
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y, W => Pane_W, H => 125,
         Title => "SIATKA KAFELKOWA I KOLORYSTYKA",
         Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Toggle_Switch
        (X => Pane_X + 15, Y => Pane_Y + 40,
         Label => "Widocznosc linii siatki lochu",
         State => Camera_Cfg.Grid_Visible,
         Font => Cur_Font, Font_Size => F_Size,
         Changed => Mod_Sw);
      if Mod_Sw then Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Cycle_Selector
        (X => Pane_X + 15, Y => Pane_Y + 75, W => Pane_W - 30,
         Label => "Kolor linii siatki:",
         Value_Text => Get_Color_Name (Camera_Cfg.Active_Color_Index),
         Font => Cur_Font, Font_Size => F_Size,
         Prev_Clicked => Prev_C, Next_Clicked => Next_C);

      if Prev_C then
         Camera_Cfg.Active_Color_Index :=
           (if Camera_Cfg.Active_Color_Index = 1 then 5 else Camera_Cfg.Active_Color_Index - 1);
         Changed := True;
      elsif Next_C then
         Camera_Cfg.Active_Color_Index :=
           (if Camera_Cfg.Active_Color_Index = 5 then 1 else Camera_Cfg.Active_Color_Index + 1);
         Changed := True;
      end if;

      --  2. Kinematyka Kamery
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y + 140, W => Pane_W, H => 135,
         Title => "KINEMATYKA KAMERY I PLYNNOSC",
         Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Slider
        (X => Pane_X + 15, Y => Pane_Y + 172, W => Pane_W - 30,
         Label => "Martwa strefa (pola):",
         Value => Dead_Nat, Min_Val => 1, Max_Val => 8,
         Font => Cur_Font, Font_Size => F_Size, Changed => Mod_Sld);
      if Mod_Sld then Camera_Cfg.Deadzone_Tiles := Positive (Dead_Nat); Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Slider
        (X => Pane_X + 15, Y => Pane_Y + 212, W => Pane_W - 30,
         Label => "Czas LERP (ms):",
         Value => Lerp_Nat, Min_Val => 60, Max_Val => 240,
         Font => Cur_Font, Font_Size => F_Size, Changed => Mod_Sld);
      if Mod_Sld then Camera_Cfg.Lerp_Duration_Ms := Positive (Lerp_Nat); Changed := True; end if;
   end Render_Pane;

end Gabyx.Drivers.Raylib.Settings.Pane_Camera;
