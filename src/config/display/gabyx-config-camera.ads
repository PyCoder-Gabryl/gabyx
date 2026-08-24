--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Specyfikacja modułu konfiguracji kamery i siatki kafelków.
--                   Zarządza 5 poziomami zoomu, parametrami martwej strefy oraz
--                   dynamiczną paletą kolorów siatki ładowaną z pliku camera.toml.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/display/gabyx-config-camera.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Types;

package Gabyx.Config.Camera is

   use Gabyx.Types;

   Default_Config_Path : constant String := "data/config/camera.toml";

   type Color_Palette_Array is array (1 .. 8) of RGBA_Color;

   type Camera_Configuration is record
      Default_Tile_Size  : Positive            := 64;
      Active_Zoom_Index  : Positive            := 4;
      Grid_Visible       : Boolean             := True;
      Active_Color_Index : Positive            := 1;
      Color_Count        : Positive            := 5;
      Palette            : Color_Palette_Array :=
        [1 => (R => 46,  G => 204, B => 113, A => 140),
         2 => (R => 243, G => 156, B => 18,  A => 150),
         3 => (R => 0,   G => 210, B => 211, A => 140),
         4 => (R => 255, G => 107, B => 129, A => 140),
         5 => (R => 223, G => 230, B => 233, A => 90),
         others => (R => 46, G => 204, B => 113, A => 140)];
      Deadzone_Tiles     : Positive            := 4;
      Lerp_Duration_Ms   : Positive            := 120;
   end record;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Camera_Configuration;

   function Get_Default_Configuration return Camera_Configuration;

end Gabyx.Config.Camera;
