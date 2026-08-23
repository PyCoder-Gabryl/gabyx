--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja mapowania klawiszy Raylib na polecenia.
--                   Odpytuje klawiaturę dynamicznie w oparciu o konfigurację
--                   załadowaną z pliku data/config/input.toml.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib-input.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Strings.Unbounded;
with Gabyx.Config.Input;
with Raylib;

package body Gabyx.Drivers.Raylib.Input is

   use Ada.Strings.Unbounded;
   use Gabyx.Commands;

   Input_Cfg : constant Gabyx.Config.Input.Input_Configuration :=
     Gabyx.Config.Input.Load_Configuration;

   function Is_Key_Pressed
     (Binding_Str  : String;
      Opt_Active   : Boolean;
      Any_Mod_Down : Boolean) return Boolean;

   function Is_Key_Pressed
     (Binding_Str  : String;
      Opt_Active   : Boolean;
      Any_Mod_Down : Boolean) return Boolean
   is
      Req_Alt : constant Boolean :=
        (Binding_Str'Length >= 4 and then Binding_Str (Binding_Str'First .. Binding_Str'First + 3) = "ALT+");

      Key_Name : constant String :=
        (if Req_Alt then Binding_Str (Binding_Str'First + 4 .. Binding_Str'Last) else Binding_Str);
   begin
      --  Rygor modyfikatorów: jeśli skrót wymaga Option, musi być wciśnięty wyłącznie Option.
      --  Jeśli skrót jest pojedynczy, żaden modyfikator (ani Option, ani Command, ani Control) nie może być aktywny.
      if Req_Alt then
         if not Opt_Active then
            return False;
         end if;
      else
         if Any_Mod_Down then
            return False;
         end if;
      end if;

      if Key_Name = "ESCAPE" or Key_Name = "ESC" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ESCAPE));
      elsif Key_Name = "SPACE" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SPACE));
      elsif Key_Name = "TAB" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_TAB));
      elsif Key_Name = "G" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_G));
      elsif Key_Name = "D" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_D));
      elsif Key_Name = "F" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_F));
      elsif Key_Name = "B" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_B));
      elsif Key_Name = "S" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_S));
      elsif Key_Name = "H" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_H));
      elsif Key_Name = "W" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_W));
      elsif Key_Name = "0" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ZERO));
      elsif Key_Name = "1" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ONE));
      elsif Key_Name = "2" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_TWO));
      elsif Key_Name = "3" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_THREE));
      elsif Key_Name = "4" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FOUR));
      elsif Key_Name = "5" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FIVE));
      elsif Key_Name = "6" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SIX));
      elsif Key_Name = "7" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SEVEN));
      elsif Key_Name = "8" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_EIGHT));
      elsif Key_Name = "9" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_NINE));
      end if;

      return False;
   end Is_Key_Pressed;

   function Poll_Command return Gabyx.Commands.Game_Command is
      Opt_Down  : constant Boolean :=
        Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_LEFT_ALT))
        or Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_RIGHT_ALT));

      Cmd_Down  : constant Boolean :=
        Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_LEFT_SUPER))
        or Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_RIGHT_SUPER));

      Ctrl_Down : constant Boolean :=
        Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_LEFT_CONTROL))
        or Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_RIGHT_CONTROL));

      Any_Mod   : constant Boolean := Opt_Down or Cmd_Down or Ctrl_Down;
   begin
      if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ESCAPE)) then
         return Cmd_Quit;
      end if;

      --  1. Skróty z klawiszem OPTION (Alt na PC)
      if Opt_Down and then not (Cmd_Down or Ctrl_Down) then
         if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_S)) then
            return Cmd_Toggle_Grid;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FIVE)) then
            return Cmd_Tile_Zoom_1;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SIX)) then
            return Cmd_Tile_Zoom_2;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SEVEN)) then
            return Cmd_Tile_Zoom_3;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_EIGHT)) then
            return Cmd_Tile_Zoom_4;
         elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_NINE)) then
            return Cmd_Tile_Zoom_5;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Tier_Auto), True, True) then
            return Cmd_HUD_Tier_Auto;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Tier_Compact), True, True) then
            return Cmd_HUD_Tier_Compact;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Tier_Standard), True, True) then
            return Cmd_HUD_Tier_Standard;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Tier_HiDPI), True, True) then
            return Cmd_HUD_Tier_HiDPI;
         end if;
      end if;

      --  2. Skróty pojedyncze (tylko gdy brak jakiegokolwiek modyfikatora)
      if not Any_Mod then
         if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_S)) then
            return Cmd_Cycle_Grid_Color;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Toggle_Borderless), False, False) then
            return Cmd_Toggle_Borderless;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Toggle_Top_View), False, False) then
            return Cmd_Toggle_Top_View;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Toggle_Bottom_View), False, False) then
            return Cmd_Toggle_Bottom_View;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Toggle_Font_Family), False, False) then
            return Cmd_Toggle_Font_Family;

         --  Presety rozdzielczości okna [1]..[9]
         elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_1), False, False) then
            return Cmd_Select_Preset_1;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_2), False, False) then
            return Cmd_Select_Preset_2;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_3), False, False) then
            return Cmd_Select_Preset_3;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_4), False, False) then
            return Cmd_Select_Preset_4;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_5), False, False) then
            return Cmd_Select_Preset_5;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_6), False, False) then
            return Cmd_Select_Preset_6;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_7), False, False) then
            return Cmd_Select_Preset_7;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_8), False, False) then
            return Cmd_Select_Preset_8;
         elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_9), False, False) then
            return Cmd_Select_Preset_9;
         end if;
      end if;

      return Cmd_None;
   end Poll_Command;

end Gabyx.Drivers.Raylib.Input;
