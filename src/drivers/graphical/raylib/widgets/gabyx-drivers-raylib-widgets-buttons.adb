--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja atomowych kontrolek przycisków i przełączników.
--                    Odpytuje stan kursora myszy Raylib, kalkuluje strefy trafienia
--                    oraz aplikuje semantyczne barwy z motywu Gabyx.UI.Theme.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets-buttons.adb
--  CREATED:         2026-08-29
--  ============================================================================


with Interfaces.C;
with Gabyx.Types;
with Gabyx.UI.Theme;

package body Gabyx.Drivers.Raylib.Widgets.Buttons is

   use Interfaces.C;

   --  ============================================================================
   --  POMOCNICZE FUNKCJE WEWNĘTRZNE
   --  ============================================================================

   function To_Raylib_Color (C : Gabyx.Types.RGBA_Color) return Standard.Raylib.Color is
     ((r => unsigned_char (C.R),
       g => unsigned_char (C.G),
       b => unsigned_char (C.B),
       a => unsigned_char (C.A)));

   --  ============================================================================
   --  PUBLICZNY INTERFEJS
   --  ============================================================================

   procedure Draw_Button
     (X, Y, W, H : Integer;
      Label      : String;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Clicked    : out Boolean)
   is
      Mouse_X   : constant Integer := Integer (Standard.Raylib.GetMouseX);
      Mouse_Y   : constant Integer := Integer (Standard.Raylib.GetMouseY);
      LMB_Press : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Is_Hover  : constant Boolean :=
        (Mouse_X >= X and then Mouse_X <= X + W and then
         Mouse_Y >= Y and then Mouse_Y <= Y + H);

      Btn_Bg    : constant Standard.Raylib.Color :=
        (if Is_Hover then (r => 38, g => 50, b => 65, a => 255)
         else To_Raylib_Color (Gabyx.UI.Theme.Color_Header_Dark));
      Bord_Col  : constant Standard.Raylib.Color :=
        (if Is_Hover then To_Raylib_Color (Gabyx.UI.Theme.Color_Gold)
         else To_Raylib_Color (Gabyx.UI.Theme.Color_Border));
      Text_Col  : constant Standard.Raylib.Color :=
        (if Is_Hover then To_Raylib_Color (Gabyx.UI.Theme.Color_Gold)
         else To_Raylib_Color (Gabyx.UI.Theme.Color_Text_White));
   begin
      Clicked := (Is_Hover and then LMB_Press);

      Standard.Raylib.DrawRectangle (int (X), int (Y), int (W), int (H), Btn_Bg);
      Standard.Raylib.DrawRectangleLines (int (X), int (Y), int (W), int (H), Bord_Col);

      Standard.Raylib.DrawTextEx
        (Font, Label, (x => C_float (X + 16), y => C_float (Y + 8)),
         C_float (Font_Size), 1.0, Text_Col);
   end Draw_Button;

   procedure Draw_Toggle_Switch
     (X, Y       : Integer;
      Label      : String;
      State      : in out Boolean;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean)
   is
      Mouse_X   : constant Integer := Integer (Standard.Raylib.GetMouseX);
      Mouse_Y   : constant Integer := Integer (Standard.Raylib.GetMouseY);
      LMB_Press : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Switch_W  : constant Integer := 64;
      Switch_H  : constant Integer := 24;

      Is_Hover  : constant Boolean :=
        (Mouse_X >= X and then Mouse_X <= X + 450 and then
         Mouse_Y >= Y and then Mouse_Y <= Y + 26);

      Track_Bg   : constant Standard.Raylib.Color :=
        (if State then (r => 38, g => 65, b => 80, a => 255)
         else To_Raylib_Color (Gabyx.UI.Theme.Color_Pane_Left));
      Track_Bord : constant Standard.Raylib.Color :=
        (if State then To_Raylib_Color (Gabyx.UI.Theme.Color_Cyan)
         else To_Raylib_Color (Gabyx.UI.Theme.Color_Border));
      Thumb_Col  : constant Standard.Raylib.Color :=
        (if State then To_Raylib_Color (Gabyx.UI.Theme.Color_Gold)
         else To_Raylib_Color (Gabyx.UI.Theme.Color_Text_Gray));
      Text_Col   : constant Standard.Raylib.Color :=
        (if Is_Hover then To_Raylib_Color (Gabyx.UI.Theme.Color_Gold)
         else To_Raylib_Color (Gabyx.UI.Theme.Color_Text_White));
   begin
      Changed := False;

      if Is_Hover and then LMB_Press then
         State   := not State;
         Changed := True;
      end if;

      Standard.Raylib.DrawRectangle (int (X), int (Y), int (Switch_W), int (Switch_H), Track_Bg);
      Standard.Raylib.DrawRectangleLines (int (X), int (Y), int (Switch_W), int (Switch_H), Track_Bord);

      if State then
         Standard.Raylib.DrawRectangle (int (X + 38), int (Y + 3), 22, 18, Thumb_Col);
         Standard.Raylib.DrawTextEx
           (Font, "ON", (x => C_float (X + 8), y => C_float (Y + 4)),
            12.0, 1.0, To_Raylib_Color (Gabyx.UI.Theme.Color_Cyan));
      else
         Standard.Raylib.DrawRectangle (int (X + 4), int (Y + 3), 22, 18, Thumb_Col);
         Standard.Raylib.DrawTextEx
           (Font, "OFF", (x => C_float (X + 32), y => C_float (Y + 4)),
            12.0, 1.0, To_Raylib_Color (Gabyx.UI.Theme.Color_Text_Muted));
      end if;

      Standard.Raylib.DrawTextEx
        (Font, Label, (x => C_float (X + 76), y => C_float (Y + 3)),
         C_float (Font_Size), 1.0, Text_Col);
   end Draw_Toggle_Switch;

end Gabyx.Drivers.Raylib.Widgets.Buttons;
