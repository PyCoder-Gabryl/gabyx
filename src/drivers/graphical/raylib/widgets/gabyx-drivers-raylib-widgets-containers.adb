--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja atomowego widżetu kontenerów dla Raylib.
--                    Rysuje tło panelu, linie obramowania oraz pasek tytułowy
--                    w oparciu o centralne stałe motywu graficznego.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets-containers.adb
--  CREATED:         2026-08-29
--  ============================================================================


with Interfaces.C;
with Gabyx.Types;
with Gabyx.UI.Theme;

package body Gabyx.Drivers.Raylib.Widgets.Containers is

   use Interfaces.C;

   --  ============================================================================
   --  POMOCNICZE FUNKCJE WEWNĘTRZNE
   --  ============================================================================

   function To_Raylib_Color (C : Gabyx.Types.RGBA_Color) return Standard.Raylib.Color is
     ((r => unsigned_char (C.R),
       g => unsigned_char (C.G),
       b => unsigned_char (C.B),
       a => unsigned_char (C.A)));

   --  ============================================================================
   --  PUBLICZNY INTERFEJS
   --  ============================================================================

   procedure Draw_Section_Box
     (X, Y, W, H : Integer;
      Title      : String;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float)
   is
      Box_Bg     : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_App_Dark);
      Border_Col : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Border);
      Header_Bg  : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Header_Dark);
      Gold_Col   : constant Standard.Raylib.Color := To_Raylib_Color (Gabyx.UI.Theme.Color_Gold);
   begin
      Standard.Raylib.DrawRectangle (int (X), int (Y), int (W), int (H), Box_Bg);
      Standard.Raylib.DrawRectangleLines (int (X), int (Y), int (W), int (H), Border_Col);

      Standard.Raylib.DrawRectangle (int (X), int (Y), int (W), 28, Header_Bg);
      Standard.Raylib.DrawLine
        (int (X), int (Y + 28), int (X + W), int (Y + 28), Border_Col);

      Standard.Raylib.DrawTextEx
        (Font, Title, (x => C_float (X + 12), y => C_float (Y + 6)),
         C_float (Font_Size), 1.0, Gold_Col);
   end Draw_Section_Box;

end Gabyx.Drivers.Raylib.Widgets.Containers;
