--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Centralny moduł semantycznych stałych motywu UI w czystym SPARK.
--                   Udostępnia zunifikowane definicje kolorów dla wszystkich widoków.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/types/gabyx-ui-theme.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Types;

package Gabyx.UI.Theme with
   SPARK_Mode => On,
   Pure
is

   use Gabyx.Types;

   --  Centralne stałe semantyczne motywu graficznego (Pure SPARK)
   Color_App_Dark    : constant RGBA_Color := (R => 18,  G => 22,  B => 26,  A => 255);
   Color_Header_Dark : constant RGBA_Color := (R => 26,  G => 34,  B => 45,  A => 255);
   Color_Pane_Left   : constant RGBA_Color := (R => 22,  G => 27,  B => 34,  A => 255);
   Color_Pane_Right  : constant RGBA_Color := (R => 14,  G => 17,  B => 20,  A => 255);

   Color_Gold        : constant RGBA_Color := (R => 255, G => 203, B => 0,   A => 255);
   Color_Cyan        : constant RGBA_Color := (R => 80,  G => 220, B => 240, A => 255);
   Color_Crimson     : constant RGBA_Color := (R => 90,  G => 20,  B => 35,  A => 255);
   Color_Border      : constant RGBA_Color := (R => 60,  G => 75,  B => 95,  A => 255);

   Color_Text_White  : constant RGBA_Color := (R => 245, G => 245, B => 245, A => 255);
   Color_Text_Gray   : constant RGBA_Color := (R => 170, G => 170, B => 170, A => 255);
   Color_Text_Muted  : constant RGBA_Color := (R => 120, G => 120, B => 120, A => 255);

end Gabyx.UI.Theme;
