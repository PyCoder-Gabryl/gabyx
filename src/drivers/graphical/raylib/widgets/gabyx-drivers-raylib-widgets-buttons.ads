--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja atomowych kontrolek przycisków i przełączników.
--                    Zarządza interakcją myszy (Hover, Click), renderowaniem
--                    przycisków akcji oraz dwustanowych przełączników kapsułkowych.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets-buttons.ads
--  CREATED:         2026-08-29
--  ============================================================================


with Raylib;

package Gabyx.Drivers.Raylib.Widgets.Buttons is

   --  ============================================================================
   --  PUBLICZNY INTERFEJS PRZYCISKÓW I PRZEŁĄCZNIKÓW
   --  ============================================================================

   --  Rysuje standardowy przycisk akcji z podświetleniem po najechaniu kursorem
   procedure Draw_Button
     (X, Y, W, H : Integer;
      Label      : String;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Clicked    : out Boolean);

   --  Rysuje nowoczesny przełącznik kapsułkowy (Toggle Switch) ON / OFF
   procedure Draw_Toggle_Switch
     (X, Y       : Integer;
      Label      : String;
      State      : in out Boolean;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean);

end Gabyx.Drivers.Raylib.Widgets.Buttons;
