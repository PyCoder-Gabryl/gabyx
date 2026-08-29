--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja atomowej kontrolki suwaka liczbowego dla Raylib.
--                    Kalkuluje pozycję paska postępu, obsługuje płynne przeciąganie
--                    myszą oraz dynamicznie odświeża wartość procentową.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets-sliders.adb
--  CREATED:         2026-08-29
--  ============================================================================


with Interfaces.C;
with Gabyx.Types;
with Gabyx.UI.Theme;

package body Gabyx.Drivers.Raylib.Widgets.Sliders is

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

      Text_Col : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Text_White);
      Bar_Bg   : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Pane_Right);
      Fill_Col : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Cyan);
      Bord_Col : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Border);
      Gold_Col : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Gold);
   begin
      Changed := False;

      if Is_Hover and then LMB_Down and then Bar_W > 0 then
         declare
            Clamped_X : constant Float :=
              Float'Max (0.0, Float'Min (Float (Bar_W), Float (Mouse_X - Bar_X)));
            New_Val   : constant Natural := Min_Val + Natural ((Clamped_X / Float (Bar_W)) * Span);
         begin
            if New_Val /= Value then
               Value   := New_Val;
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
         C_float (Font_Size), 1.0, (if Changed then Gold_Col else Text_Col));
   end Draw_Slider;

end Gabyx.Drivers.Raylib.Widgets.Sliders;
