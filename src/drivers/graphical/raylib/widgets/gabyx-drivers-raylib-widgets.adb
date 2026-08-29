--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Ciało fasady widżetów GUI Raylib.
--                    Pakiet operuje wyłącznie na mechanizmie renames
--                    w sekcji publicznej specyfikacji.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets.adb
--  CREATED:         2026-08-25
--  ============================================================================


with Gabyx.Drivers.Raylib.Widgets.Containers;                            -- [NOWE]
with Gabyx.Drivers.Raylib.Widgets.Buttons;                               -- [NOWE]
with Gabyx.Drivers.Raylib.Widgets.Sliders;                               -- [NOWE]
with Gabyx.Drivers.Raylib.Widgets.Selectors;                             -- [NOWE]

package body Gabyx.Drivers.Raylib.Widgets is

   --  ============================================================================
   --  DELEGACJA DO ATOMOWYCH MODUŁÓW WIDŻETÓW
   --  ============================================================================

   procedure Draw_Section_Box
     (X, Y, W, H : Integer;
      Title      : String;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float)
   is
   begin
      Containers.Draw_Section_Box (X, Y, W, H, Title, Font, Font_Size);  -- [ZMIENIONE]
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
   begin
      Sliders.Draw_Slider                                                -- [ZMIENIONE]
        (X, Y, W, Label, Value, Min_Val, Max_Val, Font, Font_Size, Changed);
   end Draw_Slider;

   procedure Draw_Checkbox
     (X, Y       : Integer;
      Label      : String;
      Checked    : in out Boolean;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean)
   is
   begin
      Selectors.Draw_Checkbox (X, Y, Label, Checked, Font, Font_Size, Changed); -- [ZMIENIONE]
   end Draw_Checkbox;

   procedure Draw_Button
     (X, Y, W, H : Integer;
      Label      : String;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Clicked    : out Boolean)
   is
   begin
      Buttons.Draw_Button (X, Y, W, H, Label, Font, Font_Size, Clicked); -- [ZMIENIONE]
   end Draw_Button;

   procedure Draw_Toggle_Switch
     (X, Y       : Integer;
      Label      : String;
      State      : in out Boolean;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean)
   is
   begin
      Buttons.Draw_Toggle_Switch (X, Y, Label, State, Font, Font_Size, Changed); -- [ZMIENIONE]
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
   begin
      Selectors.Draw_Cycle_Selector                                      -- [ZMIENIONE]
        (X, Y, W, Label, Value_Text, Font, Font_Size, Prev_Clicked, Next_Clicked);
   end Draw_Cycle_Selector;

   procedure Draw_Radio_3
     (X, Y, W          : Integer;
      Opt1, Opt2, Opt3 : String;
      Selected         : in out Positive;
      Font             : Standard.Raylib.Font;
      Font_Size        : Float;
      Changed          : out Boolean)
   is
   begin
      Selectors.Draw_Radio_3                                             -- [ZMIENIONE]
        (X, Y, W, Opt1, Opt2, Opt3, Selected, Font, Font_Size, Changed);
   end Draw_Radio_3;

   procedure Draw_Radio_4
     (X, Y, W                : Integer;
      Opt1, Opt2, Opt3, Opt4 : String;
      Selected               : in out Positive;
      Font                   : Standard.Raylib.Font;
      Font_Size              : Float;
      Changed                : out Boolean)
   is
   begin
      Selectors.Draw_Radio_4                                             -- [ZMIENIONE]
        (X, Y, W, Opt1, Opt2, Opt3, Opt4, Selected, Font, Font_Size, Changed);
   end Draw_Radio_4;

end Gabyx.Drivers.Raylib.Widgets;
