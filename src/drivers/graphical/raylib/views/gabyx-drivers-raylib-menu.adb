--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja widoku Menu Głównego Raylib z obsługą myszy i stylami.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/gabyx-drivers-raylib-menu.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Interfaces.C;
with Gabyx.Types;
with Gabyx.State_Machine;
with Gabyx.UI.Menu;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Audio;
with Gabyx.Drivers.Raylib.Settings;
with Raylib;

package body Gabyx.Drivers.Raylib.Menu is

   use Interfaces.C;
   use Gabyx.Types;
   use Gabyx.UI.Menu;

   Menu_Data : Gabyx.UI.Menu.Menu_State;

   procedure Initialize is
   begin
      Menu_Data := (Selected_Item => Item_New_Game, Has_Save_File => False, Has_Active_Game => False);
   end Initialize;

   procedure Set_Active_Game (Active : Boolean) is
   begin
      Menu_Data.Has_Active_Game := Active;
   end Set_Active_Game;

   procedure Process_Frame (Font_Cfg : Gabyx.Config.Fonts.Font_Configuration) is
      Action_Triggered : Boolean := False;

      procedure Try_Select (Item : Menu_Item_ID);
      procedure Try_Select (Item : Menu_Item_ID) is
      begin
         if Is_Item_Enabled (Menu_Data, Item) then
            Menu_Data.Selected_Item := Item;
            Action_Triggered := True;
         end if;
      end Try_Select;

      Screen_W : constant int := Standard.Raylib.GetScreenWidth;
      Screen_H : constant int := Standard.Raylib.GetScreenHeight;
      Cur_Font : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Mouse_X  : constant int := Standard.Raylib.GetMouseX;
      Mouse_Y  : constant int := Standard.Raylib.GetMouseY;
      LMB_Down : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Center_X : constant C_float := C_float (Screen_W / 2);
      Menu_Y   : constant C_float := C_float (Screen_H / 2) - 100.0;
   begin
      --  1. Wejście z klawiatury
      if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ONE)) then Try_Select (Item_New_Game);
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_TWO)) then Try_Select (Item_Continue);
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_THREE)) then Try_Select (Item_Save_Game);
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FOUR)) then Try_Select (Item_Load_Game);
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_FIVE)) then Try_Select (Item_Settings);
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SIX)) then Try_Select (Item_Help);
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SEVEN)) then Try_Select (Item_About);
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_EIGHT)) then Try_Select (Item_Quit);
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_DOWN))
         or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_S))
      then
         Select_Next (Menu_Data);
         Gabyx.Drivers.Raylib.Audio.Play_Menu_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_UP))
         or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_W))
      then
         Select_Prev (Menu_Data);
         Gabyx.Drivers.Raylib.Audio.Play_Menu_Move;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ENTER))
         or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SPACE))
      then
         if Is_Item_Enabled (Menu_Data, Menu_Data.Selected_Item) then
            Action_Triggered := True;
         end if;
      elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ESCAPE)) then
         Gabyx.State_Machine.Set_State (State_Quit);
         return;
      end if;

      --  2. Renderowanie i obsługa myszy
      Standard.Raylib.BeginDrawing;
      Standard.Raylib.ClearBackground ((r => 18, g => 22, b => 26, a => 255));

      Standard.Raylib.DrawTextEx
        (Cur_Font, "G A B Y X", (x => Center_X - 110.0, y => Menu_Y - 90.0),
         C_float (Font_Cfg.Size_Large) * 1.4, 2.0, (r => 255, g => 203, b => 0, a => 255));

      Standard.Raylib.DrawRectangle (int (Center_X - 210.0), int (Menu_Y - 20.0), 420, 340, (r => 26, g => 34, b => 45, a => 255));
      Standard.Raylib.DrawRectangleLines (int (Center_X - 210.0), int (Menu_Y - 20.0), 420, 340, (r => 60, g => 75, b => 95, a => 255));

      for Item in Menu_Item_ID loop
         declare
            Idx        : constant Integer := Menu_Item_ID'Pos (Item);
            Item_Y     : constant C_float := Menu_Y + C_float (Idx * 40);
            Is_Chosen  : constant Boolean := (Menu_Data.Selected_Item = Item);
            Is_Enabled : constant Boolean := Is_Item_Enabled (Menu_Data, Item);

            Box_Min_X  : constant int := int (Center_X - 190.0);
            Box_Max_X  : constant int := int (Center_X + 190.0);
            Box_Min_Y  : constant int := int (Item_Y - 5.0);
            Box_Max_Y  : constant int := int (Item_Y + 30.0);
            Is_Hovered : constant Boolean :=
              (Mouse_X >= Box_Min_X and then Mouse_X <= Box_Max_X and then
               Mouse_Y >= Box_Min_Y and then Mouse_Y <= Box_Max_Y);

            Text_Col   : constant Standard.Raylib.Color :=
              (if not Is_Enabled then (r => 90, g => 95, b => 105, a => 255)
               elsif Is_Chosen or Is_Hovered then (r => 255, g => 203, b => 0, a => 255)
               else (r => 245, g => 245, b => 245, a => 255));
            Label      : constant String := (if Is_Chosen then "> " else "  ") & Get_Item_Label (Item) & (if Is_Chosen then " <" else "");
         begin
            if Is_Hovered and then Is_Enabled then
               if not Is_Chosen then Menu_Data.Selected_Item := Item; end if;
               if LMB_Down then Action_Triggered := True; end if;
            end if;

            Standard.Raylib.DrawTextEx
              (Cur_Font, Label, (x => Center_X - 180.0, y => Item_Y),
               C_float (Font_Cfg.Size_Regular), 1.0, Text_Col);
         end;
      end loop;

      Standard.Raylib.DrawTextEx
        (Cur_Font, "[1..8 / Strzalki / W/S] Wybor   [Enter / Spacja / Mysz] Zatwierdz   [ESC] Wyjscie",
         (x => Center_X - 310.0, y => C_float (Screen_H - 40)), C_float (Font_Cfg.Size_Small), 1.0, (r => 140, g => 140, b => 140, a => 255));

      Standard.Raylib.EndDrawing;

      --  3. Wykonanie akcji
      if Action_Triggered then
         Gabyx.Drivers.Raylib.Audio.Play_Menu_Select;
         case Menu_Data.Selected_Item is
            when Item_New_Game =>
               Menu_Data.Has_Active_Game := True;
               Gabyx.State_Machine.Set_State (State_In_Game);
            when Item_Settings =>
               Gabyx.Drivers.Raylib.Settings.Open_From (State_Main_Menu);
               Gabyx.State_Machine.Set_State (State_Settings);
            when Item_Quit =>
               Gabyx.State_Machine.Set_State (State_Quit);
            when others =>
               null;
         end case;
      end if;
   end Process_Frame;

end Gabyx.Drivers.Raylib.Menu;
