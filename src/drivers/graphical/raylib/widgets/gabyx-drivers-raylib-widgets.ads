--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Uniwersalny zestaw reużywalnych kontrolek GUI dla sterownika Raylib.
--                   Zawiera ramki sekcji, płynne suwaki liczbowe (0..100%), checkboxy
--                   oraz przyciski z pełną obsługą najechania myszą (hover) i kliknięć.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets.ads
--  CREATED:         2026-08-25
--  ============================================================================


with Raylib;

package Gabyx.Drivers.Raylib.Widgets is

   --  Rysuje ramkę grupującą sekcję opcji z tytułem
   procedure Draw_Section_Box
     (X, Y, W, H : Integer;
      Title      : String;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float);

   --  Rysuje suwak wartości liczbowej (0..100%) z obsługą przeciągania myszą
   procedure Draw_Slider
     (X, Y, W    : Integer;
      Label      : String;
      Value      : in out Natural;
      Min_Val    : Natural;
      Max_Val    : Natural;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean);

   --  Rysuje przełącznik logiczny Checkbox [X]
   procedure Draw_Checkbox
     (X, Y       : Integer;
      Label      : String;
      Checked    : in out Boolean;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean);

   --  Rysuje przycisk akcji z efektem podświetlenia
   procedure Draw_Button
     (X, Y, W, H : Integer;
      Label      : String;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Clicked    : out Boolean);

end Gabyx.Drivers.Raylib.Widgets;
