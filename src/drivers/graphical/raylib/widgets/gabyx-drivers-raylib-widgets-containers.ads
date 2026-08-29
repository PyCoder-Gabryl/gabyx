--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja atomowego widżetu kontenerów dla Raylib.
--                    Udostępnia procedurę rysowania obramowanych sekcji opcji
--                    z wydzielonym paskiem nagłówkowym oraz zintegrowanym
--                    motywem kolorystycznym Gabyx.UI.Theme.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets-containers.ads
--  CREATED:         2026-08-29
--  ============================================================================


with Raylib;

package Gabyx.Drivers.Raylib.Widgets.Containers is

   --  ============================================================================
   --  PUBLICZNY INTERFEJS KONTENERÓW
   --  ============================================================================

   --  Rysuje obramowaną sekcję z ciemniejszym nagłówkiem i złotym tytułem
   procedure Draw_Section_Box
     (X, Y, W, H : Integer;
      Title      : String;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float);

end Gabyx.Drivers.Raylib.Widgets.Containers;
