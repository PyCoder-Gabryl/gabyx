--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja ekranu startowego Raylib z efektem płynnego
--                   rozjaśniania/wygaszania oraz prezentacją logotypu i wersji silnika.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/core/gabyx-drivers-raylib-splash.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Interfaces.C;
with Gabyx.State_Machine;
with Gabyx.Types;
with Gabyx.Drivers.Raylib.Fonts;
with Raylib;

package body Gabyx.Drivers.Raylib.Splash is

   use Interfaces.C;
   use Gabyx.Types;

   Duration_Sec : Float   := 1.0;
   Elapsed_Time : Float   := 0.0;
   Finished     : Boolean := False;

   procedure Initialize (Game_Cfg : Gabyx.Config.Game.Game_Configuration) is
   begin
      Duration_Sec := Game_Cfg.Splash_Duration_Sec;
      Elapsed_Time := 0.0;
      Finished     := (Duration_Sec <= 0.0);
   end Initialize;

   procedure Process_Frame (Font_Cfg : Gabyx.Config.Fonts.Font_Configuration) is
      Frame_Delta : constant Float := Float (Standard.Raylib.GetFrameTime);
      Skip        : constant Boolean :=
        Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SPACE))
        or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ENTER))
        or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ESCAPE));

      Screen_W : constant int := Standard.Raylib.GetScreenWidth;
      Screen_H : constant int := Standard.Raylib.GetScreenHeight;
      Cur_Font : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;

      Progress   : constant Float := (if Duration_Sec > 0.0 then Elapsed_Time / Duration_Sec else 1.0);
      Alpha_Val  : constant Float :=
        (if Progress < 0.3 then Progress / 0.3
         elsif Progress > 0.7 then (1.0 - Progress) / 0.3
         else 1.0);
      Alpha_Byte : constant unsigned_char :=
        unsigned_char (Float'Max (0.0, Float'Min (255.0, Alpha_Val * 255.0)));

      Center_X : constant C_float := C_float (Screen_W / 2);
      Center_Y : constant C_float := C_float (Screen_H / 2);
   begin
      Elapsed_Time := Elapsed_Time + Frame_Delta;

      if Skip or else Elapsed_Time >= Duration_Sec then
         Finished := True;
         Gabyx.State_Machine.Set_State (State_Main_Menu);
         return;
      end if;

      Standard.Raylib.BeginDrawing;
      Standard.Raylib.ClearBackground ((r => 18, g => 22, b => 26, a => 255));

      Standard.Raylib.DrawTextEx
        (Cur_Font, "G A B Y X", (x => Center_X - 110.0, y => Center_Y - 80.0),
         C_float (Font_Cfg.Size_Large) * 1.5, 2.0, (r => 255, g => 203, b => 0, a => Alpha_Byte));

      Standard.Raylib.DrawTextEx
        (Cur_Font, "ROGUELIKE RPG & CITY-BUILDER", (x => Center_X - 160.0, y => Center_Y - 15.0),
         C_float (Font_Cfg.Size_Regular), 1.0, (r => 245, g => 245, b => 245, a => Alpha_Byte));

      Standard.Raylib.DrawTextEx
        (Cur_Font, "Powered by Ada 2022, SPARK & Raylib (Omni-Engine)", (x => Center_X - 220.0, y => Center_Y + 25.0),
         C_float (Font_Cfg.Size_Small), 1.0, (r => 80, g => 220, b => 240, a => Alpha_Byte));

      Standard.Raylib.DrawTextEx
        (Cur_Font, "[Nacisnij SPACJE, aby pominac]", (x => Center_X - 130.0, y => Center_Y + 120.0),
         C_float (Font_Cfg.Size_Small), 1.0, (r => 140, g => 140, b => 140, a => Alpha_Byte));

      Standard.Raylib.EndDrawing;
   end Process_Frame;

end Gabyx.Drivers.Raylib.Splash;
