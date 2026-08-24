--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja rysowania siatki i marginesów centrujących Raylib.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/renderer/gabyx-drivers-raylib-renderer-grid.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Interfaces.C;
with Raylib;

package body Gabyx.Drivers.Raylib.Renderer.Grid is

   use Interfaces.C;

   procedure Draw
     (Layout       : Gabyx.UI.Types.Layout_Cache;
      Grid_Info    : Gabyx.UI.Grid.Grid_Metrics;
      Grid_Visible : Boolean;
      Grid_Color   : Gabyx.Types.RGBA_Color;
      HUD_Cfg      : Gabyx.Config.HUD.HUD_Configuration;
      Vp_X         : Integer;
      Vp_Y         : Integer)
   is
      Color_Vp_Margin : constant Standard.Raylib.Color :=
        (r => unsigned_char (HUD_Cfg.Color_Viewport.R),
         g => unsigned_char (HUD_Cfg.Color_Viewport.G),
         b => unsigned_char (HUD_Cfg.Color_Viewport.B),
         a => unsigned_char (HUD_Cfg.Color_Viewport.A));

      Color_Black_Under_Grid : constant Standard.Raylib.Color := (r => 0, g => 0, b => 0, a => 255);
      Color_Grid_Line        : constant Standard.Raylib.Color :=
        (r => unsigned_char (Grid_Color.R),
         g => unsigned_char (Grid_Color.G),
         b => unsigned_char (Grid_Color.B),
         a => unsigned_char (Grid_Color.A));

      Grid_Origin_X : constant int := int (Vp_X + Grid_Info.Margin_X);
      Grid_Origin_Y : constant int := int (Vp_Y + Layout.Viewport_Rect.Y + Grid_Info.Margin_Y);
      Grid_W        : constant int := int (Grid_Info.Grid_Width);
      Grid_H        : constant int := int (Grid_Info.Grid_Height);
      Tile_Px       : constant int := int (Grid_Info.Tile_Size);
   begin
      --  1. Marginesy Viewportu (Bordowe)
      Standard.Raylib.DrawRectangle
        (int (Vp_X) + int (Layout.Viewport_Rect.X),
         int (Vp_Y) + int (Layout.Viewport_Rect.Y),
         int (Layout.Viewport_Rect.Width),
         int (Layout.Viewport_Rect.Height),
         Color_Vp_Margin);

      --  2. Czarny podkład pod pełne pola
      Standard.Raylib.DrawRectangle
        (Grid_Origin_X, Grid_Origin_Y, Grid_W, Grid_H, Color_Black_Under_Grid);

      --  3. Linie siatki
      if Grid_Visible then
         for Col in 0 .. Grid_Info.Columns loop
            declare
               Line_X : constant int := Grid_Origin_X + (int (Col) * Tile_Px);
            begin
               Standard.Raylib.DrawLine (Line_X, Grid_Origin_Y, Line_X, Grid_Origin_Y + Grid_H, Color_Grid_Line);
            end;
         end loop;

         for Row in 0 .. Grid_Info.Rows loop
            declare
               Line_Y : constant int := Grid_Origin_Y + (int (Row) * Tile_Px);
            begin
               Standard.Raylib.DrawLine (Grid_Origin_X, Line_Y, Grid_Origin_X + Grid_W, Line_Y, Color_Grid_Line);
            end;
         end loop;
      end if;
   end Draw;

end Gabyx.Drivers.Raylib.Renderer.Grid;
