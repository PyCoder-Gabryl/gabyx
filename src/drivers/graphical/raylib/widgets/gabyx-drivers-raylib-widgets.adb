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

      --  Pasek nagłówka sekcji
      Standard.Raylib.DrawRectangle (int (X), int (Y), int (W), 28, (r => 26, g => 34, b => 45, a => 255));
      Standard.Raylib.DrawLine (int (X), int (Y + 28), int (X + W), int (Y + 28), Border_Col);

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
      Mouse_X  : constant int := Standard.Raylib.GetMouseX;
      Mouse_Y  : constant int := Standard.Raylib.GetMouseY;
      LMB_Down : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonDown (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Bar_X    : constant int := int (X + 220);
      Bar_Y    : constant int := int (Y + 6);
      Bar_W    : constant int := int (W - 300);
      Bar_H    : constant int := 16;

      Is_Hover : constant Boolean :=
        (Mouse_X >= Bar_X - 5 and then Mouse_X <= Bar_X + Bar_W + 5 and then
         Mouse_Y >= Bar_Y - 5 and then Mouse_Y <= Bar_Y + Bar_H + 5);

      Span     : constant Float := Float (Max_Val - Min_Val);
      Rel_Val  : constant Float := (if Span > 0.0 then Float (Value - Min_Val) / Span else 0.0);
      Fill_W   : constant int := int (Rel_Val * Float (Bar_W));

      Text_Col : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Bar_Bg   : constant Standard.Raylib.Color := (r => 14,  g => 17,  b => 20,  a => 255);
      Fill_Col : constant Standard.Raylib.Color := (r => 80,  g => 220, b => 240, a => 255);
      Bord_Col : constant Standard.Raylib.Color := (r => 60,  g => 75,  b => 95,  a => 255);
   begin
      Changed := False;

      --  Obsługa przeciągania myszą
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

      --  Etykieta
      Standard.Raylib.DrawTextEx
        (Font, Label, (x => C_float (X), y => C_float (Y + 4)),
         C_float (Font_Size), 1.0, Text_Col);

      --  Pasek tła i wypełnienie
      Standard.Raylib.DrawRectangle (Bar_X, Bar_Y, Bar_W, Bar_H, Bar_Bg);
      Standard.Raylib.DrawRectangle (Bar_X, Bar_Y, Fill_W, Bar_H, Fill_Col);
      Standard.Raylib.DrawRectangleLines (Bar_X, Bar_Y, Bar_W, Bar_H, Bord_Col);

      --  Wartość procentowa po prawej
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
      Mouse_X   : constant int := Standard.Raylib.GetMouseX;
      Mouse_Y   : constant int := Standard.Raylib.GetMouseY;
      LMB_Press : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Box_Size  : constant Integer := 22;
      Is_Hover  : constant Boolean :=
        (Mouse_X >= int (X) and then Mouse_X <= int (X + 350) and then
         Mouse_Y >= int (Y) and then Mouse_Y <= int (Y + Box_Size));

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

      --  Kwadrat checkboxa
      Standard.Raylib.DrawRectangle (int (X), int (Y), int (Box_Size), int (Box_Size), Box_Bg);
      Standard.Raylib.DrawRectangleLines (int (X), int (Y), int (Box_Size), int (Box_Size), Bord_Col);

      if Checked then
         Standard.Raylib.DrawRectangle (int (X + 4), int (Y + 4), int (Box_Size - 8), int (Box_Size - 8), Gold_Col);
      end if;

      --  Tekst etykiety
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
      Mouse_X   : constant int := Standard.Raylib.GetMouseX;
      Mouse_Y   : constant int := Standard.Raylib.GetMouseY;
      LMB_Press : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Is_Hover  : constant Boolean :=
        (Mouse_X >= int (X) and then Mouse_X <= int (X + W) and then
         Mouse_Y >= int (Y) and then Mouse_Y <= int (Y + H));

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

end Gabyx.Drivers.Raylib.Widgets;
