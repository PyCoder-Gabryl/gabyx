--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja panelu Grafika & FPS z selektorem klatkarza i przełącznikami.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_graphics.adb
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.Types;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Widgets;
with Raylib;

package body Gabyx.Drivers.Raylib.Settings.Pane_Graphics is

   use Gabyx.Types;

   FPS_Labels : constant array (1 .. 8) of String (1 .. 22) :=
     [1 => "Auto (Sprzetowy V-Sync)",
      2 => "30 FPS (Oszczedny)     ",
      3 => "60 FPS (Standardowy)   ",
      4 => "75 FPS                 ",
      5 => "100 FPS (Ultra-Wide)   ",
      6 => "120 FPS (ProMotion)    ",
      7 => "144 FPS (Gaming)       ",
      8 => "165 FPS (Maksymalny)   "];

   FPS_Values : constant array (1 .. 8) of Target_FPS_Type :=
     [0, 30, 60, 75, 100, 120, 144, 165];

   procedure Render_Pane
     (Pane_X   : Integer;
      Pane_Y   : Integer;
      Pane_W   : Integer;
      Pane_H   : Integer;
      Win_Cfg  : in out Gabyx.Config.Window.Window_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration;
      Changed  : out Boolean)
   is
      pragma Unreferenced (Pane_H);

      Cur_Font   : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Font_Sz    : constant Float := Float (Font_Cfg.Size_Small);
      F_Size     : constant Float := (if Font_Sz > 14.0 then 14.0 else Font_Sz);

      Active_Idx : Positive := 1;
      Prev_P     : Boolean := False;
      Next_P     : Boolean := False;
      Mod_Switch : Boolean := False;
   begin
      Changed := False;

      for I in FPS_Values'Range loop
         if Win_Cfg.Target_FPS = FPS_Values (I) then
            Active_Idx := I;
         end if;
      end loop;

      --  1. Sekcja Klatkarza (FPS)
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y, W => Pane_W, H => 150,
         Title => "KLATKARZ I ODPASEK SYNCHRONIZACJI",
         Font => Cur_Font, Font_Size => F_Size);

      Gabyx.Drivers.Raylib.Widgets.Draw_Cycle_Selector
        (X => Pane_X + 15, Y => Pane_Y + 40, W => Pane_W - 30,
         Label => "Limit klatkarza (FPS):",
         Value_Text => FPS_Labels (Active_Idx),
         Font => Cur_Font, Font_Size => F_Size,
         Prev_Clicked => Prev_P, Next_Clicked => Next_P);

      if Prev_P then
         Active_Idx := (if Active_Idx = 1 then 8 else Active_Idx - 1);
         Win_Cfg.Target_FPS := FPS_Values (Active_Idx);
         Changed := True;
      elsif Next_P then
         Active_Idx := (if Active_Idx = 8 then 1 else Active_Idx + 1);
         Win_Cfg.Target_FPS := FPS_Values (Active_Idx);
         Changed := True;
      end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Toggle_Switch
        (X => Pane_X + 15, Y => Pane_Y + 82,
         Label => "Wymuszaj synchronizacje pionowa (V-Sync)",
         State => Win_Cfg.VSync,
         Font => Cur_Font, Font_Size => F_Size,
         Changed => Mod_Switch);
      if Mod_Switch then Changed := True; end if;

      Gabyx.Drivers.Raylib.Widgets.Draw_Toggle_Switch
        (X => Pane_X + 15, Y => Pane_Y + 114,
         Label => "Zachowaj proporcje obrazu (Maintain Aspect Ratio)",
         State => Win_Cfg.Maintain_Aspect_Ratio,
         Font => Cur_Font, Font_Size => F_Size,
         Changed => Mod_Switch);
      if Mod_Switch then Changed := True; end if;

      --  2. Informacje o silniku renderowania
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y + 165, W => Pane_W, H => 140,
         Title => "STEROWNIK GRAFICZNY I AKCELERACJA",
         Font => Cur_Font, Font_Size => F_Size);

      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "Silnik: Raylib 5.0 (Czysta statyczna konsolidacja libraylib.a)" & Ada.Characters.Latin_1.LF &
         "Backend: Metal (Apple Silicon GPU / OpenGL Core Profile)" & Ada.Characters.Latin_1.LF &
         "Format bufora: 32-bit RGBA z podwojnym buforowaniem (Double Buffer)",
         (x => Float (Pane_X + 18), y => Float (Pane_Y + 205)),
         F_Size, 1.0, (r => 170, g => 170, b => 170, a => 255));
   end Render_Pane;

end Gabyx.Drivers.Raylib.Settings.Pane_Graphics;
