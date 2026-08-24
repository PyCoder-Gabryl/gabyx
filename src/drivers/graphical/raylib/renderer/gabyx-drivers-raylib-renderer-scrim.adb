--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja rysowania kurtyny Scrim w bibliotece Raylib.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/renderer/gabyx-drivers-raylib-renderer-scrim.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Interfaces.C;
with Raylib;

package body Gabyx.Drivers.Raylib.Renderer.Scrim is

   use Interfaces.C;

   procedure Draw (Alpha : Color_Component := 190) is
      Screen_W    : constant int := Standard.Raylib.GetScreenWidth;
      Screen_H    : constant int := Standard.Raylib.GetScreenHeight;
      Scrim_Color : constant Standard.Raylib.Color := (r => 0, g => 0, b => 0, a => unsigned_char (Alpha));
   begin
      Standard.Raylib.DrawRectangle (0, 0, Screen_W, Screen_H, Scrim_Color);
   end Draw;

end Gabyx.Drivers.Raylib.Renderer.Scrim;
