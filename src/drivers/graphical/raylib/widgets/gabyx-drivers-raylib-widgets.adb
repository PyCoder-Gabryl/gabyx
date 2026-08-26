--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja kontrolek GUI Raylib. Obsługuje przeciąganie suwaków,
--                   przełączanie checkboxów oraz kalkulację obszarów trafienia myszą.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets.adb
--  CREATED:         2026-08-25
--  ============================================================================


with Interfaces.C;

package body Gabyx.Drivers.Raylib.Widgets is

   use Interfaces.C;

   procedure Draw_Section_Box
     (X, Y, W, H : Integer;
      Title      : String;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float)
   is
      Box_Bg     : constant Standard.Raylib.Color := (r => 18, g => 22, b => 26, a => 255);
      Border_Col : constant Standard.Raylib.Color := (r => 60, g => 75, b => 95, a => 255);
      Gold_Col   : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0, a => 255);
   begin
      Standard.Raylib.DrawRectangle (int (X), int (Y), int (W), int (H), Box_Bg);
      Standard.Raylib.DrawRectangleLines (int (X), int (Y), int (W), int (H), Border_Col);

      Standard.Raylib.DrawRectangle
        (int (X), int (Y), int (W), 28, (r => 26, g => 34, b => 45, a => 255));
      Standard.Raylib.DrawLine
        (int (X), int (Y + 28), int (X + W), int (Y + 28), Border_Col);

      Standard.Raylib.DrawTextEx
        (Font, Title, (x => C_float (X + 12), y => C_float (Y + 6)),
         C_float (Font_Size), 1.0, Gold_Col);
   end Draw_Section_Box;

   procedure Draw_Slider
     (X, Y, W    : Integer;
      Label      : String;
      Value      : in out Natural;
      Min_Val    : Natural;
      Max_Val    : Natural;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean)
   is
      Mouse_X  : constant Integer := Integer (Standard.Raylib.GetMouseX);
      Mouse_Y  : constant Integer := Integer (Standard.Raylib.GetMouseY);
      LMB_Down : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonDown (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Bar_X    : constant Integer := X + 240;
      Bar_Y    : constant Integer := Y + 6;
      Bar_W    : constant Integer := W - 320;
      Bar_H    : constant Integer := 16;

      Is_Hover : constant Boolean :=
        (Mouse_X >= Bar_X - 5 and then Mouse_X <= Bar_X + Bar_W + 5 and then
         Mouse_Y >= Bar_Y - 5 and then Mouse_Y <= Bar_Y + Bar_H + 5);

      Span     : constant Float := Float (Max_Val - Min_Val);
      Rel_Val  : constant Float := (if Span > 0.0 then Float (Value - Min_Val) / Span else 0.0);
      Fill_W   : constant Integer := Integer (Rel_Val * Float (Bar_W));

      Text_Col : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Bar_Bg   : constant Standard.Raylib.Color := (r => 14,  g => 17,  b => 20,  a => 255);
      Fill_Col : constant Standard.Raylib.Color := (r => 80,  g => 220, b => 240, a => 255);
      Bord_Col : constant Standard.Raylib.Color := (r => 60,  g => 75,  b => 95,  a => 255);
   begin
      Changed := False;

      if Is_Hover and then LMB_Down and then Bar_W > 0 then
         declare
            Clamped_X : constant Float :=
              Float'Max (0.0, Float'Min (Float (Bar_W), Float (Mouse_X - Bar_X)));
            New_Val   : constant Natural := Min_Val + Natural ((Clamped_X / Float (Bar_W)) * Span);
         begin
            if New_Val /= Value then
               Value := New_Val;
               Changed := True;
            end if;
         end;
      end if;

      Standard.Raylib.DrawTextEx
        (Font, Label, (x => C_float (X), y => C_float (Y + 4)),
         C_float (Font_Size), 1.0, Text_Col);

      Standard.Raylib.DrawRectangle (int (Bar_X), int (Bar_Y), int (Bar_W), int (Bar_H), Bar_Bg);
      Standard.Raylib.DrawRectangle (int (Bar_X), int (Bar_Y), int (Fill_W), int (Bar_H), Fill_Col);
      Standard.Raylib.DrawRectangleLines (int (Bar_X), int (Bar_Y), int (Bar_W), int (Bar_H), Bord_Col);

      Standard.Raylib.DrawTextEx
        (Font, Value'Image & "%", (x => C_float (Bar_X + Bar_W + 15), y => C_float (Y + 4)),
         C_float (Font_Size), 1.0, (if Changed then (r => 255, g => 203, b => 0, a => 255) else Text_Col));
   end Draw_Slider;

   procedure Draw_Checkbox
     (X, Y       : Integer;
      Label      : String;
      Checked    : in out Boolean;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean)
   is
      Mouse_X   : constant Integer := Integer (Standard.Raylib.GetMouseX);
      Mouse_Y   : constant Integer := Integer (Standard.Raylib.GetMouseY);
      LMB_Press : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Box_Size  : constant Integer := 22;
      Is_Hover  : constant Boolean :=
        (Mouse_X >= X and then Mouse_X <= X + 350 and then
         Mouse_Y >= Y and then Mouse_Y <= Y + Box_Size);

      Box_Bg    : constant Standard.Raylib.Color := (r => 14, g => 17, b => 20, a => 255);
      Bord_Col  : constant Standard.Raylib.Color :=
        (if Is_Hover then (r => 255, g => 203, b => 0, a => 255) else (r => 60, g => 75, b => 95, a => 255));
      Gold_Col  : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0, a => 255);
      Text_Col  : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
   begin
      Changed := False;

      if Is_Hover and then LMB_Press then
         Checked := not Checked;
         Changed := True;
      end if;

      Standard.Raylib.DrawRectangle (int (X), int (Y), int (Box_Size), int (Box_Size), Box_Bg);
      Standard.Raylib.DrawRectangleLines (int (X), int (Y), int (Box_Size), int (Box_Size), Bord_Col);

      if Checked then
         Standard.Raylib.DrawRectangle (int (X + 4), int (Y + 4), int (Box_Size - 8), int (Box_Size - 8), Gold_Col);
      end if;

      Standard.Raylib.DrawTextEx
        (Font, Label, (x => C_float (X + 32), y => C_float (Y + 2)),
         C_float (Font_Size), 1.0, (if Is_Hover then Gold_Col else Text_Col));
   end Draw_Checkbox;

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
        (if Is_Hover then (r => 38, g => 50, b => 65, a => 255) else (r => 26, g => 34, b => 45, a => 255));
      Bord_Col  : constant Standard.Raylib.Color :=
        (if Is_Hover then (r => 255, g => 203, b => 0, a => 255) else (r => 60, g => 75, b => 95, a => 255));
      Text_Col  : constant Standard.Raylib.Color :=
        (if Is_Hover then (r => 255, g => 203, b => 0, a => 255) else (r => 245, g => 245, b => 245, a => 255));
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
        (if State then (r => 38, g => 65, b => 80, a => 255) else (r => 22, g => 27, b => 34, a => 255));
      Track_Bord : constant Standard.Raylib.Color :=
        (if State then (r => 80, g => 220, b => 240, a => 255) else (r => 60, g => 75, b => 95, a => 255));
      Thumb_Col  : constant Standard.Raylib.Color :=
        (if State then (r => 255, g => 203, b => 0, a => 255) else (r => 140, g => 140, b => 140, a => 255));
      Text_Col   : constant Standard.Raylib.Color :=
        (if Is_Hover then (r => 255, g => 203, b => 0, a => 255) else (r => 245, g => 245, b => 245, a => 255));
   begin
      Changed := False;

      if Is_Hover and then LMB_Press then
         State := not State;
         Changed := True;
      end if;

      Standard.Raylib.DrawRectangle (int (X), int (Y), int (Switch_W), int (Switch_H), Track_Bg);
      Standard.Raylib.DrawRectangleLines (int (X), int (Y), int (Switch_W), int (Switch_H), Track_Bord);

      if State then
         Standard.Raylib.DrawRectangle (int (X + 38), int (Y + 3), 22, 18, Thumb_Col);
         Standard.Raylib.DrawTextEx
           (Font, "ON", (x => C_float (X + 8), y => C_float (Y + 4)),
            12.0, 1.0, (r => 80, g => 220, b => 240, a => 255));
      else
         Standard.Raylib.DrawRectangle (int (X + 4), int (Y + 3), 22, 18, Thumb_Col);
         Standard.Raylib.DrawTextEx
           (Font, "OFF", (x => C_float (X + 32), y => C_float (Y + 4)),
            12.0, 1.0, (r => 140, g => 140, b => 140, a => 255));
      end if;

      Standard.Raylib.DrawTextEx
        (Font, Label, (x => C_float (X + 76), y => C_float (Y + 3)),
         C_float (Font_Size), 1.0, Text_Col);
   end Draw_Toggle_Switch;

   procedure Draw_Cycle_Selector
     (X, Y, W       : Integer;
      Label         : String;
      Value_Text    : String;
      Font          : Standard.Raylib.Font;
      Font_Size     : Float;
      Prev_Clicked  : out Boolean;
      Next_Clicked  : out Boolean)
   is
      Mouse_X    : constant Integer := Integer (Standard.Raylib.GetMouseX);
      Mouse_Y    : constant Integer := Integer (Standard.Raylib.GetMouseY);
      LMB_Press  : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Box_X      : constant Integer := X + 240;
      Box_W      : constant Integer := W - 240;
      Box_H      : constant Integer := 30;

      Btn_Prev_X : constant Integer := Box_X;
      Btn_Next_X : constant Integer := Box_X + Box_W - 36;

      Hov_Prev   : constant Boolean :=
        (Mouse_X >= Btn_Prev_X and then Mouse_X <= Btn_Prev_X + 36 and then
         Mouse_Y >= Y and then Mouse_Y <= Y + Box_H);

      Hov_Next   : constant Boolean :=
        (Mouse_X >= Btn_Next_X and then Mouse_X <= Btn_Next_X + 36 and then
         Mouse_Y >= Y and then Mouse_Y <= Y + Box_H);

      Box_Bg     : constant Standard.Raylib.Color := (r => 14, g => 17, b => 20, a => 255);
      Bord_Col   : constant Standard.Raylib.Color := (r => 60, g => 75, b => 95, a => 255);
      Gold_Col   : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0, a => 255);
      Text_Col   : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
   begin
      Prev_Clicked := (Hov_Prev and then LMB_Press);
      Next_Clicked := (Hov_Next and then LMB_Press);

      Standard.Raylib.DrawTextEx
        (Font, Label, (x => C_float (X), y => C_float (Y + 6)),
         C_float (Font_Size), 1.0, Text_Col);

      Standard.Raylib.DrawRectangle (int (Box_X), int (Y), int (Box_W), int (Box_H), Box_Bg);
      Standard.Raylib.DrawRectangleLines (int (Box_X), int (Y), int (Box_W), int (Box_H), Bord_Col);

      Standard.Raylib.DrawRectangle
        (int (Btn_Prev_X), int (Y), 36, int (Box_H),
         (if Hov_Prev then (r => 38, g => 50, b => 65, a => 255) else Box_Bg));
      Standard.Raylib.DrawRectangleLines (int (Btn_Prev_X), int (Y), 36, int (Box_H), Bord_Col);
      Standard.Raylib.DrawTextEx
        (Font, "<", (x => C_float (Btn_Prev_X + 12), y => C_float (Y + 6)),
         C_float (Font_Size), 1.0, (if Hov_Prev then Gold_Col else Text_Col));

      Standard.Raylib.DrawTextEx
        (Font, Value_Text, (x => C_float (Box_X + 46), y => C_float (Y + 6)),
         C_float (Font_Size), 1.0, Gold_Col);

      Standard.Raylib.DrawRectangle
        (int (Btn_Next_X), int (Y), 36, int (Box_H),
         (if Hov_Next then (r => 38, g => 50, b => 65, a => 255) else Box_Bg));
      Standard.Raylib.DrawRectangleLines (int (Btn_Next_X), int (Y), 36, int (Box_H), Bord_Col);
      Standard.Raylib.DrawTextEx
        (Font, ">", (x => C_float (Btn_Next_X + 12), y => C_float (Y + 6)),
         C_float (Font_Size), 1.0, (if Hov_Next then Gold_Col else Text_Col));
   end Draw_Cycle_Selector;

   procedure Draw_Radio_3
     (X, Y, W       : Integer;
      Opt1, Opt2, Opt3 : String;
      Selected      : in out Positive;
      Font          : Standard.Raylib.Font;
      Font_Size     : Float;
      Changed       : out Boolean)
   is
      Mouse_X   : constant Integer := Integer (Standard.Raylib.GetMouseX);
      Mouse_Y   : constant Integer := Integer (Standard.Raylib.GetMouseY);
      LMB_Press : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Btn_W     : constant Integer := (W - 20) / 3;
      Btn_H     : constant Integer := 32;
   begin
      Changed := False;

      for I in 1 .. 3 loop
         declare
            BX       : constant Integer := X + ((I - 1) * (Btn_W + 10));
            BY       : constant Integer := Y;
            Is_Hov   : constant Boolean :=
              (Mouse_X >= BX and then Mouse_X <= BX + Btn_W and then
               Mouse_Y >= BY and then Mouse_Y <= BY + Btn_H);
            Is_Sel   : constant Boolean := (Selected = I);
            Lbl      : constant String := (if I = 1 then Opt1 elsif I = 2 then Opt2 else Opt3);

            Bg_Col   : constant Standard.Raylib.Color :=
              (if Is_Sel then (r => 38, g => 50, b => 65, a => 255)
               elsif Is_Hov then (r => 26, g => 34, b => 45, a => 255)
               else (r => 14, g => 17, b => 20, a => 255));
            Bord_Col : constant Standard.Raylib.Color :=
              (if Is_Sel then (r => 255, g => 203, b => 0, a => 255) else (r => 60, g => 75, b => 95, a => 255));
            Txt_Col  : constant Standard.Raylib.Color :=
              (if Is_Sel then (r => 255, g => 203, b => 0, a => 255) else (r => 245, g => 245, b => 245, a => 255));
            Pref     : constant String := (if Is_Sel then "* " else "  ");
         begin
            if Is_Hov and then LMB_Press and then not Is_Sel then
               Selected := I;
               Changed := True;
            end if;

            Standard.Raylib.DrawRectangle (int (BX), int (BY), int (Btn_W), int (Btn_H), Bg_Col);
            Standard.Raylib.DrawRectangleLines (int (BX), int (BY), int (Btn_W), int (Btn_H), Bord_Col);
            Standard.Raylib.DrawTextEx
              (Font, Pref & Lbl, (x => C_float (BX + 10), y => C_float (BY + 7)),
               C_float (Font_Size), 1.0, Txt_Col);
         end;
      end loop;
   end Draw_Radio_3;

   procedure Draw_Radio_4
     (X, Y, W       : Integer;
      Opt1, Opt2, Opt3, Opt4 : String;
      Selected      : in out Positive;
      Font          : Standard.Raylib.Font;
      Font_Size     : Float;
      Changed       : out Boolean)
   is
      Mouse_X   : constant Integer := Integer (Standard.Raylib.GetMouseX);
      Mouse_Y   : constant Integer := Integer (Standard.Raylib.GetMouseY);
      LMB_Press : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Btn_W     : constant Integer := (W - 30) / 4;
      Btn_H     : constant Integer := 32;
   begin
      Changed := False;

      for I in 1 .. 4 loop
         declare
            BX       : constant Integer := X + ((I - 1) * (Btn_W + 10));
            BY       : constant Integer := Y;
            Is_Hov   : constant Boolean :=
              (Mouse_X >= BX and then Mouse_X <= BX + Btn_W and then
               Mouse_Y >= BY and then Mouse_Y <= BY + Btn_H);
            Is_Sel   : constant Boolean := (Selected = I);
            Lbl      : constant String :=
              (if I = 1 then Opt1 elsif I = 2 then Opt2 elsif I = 3 then Opt3 else Opt4);

            Bg_Col   : constant Standard.Raylib.Color :=
              (if Is_Sel then (r => 38, g => 50, b => 65, a => 255)
               elsif Is_Hov then (r => 26, g => 34, b => 45, a => 255)
               else (r => 14, g => 17, b => 20, a => 255));
            Bord_Col : constant Standard.Raylib.Color :=
              (if Is_Sel then (r => 255, g => 203, b => 0, a => 255) else (r => 60, g => 75, b => 95, a => 255));
            Txt_Col  : constant Standard.Raylib.Color :=
              (if Is_Sel then (r => 255, g => 203, b => 0, a => 255) else (r => 245, g => 245, b => 245, a => 255));
            Pref     : constant String := (if Is_Sel then "* " else "  ");
         begin
            if Is_Hov and then LMB_Press and then not Is_Sel then
               Selected := I;
               Changed := True;
            end if;

            Standard.Raylib.DrawRectangle (int (BX), int (BY), int (Btn_W), int (Btn_H), Bg_Col);
            Standard.Raylib.DrawRectangleLines (int (BX), int (BY), int (Btn_W), int (Btn_H), Bord_Col);
            Standard.Raylib.DrawTextEx
              (Font, Pref & Lbl, (x => C_float (BX + 8), y => C_float (BY + 7)),
               C_float (Font_Size), 1.0, Txt_Col);
         end;
      end loop;
   end Draw_Radio_4;

end Gabyx.Drivers.Raylib.Widgets;
