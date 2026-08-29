--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja atomowych kontrolek wyboru dla Raylib.
--                    Zapewnia spójną obsługę kliknięć myszy, eliminuje powielanie
--                    kodu grup radiowych i integruje stałe Gabyx.UI.Theme.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets-selectors.adb
--  CREATED:         2026-08-29
--  ============================================================================


with Interfaces.C;
with Gabyx.Types;
with Gabyx.UI.Theme;

package body Gabyx.Drivers.Raylib.Widgets.Selectors is

   use Interfaces.C;

   --  ============================================================================
   --  POMOCNICZE FUNKCJE WEWNĘTRZNE
   --  ============================================================================

   function To_Raylib_Color (C : Gabyx.Types.RGBA_Color) return Standard.Raylib.Color is
     ((r => unsigned_char (C.R),
       g => unsigned_char (C.G),
       b => unsigned_char (C.B),
       a => unsigned_char (C.A)));

   --  Pojedynczy atomowy przycisk opcji w grupie radiowej (DRY)         -- [NOWE]
   procedure Draw_Radio_Item
     (BX, BY, Btn_W, Btn_H : Integer;
      Index                : Positive;
      Label                : String;
      Selected             : in out Positive;
      Font                 : Standard.Raylib.Font;
      Font_Size            : Float;
      Changed              : in out Boolean)
   is
      Mouse_X   : constant Integer := Integer (Standard.Raylib.GetMouseX);
      Mouse_Y   : constant Integer := Integer (Standard.Raylib.GetMouseY);
      LMB_Press : constant Boolean :=
        Boolean (Standard.Raylib.IsMouseButtonPressed (Standard.Raylib.MOUSE_BUTTON_LEFT));

      Is_Hov    : constant Boolean :=
        (Mouse_X >= BX and then Mouse_X <= BX + Btn_W and then
         Mouse_Y >= BY and then Mouse_Y <= BY + Btn_H);
      Is_Sel    : constant Boolean := (Selected = Index);

      Gold_Col  : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Gold);
      Bord_Def  : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Border);
      Txt_Def   : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Text_White);
      Bg_Def    : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Pane_Right);

      Bg_Col    : constant Standard.Raylib.Color :=
        (if Is_Sel then (r => 38, g => 50, b => 65, a => 255)
         elsif Is_Hov then To_Raylib_Color (Gabyx.UI.Theme.Color_Header_Dark)
         else Bg_Def);
      Bord_Col  : constant Standard.Raylib.Color := (if Is_Sel then Gold_Col else Bord_Def);
      Txt_Col   : constant Standard.Raylib.Color := (if Is_Sel then Gold_Col else Txt_Def);
      Pref      : constant String := (if Is_Sel then "* " else "  ");
   begin
      if Is_Hov and then LMB_Press and then not Is_Sel then
         Selected := Index;
         Changed  := True;
      end if;

      Standard.Raylib.DrawRectangle (int (BX), int (BY), int (Btn_W), int (Btn_H), Bg_Col);
      Standard.Raylib.DrawRectangleLines (int (BX), int (BY), int (Btn_W), int (Btn_H), Bord_Col);
      Standard.Raylib.DrawTextEx
        (Font, Pref & Label, (x => C_float (BX + 8), y => C_float (BY + 7)),
         C_float (Font_Size), 1.0, Txt_Col);
   end Draw_Radio_Item;

   --  ============================================================================
   --  PUBLICZNY INTERFEJS
   --  ============================================================================

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

      Box_Bg    : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Pane_Right);
      Gold_Col  : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Gold);
      Bord_Col  : constant Standard.Raylib.Color :=
        (if Is_Hover then Gold_Col else To_Raylib_Color (Gabyx.UI.Theme.Color_Border));
      Text_Col  : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Text_White);
   begin
      Changed := False;

      if Is_Hover and then LMB_Press then
         Checked := not Checked;
         Changed := True;
      end if;

      Standard.Raylib.DrawRectangle (int (X), int (Y), int (Box_Size), int (Box_Size), Box_Bg);
      Standard.Raylib.DrawRectangleLines (int (X), int (Y), int (Box_Size), int (Box_Size), Bord_Col);

      if Checked then
         Standard.Raylib.DrawRectangle
           (int (X + 4), int (Y + 4), int (Box_Size - 8), int (Box_Size - 8), Gold_Col);
      end if;

      Standard.Raylib.DrawTextEx
        (Font, Label, (x => C_float (X + 32), y => C_float (Y + 2)),
         C_float (Font_Size), 1.0, (if Is_Hover then Gold_Col else Text_Col));
   end Draw_Checkbox;

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

      Box_Bg     : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Pane_Right);
      Bord_Col   : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Border);
      Gold_Col   : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Gold);
      Text_Col   : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Text_White);
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
     (X, Y, W          : Integer;
      Opt1, Opt2, Opt3 : String;
      Selected         : in out Positive;
      Font             : Standard.Raylib.Font;
      Font_Size        : Float;
      Changed          : out Boolean)
   is
      Btn_W   : constant Integer := (W - 20) / 3;                        -- [NOWE]
      Btn_H   : constant Integer := 32;                                  -- [NOWE]
      Spacing : constant Integer := 10;                                  -- [NOWE]
   begin
      Changed := False;                                                  -- [NOWE]
      Draw_Radio_Item                                                    -- [NOWE]
        (X + 0 * (Btn_W + Spacing), Y, Btn_W, Btn_H, 1, Opt1, Selected, Font, Font_Size, Changed);
      Draw_Radio_Item                                                    -- [NOWE]
        (X + 1 * (Btn_W + Spacing), Y, Btn_W, Btn_H, 2, Opt2, Selected, Font, Font_Size, Changed);
      Draw_Radio_Item                                                    -- [NOWE]
        (X + 2 * (Btn_W + Spacing), Y, Btn_W, Btn_H, 3, Opt3, Selected, Font, Font_Size, Changed);
   end Draw_Radio_3;

   procedure Draw_Radio_4
     (X, Y, W                : Integer;
      Opt1, Opt2, Opt3, Opt4 : String;
      Selected               : in out Positive;
      Font                   : Standard.Raylib.Font;
      Font_Size              : Float;
      Changed                : out Boolean)
   is
      Btn_W   : constant Integer := (W - 30) / 4;                        -- [NOWE]
      Btn_H   : constant Integer := 32;                                  -- [NOWE]
      Spacing : constant Integer := 10;                                  -- [NOWE]
   begin
      Changed := False;                                                  -- [NOWE]
      Draw_Radio_Item                                                    -- [NOWE]
        (X + 0 * (Btn_W + Spacing), Y, Btn_W, Btn_H, 1, Opt1, Selected, Font, Font_Size, Changed);
      Draw_Radio_Item                                                    -- [NOWE]
        (X + 1 * (Btn_W + Spacing), Y, Btn_W, Btn_H, 2, Opt2, Selected, Font, Font_Size, Changed);
      Draw_Radio_Item                                                    -- [NOWE]
        (X + 2 * (Btn_W + Spacing), Y, Btn_W, Btn_H, 3, Opt3, Selected, Font, Font_Size, Changed);
      Draw_Radio_Item                                                    -- [NOWE]
        (X + 3 * (Btn_W + Spacing), Y, Btn_W, Btn_H, 4, Opt4, Selected, Font, Font_Size, Changed);
   end Draw_Radio_4;

end Gabyx.Drivers.Raylib.Widgets.Selectors;
