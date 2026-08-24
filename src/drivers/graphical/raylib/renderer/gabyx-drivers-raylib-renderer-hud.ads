--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł renderowania pasów HUD (Górny Toolbar oraz Dolny Dashboard).
--                   Pobiera sformatowane teksty z Gabyx.UI.Panels i wyrysowuje tła oraz ramki.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/renderer/gabyx-drivers-raylib-renderer-hud.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.UI.Types;
with Gabyx.Config.HUD;
with Gabyx.Config.Fonts;
with Gabyx.Config.Window;
with Gabyx.UI.Grid;

package Gabyx.Drivers.Raylib.Renderer.HUD is

   procedure Draw
     (Layout    : Gabyx.UI.Types.Layout_Cache;
      Top_View  : Gabyx.UI.Types.HUD_View_Type;
      Bot_View  : Gabyx.UI.Types.HUD_View_Type;
      Grid_Info : Gabyx.UI.Grid.Grid_Metrics;
      HUD_Cfg   : Gabyx.Config.HUD.HUD_Configuration;
      Win_Cfg   : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg  : Gabyx.Config.Fonts.Font_Configuration;
      Vp_X      : Integer;
      Vp_Y      : Integer);

end Gabyx.Drivers.Raylib.Renderer.HUD;
