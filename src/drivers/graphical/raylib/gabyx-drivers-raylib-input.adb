--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja mapowania klawiszy Raylib na polecenia.
--                    Obsługuje skróty pojedyncze [1]..[9], [B], [ESC] oraz
--                    kombinacje z klawiszem Control (Ctrl+T, Ctrl+B, Ctrl+F, Ctrl+1..3).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib-input.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Interfaces.C;
with Raylib;

package body Gabyx.Drivers.Raylib.Input is

   use Interfaces.C;
   use Gabyx.Commands;

   function Poll_Command return Gabyx.Commands.Game_Command is
      Ctrl_Down : constant Boolean :=
        Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_LEFT_CONTROL))
        or Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_RIGHT_CONTROL));
   begin
      --  1. Skrót wyjścia z programu
      if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ESCAPE)) then
         return Cmd_Quit;
      end if;

      --  2. Kombinacje z klawiszem CONTROL
      if Ctrl_Down then
         if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_T)) then
            return Cmd_Toggle_Top_View;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_B)) then
            return Cmd_Toggle_Bottom_View;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_F)) then
            return Cmd_Toggle_Font_Family;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ZERO))
            or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_H))
         then
            return Cmd_HUD_Tier_Auto;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ONE)) then
            return Cmd_HUD_Tier_Compact;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_TWO)) then
            return Cmd_HUD_Tier_Standard;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_THREE)) then
            return Cmd_HUD_Tier_HiDPI;
         end if;
      else
         --  3. Pojedyncze klawisze funkcyjne
         if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_B)) then
            return Cmd_Toggle_Borderless;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ONE)) then
            return Cmd_Select_Preset_1;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_TWO)) then
            return Cmd_Select_Preset_2;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_THREE)) then
            return Cmd_Select_Preset_3;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FOUR)) then
            return Cmd_Select_Preset_4;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FIVE)) then
            return Cmd_Select_Preset_5;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SIX)) then
            return Cmd_Select_Preset_6;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SEVEN)) then
            return Cmd_Select_Preset_7;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_EIGHT)) then
            return Cmd_Select_Preset_8;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_NINE)) then
            return Cmd_Select_Preset_9;
         end if;
      end if;

      return Cmd_None;
   end Poll_Command;

end Gabyx.Drivers.Raylib.Input;
