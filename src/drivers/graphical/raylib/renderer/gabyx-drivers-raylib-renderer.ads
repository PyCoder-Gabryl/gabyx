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


with Gabyx.Config.HUD;
with Gabyx.Config.Camera;
with Gabyx.Config.Window;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Renderer is

   procedure Initialize
     (HUD_Config    : Gabyx.Config.HUD.HUD_Configuration;
      Camera_Config : Gabyx.Config.Camera.Camera_Configuration);

   procedure Process_Game_Frame
     (Win_Cfg  : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration);

   procedure Refresh_Layout;

end Gabyx.Drivers.Raylib.Renderer;
