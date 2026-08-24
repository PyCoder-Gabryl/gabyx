--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Uniwersalny moduł renderowania półprzezroczystej kurtyny (Scrim).
--                   Wykorzystywany przez okna modalne, Ustawienia i dialogi pauzy.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/renderer/gabyx-drivers-raylib-renderer-scrim.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Types;

package Gabyx.Drivers.Raylib.Renderer.Scrim is

   use Gabyx.Types;

   --  Rysuje pełnoekranową półprzezroczystą kurtynę przyciemniającą tło gry
   procedure Draw (Alpha : Color_Component := 190);

end Gabyx.Drivers.Raylib.Renderer.Scrim;
