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


with Ada.Strings.Unbounded;
with Gabyx.Config;
with Raylib;

package body Gabyx.Drivers.Raylib.Input is

   use Ada.Strings.Unbounded;
   use Gabyx.Commands;

   --  Załadowanie konfiguracji klawiszy z pliku data/config/input.toml
   Input_Cfg : constant Gabyx.Config.Input_Configuration :=
     Gabyx.Config.Load_Input_Configuration;

   --  Funkcja pomocnicza sprawdzająca, czy dany ciąg klawisza (np. "ALT+1", "G") został wciśnięty
   function Is_Key_Pressed (Binding_Str : String; Option_Active : Boolean) return Boolean is
      Req_Alt : constant Boolean :=
        (Binding_Str'Length >= 4 and then Binding_Str (Binding_Str'First .. Binding_Str'First + 3) = "ALT+");

      Key_Name : constant String :=
        (if Req_Alt then Binding_Str (Binding_Str'First + 4 .. Binding_Str'Last) else Binding_Str);
   begin
      --  Weryfikacja stanu modyfikatora Option/Alt
      if Req_Alt /= Option_Active then
         return False;
      end if;

      --  Dopasowanie klawisza Raylib do nazwy ze stringa
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
      elsif Key_Name = "H" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_H));
      elsif Key_Name = "W" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_W));
      elsif Key_Name = "S" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_S));
      elsif Key_Name = "A" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_A));
      elsif Key_Name = "E" then
         return Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_E));
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
      Option_Down : constant Boolean :=
        Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_LEFT_ALT))
        or Boolean (Standard.Raylib.IsKeyDown (Standard.Raylib.KEY_RIGHT_ALT));
   begin
      --  1. Polecenia systemowe
      if Is_Key_Pressed (To_String (Input_Cfg.Quit), Option_Down) then
         return Cmd_Quit;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Toggle_Borderless), Option_Down) then
         return Cmd_Toggle_Borderless;

      --  2. Polecenia pasków HUD i czcionek
      elsif Is_Key_Pressed (To_String (Input_Cfg.Toggle_Top_View), Option_Down) then
         return Cmd_Toggle_Top_View;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Toggle_Bottom_View), Option_Down) then
         return Cmd_Toggle_Bottom_View;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Toggle_Font_Family), Option_Down) then
         return Cmd_Toggle_Font_Family;

      --  3. Profile wielkości HUD-u
      elsif Is_Key_Pressed (To_String (Input_Cfg.Tier_Auto), Option_Down) then
         return Cmd_HUD_Tier_Auto;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Tier_Compact), Option_Down) then
         return Cmd_HUD_Tier_Compact;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Tier_Standard), Option_Down) then
         return Cmd_HUD_Tier_Standard;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Tier_HiDPI), Option_Down) then
         return Cmd_HUD_Tier_HiDPI;

      --  4. Presety rozdzielczości okna
      elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_1), Option_Down) then
         return Cmd_Select_Preset_1;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_2), Option_Down) then
         return Cmd_Select_Preset_2;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_3), Option_Down) then
         return Cmd_Select_Preset_3;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_4), Option_Down) then
         return Cmd_Select_Preset_4;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_5), Option_Down) then
         return Cmd_Select_Preset_5;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_6), Option_Down) then
         return Cmd_Select_Preset_6;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_7), Option_Down) then
         return Cmd_Select_Preset_7;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_8), Option_Down) then
         return Cmd_Select_Preset_8;
      elsif Is_Key_Pressed (To_String (Input_Cfg.Preset_9), Option_Down) then
         return Cmd_Select_Preset_9;
      end if;

      return Cmd_None;
   end Poll_Command;

end Gabyx.Drivers.Raylib.Input;
