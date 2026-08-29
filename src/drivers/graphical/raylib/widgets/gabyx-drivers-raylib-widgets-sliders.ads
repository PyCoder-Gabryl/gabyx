--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja atomowej kontrolki suwaka liczbowego dla Raylib.
--                    Zarządza przeciąganiem kursora myszy z wciśniętym LPM,
--                    oblicza wartości względne (0..100%) i zabezpiecza zakresy.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets-sliders.ads
--  CREATED:         2026-08-29
--  ============================================================================


with Raylib;

package Gabyx.Drivers.Raylib.Widgets.Sliders is

   --  ============================================================================
   --  PUBLICZNY INTERFEJS SUWAKÓW
   --  ============================================================================

   --  Rysuje poziomy suwak liczbowy z etykietą i wartością procentową
   procedure Draw_Slider
     (X, Y, W    : Integer;
      Label      : String;
      Value      : in out Natural;
      Min_Val    : Natural;
      Max_Val    : Natural;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean);

end Gabyx.Drivers.Raylib.Widgets.Sliders;
