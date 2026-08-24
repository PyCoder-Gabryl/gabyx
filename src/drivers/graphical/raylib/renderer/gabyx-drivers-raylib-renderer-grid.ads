--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł renderowania czarnego podkładu lochu, marginesów i siatki.
--                   Wyznacza środek wirtualnego bufora i rysuje linie kafelków z przezroczystością.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/renderer/gabyx-drivers-raylib-renderer-grid.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Types;
with Gabyx.UI.Types;
with Gabyx.UI.Grid;
with Gabyx.Config.HUD;

package Gabyx.Drivers.Raylib.Renderer.Grid is

   procedure Draw
     (Layout       : Gabyx.UI.Types.Layout_Cache;
      Grid_Info    : Gabyx.UI.Grid.Grid_Metrics;
      Grid_Visible : Boolean;
      Grid_Color   : Gabyx.Types.RGBA_Color;
      HUD_Cfg      : Gabyx.Config.HUD.HUD_Configuration;
      Vp_X         : Integer;
      Vp_Y         : Integer);

end Gabyx.Drivers.Raylib.Renderer.Grid;
