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
with Gabyx.Drivers.Raylib.Fonts;
with Raylib;

package body Gabyx.Drivers.Raylib.Menu is

   use Interfaces.C;
   use Gabyx.UI.Menu;

   procedure Render
     (State    : in out Gabyx.UI.Menu.Menu_State;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration;
      Selected : in out Boolean)
   is
      Screen_W : constant int := Standard.Raylib.GetScreenWidth;
      Screen_H : constant int := Standard.Raylib.GetScreenHeight;
      Cur_Font : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;

      Mouse_X  : constant int := Standard.Raylib.GetMouseX;
      Mouse_Y  : constant int := Standard.Raylib.GetMouseY;
      LMB_Down : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Center_X : constant C_float := C_float (Screen_W / 2);
      Menu_Y   : constant C_float := C_float (Screen_H / 2) - 100.0;

      Bg_Color       : constant Standard.Raylib.Color := (r => 18,  g => 22,  b => 26,  a => 255);
      Box_Color      : constant Standard.Raylib.Color := (r => 26,  g => 34,  b => 45,  a => 255);
      Active_Color   : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0,   a => 255);
      Normal_Color   : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Disabled_Color : constant Standard.Raylib.Color := (r => 90,  g => 95,  b => 105, a => 255);
      Border_Color   : constant Standard.Raylib.Color := (r => 60,  g => 75,  b => 95,  a => 255);
      Footer_Color   : constant Standard.Raylib.Color := (r => 140, g => 140, b => 140, a => 255);
   begin
      Standard.Raylib.BeginDrawing;
      Standard.Raylib.ClearBackground (Bg_Color);

      --  Tytuł główny
      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "G A B Y X",
         (x => Center_X - 110.0, y => Menu_Y - 90.0),
         C_float (Font_Cfg.Size_Large) * 1.4,
         2.0,
         Active_Color);

      --  Ramka kontenera menu (szerokość 420 px, wysokość 340 px)
      Standard.Raylib.DrawRectangle
        (int (Center_X - 210.0), int (Menu_Y - 20.0), 420, 340, Box_Color);
      Standard.Raylib.DrawRectangleLines
        (int (Center_X - 210.0), int (Menu_Y - 20.0), 420, 340, Border_Color);

      --  Renderowanie 8 pozycji menu
      for Item in Gabyx.UI.Menu.Menu_Item_ID loop
         declare
            Idx        : constant Integer := Gabyx.UI.Menu.Menu_Item_ID'Pos (Item);
            Item_Y     : constant C_float := Menu_Y + C_float (Idx * 40);
            Is_Chosen  : constant Boolean := (State.Selected_Item = Item);
            Is_Enabled : constant Boolean := Gabyx.UI.Menu.Is_Item_Enabled (State, Item);

            --  Obszar trafienia myszą (Hit-Box)
            Box_Min_X  : constant int := int (Center_X - 190.0);
            Box_Max_X  : constant int := int (Center_X + 190.0);
            Box_Min_Y  : constant int := int (Item_Y - 5.0);
            Box_Max_Y  : constant int := int (Item_Y + 30.0);
            Is_Hovered : constant Boolean :=
              (Mouse_X >= Box_Min_X and then Mouse_X <= Box_Max_X and then
               Mouse_Y >= Box_Min_Y and then Mouse_Y <= Box_Max_Y);

            Text_Col   : constant Standard.Raylib.Color :=
              (if not Is_Enabled then Disabled_Color
               elsif Is_Chosen or Is_Hovered then Active_Color
               else Normal_Color);

            Prefix     : constant String := (if Is_Chosen then "> " else "  ");
            Suffix     : constant String := (if Is_Chosen then " <" else "");
            Label      : constant String := Prefix & Gabyx.UI.Menu.Get_Item_Label (Item) & Suffix;
         begin
            --  Obsługa najechania i kliknięcia myszą
            if Is_Hovered and then Is_Enabled then
               if not Is_Chosen then
                  State.Selected_Item := Item;
               end if;
               if LMB_Down then
                  Selected := True;
               end if;
            end if;

            Standard.Raylib.DrawTextEx
              (Cur_Font,
               Label,
               (x => Center_X - 180.0, y => Item_Y),
               C_float (Font_Cfg.Size_Regular),
               1.0,
               Text_Col);
         end;
      end loop;

      --  Pasek dolny ze skrótami
      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "[1..8 / Strzalki / W/S] Wybor   [Enter / Spacja / Mysz] Zatwierdz   [ESC] Wyjscie",
         (x => Center_X - 310.0, y => C_float (Screen_H - 40)),
         C_float (Font_Cfg.Size_Small),
         1.0,
         Footer_Color);

      Standard.Raylib.EndDrawing;
   end Render;

end Gabyx.Drivers.Raylib.Menu;
