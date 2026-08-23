--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja algorytmu dopasowania siatki do Viewportu w SPARK.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/gabyx-ui-grid.adb
--  CREATED:         2026-08-23
--  ============================================================================


package body Gabyx.UI.Grid with
   SPARK_Mode => On
is

   function Calculate_Grid
     (Viewport_Width  : Positive;
      Viewport_Height : Positive;
      Tile_Size       : Positive) return Grid_Metrics
   is
      Metrics  : Grid_Metrics;
      Cols     : constant Positive := (if Viewport_Width >= Tile_Size then Viewport_Width / Tile_Size else 1);
      Rws      : constant Positive := (if Viewport_Height >= Tile_Size then Viewport_Height / Tile_Size else 1);
      G_Width  : constant Positive := Cols * Tile_Size;
      G_Height : constant Positive := Rws * Tile_Size;
   begin
      Metrics.Columns     := Cols;
      Metrics.Rows        := Rws;
      Metrics.Tile_Size   := Tile_Size;
      Metrics.Total_Tiles := Cols * Rws;
      Metrics.Grid_Width  := G_Width;
      Metrics.Grid_Height := G_Height;

      Metrics.Margin_X := (if Viewport_Width >= G_Width then (Viewport_Width - G_Width) / 2 else 0);
      Metrics.Margin_Y := (if Viewport_Height >= G_Height then (Viewport_Height - G_Height) / 2 else 0);

      return Metrics;
   end Calculate_Grid;

end Gabyx.UI.Grid;
