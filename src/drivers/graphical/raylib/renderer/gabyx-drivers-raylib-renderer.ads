--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł renderowania grafiki, kontenerów HUD oraz Viewportu świata.
--                   Wyznacza środek wirtualnego bufora, rysuje pasy obramowania
--                   oraz wyrysowuje poszczególne panele na podstawie Layout_Cache.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/renderer/gabyx-drivers-raylib-renderer.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Types;
with Gabyx.UI.Types;
with Gabyx.UI.Grid;
with Gabyx.Config.Window;
with Gabyx.Config.Fonts;
with Gabyx.Config.HUD;

package Gabyx.Drivers.Raylib.Renderer is

   procedure Render_Frame
     (Layout       : Gabyx.UI.Types.Layout_Cache;
      Grid_Info    : Gabyx.UI.Grid.Grid_Metrics;
      Grid_Visible : Boolean;
      Grid_Color   : Gabyx.Types.RGBA_Color;
      Top_View     : Gabyx.UI.Types.HUD_View_Type;
      Bottom_View  : Gabyx.UI.Types.HUD_View_Type;
      HUD_Cfg      : Gabyx.Config.HUD.HUD_Configuration;
      Win_Cfg      : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg     : Gabyx.Config.Fonts.Font_Configuration);

end Gabyx.Drivers.Raylib.Renderer;
