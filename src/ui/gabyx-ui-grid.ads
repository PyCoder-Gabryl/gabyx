--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Formalny moduł kalkulacji siatki kafelkowej lochu w SPARK.
--                   Oblicza liczbę pełnych kolumn i wierszy mieszczących się w
--                   Viewportcie, symetryczny margines centrowania (Auto-Padding)
--                   oraz wymiary czarnego prostokąta podkładowego pod loch.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/gabyx-ui-grid.ads
--  CREATED:         2026-08-23
--  ============================================================================


package Gabyx.UI.Grid with
   SPARK_Mode => On,
   Pure
is

   --  Struktura metryk wyliczonej siatki
   type Grid_Metrics is record
      Columns      : Positive := 1;
      Rows         : Positive := 1;
      Tile_Size    : Positive := 64;
      Total_Tiles  : Positive := 1;
      Grid_Width   : Positive := 64;
      Grid_Height  : Positive := 64;
      Margin_X     : Natural  := 0;
      Margin_Y     : Natural  := 0;
   end record;

   --  Wylicza parametry siatki z gwarancją zachowania wyłącznie pełnych pól
   function Calculate_Grid
     (Viewport_Width  : Positive;
      Viewport_Height : Positive;
      Tile_Size       : Positive) return Grid_Metrics;

end Gabyx.UI.Grid;
