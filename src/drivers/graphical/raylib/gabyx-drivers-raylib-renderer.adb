--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja renderera Raylib. Rysuje wycentrowane prostokąty
--                   oraz pobiera sformatowany tekst z modułu Gabyx.UI.Panels.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib-renderer.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Interfaces.C;
with Ada.Characters.Latin_1;
with Gabyx.Types;
with Gabyx.UI.Types;
with Gabyx.UI.Grid;
with Gabyx.UI.Panels;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Window_Mgr;
with Raylib;

package body Gabyx.Drivers.Raylib.Renderer is

   use Interfaces.C;
   use Gabyx.Types;
   use Gabyx.UI.Types;

   procedure Render_Frame
     (Layout       : Gabyx.UI.Types.Layout_Cache;
      Grid_Info    : Gabyx.UI.Grid.Grid_Metrics;
      Grid_Visible : Boolean;
      Grid_Color   : Gabyx.Types.RGBA_Color;
      Top_View     : Gabyx.UI.Types.HUD_View_Type;
      Bottom_View  : Gabyx.UI.Types.HUD_View_Type;
      HUD_Cfg      : Gabyx.Config.HUD.HUD_Configuration;
      Win_Cfg      : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg     : Gabyx.Config.Fonts.Font_Configuration)
   is
      Screen_W  : constant int := Standard.Raylib.GetScreenWidth;
      Screen_H  : constant int := Standard.Raylib.GetScreenHeight;
      Virtual_W : constant int := int (Gabyx.Drivers.Raylib.Window_Mgr.Get_Virtual_Width);
      Virtual_H : constant int := int (Gabyx.Drivers.Raylib.Window_Mgr.Get_Virtual_Height);

      Vp_X : constant int := (Screen_W - Virtual_W) / 2;
      Vp_Y : constant int := (Screen_H - Virtual_H) / 2;

      Cur_Font  : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Font_Name : constant String := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font_Name;

      Color_Top : constant Standard.Raylib.Color :=
        (if Top_View = View_A then
           (r => unsigned_char (HUD_Cfg.Color_Top_View_A.R),
            g => unsigned_char (HUD_Cfg.Color_Top_View_A.G),
            b => unsigned_char (HUD_Cfg.Color_Top_View_A.B),
            a => unsigned_char (HUD_Cfg.Color_Top_View_A.A))
         else
           (r => unsigned_char (HUD_Cfg.Color_Top_View_B.R),
            g => unsigned_char (HUD_Cfg.Color_Top_View_B.G),
            b => unsigned_char (HUD_Cfg.Color_Top_View_B.B),
            a => unsigned_char (HUD_Cfg.Color_Top_View_B.A)));

      Color_Bottom : constant Standard.Raylib.Color :=
        (if Bottom_View = View_A then
           (r => unsigned_char (HUD_Cfg.Color_Bottom_View_A.R),
            g => unsigned_char (HUD_Cfg.Color_Bottom_View_A.G),
            b => unsigned_char (HUD_Cfg.Color_Bottom_View_A.B),
            a => unsigned_char (HUD_Cfg.Color_Bottom_View_A.A))
         else
           (r => unsigned_char (HUD_Cfg.Color_Bottom_View_B.R),
            g => unsigned_char (HUD_Cfg.Color_Bottom_View_B.G),
            b => unsigned_char (HUD_Cfg.Color_Bottom_View_B.B),
            a => unsigned_char (HUD_Cfg.Color_Bottom_View_B.A)));

      Color_Vp_Margin : constant Standard.Raylib.Color :=
        (r => unsigned_char (HUD_Cfg.Color_Viewport.R),
         g => unsigned_char (HUD_Cfg.Color_Viewport.G),
         b => unsigned_char (HUD_Cfg.Color_Viewport.B),
         a => unsigned_char (HUD_Cfg.Color_Viewport.A));

      Color_Grid_Line : constant Standard.Raylib.Color :=
        (r => unsigned_char (Grid_Color.R),
         g => unsigned_char (Grid_Color.G),
         b => unsigned_char (Grid_Color.B),
         a => unsigned_char (Grid_Color.A));

      Color_Black_Under_Grid : constant Standard.Raylib.Color := (r => 0, g => 0, b => 0, a => 255);

      Border_Color : constant Standard.Raylib.Color :=
        (r => unsigned_char (Win_Cfg.Border_Bars_Color.R),
         g => unsigned_char (Win_Cfg.Border_Bars_Color.G),
         b => unsigned_char (Win_Cfg.Border_Bars_Color.B),
         a => unsigned_char (Win_Cfg.Border_Bars_Color.A));

      Text_White : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Text_Gold  : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0,   a => 255);
      Text_Cyan  : constant Standard.Raylib.Color := (r => 80,  g => 220, b => 240, a => 255);
      Text_Gray  : constant Standard.Raylib.Color := (r => 180, g => 180, b => 180, a => 255);

      --  Współrzędne czarnego prostokąta siatki (z wycentrowaniem auto-paddingu)
      Grid_Origin_X : constant int := Vp_X + int (Grid_Info.Margin_X);
      Grid_Origin_Y : constant int := Vp_Y + int (Layout.Viewport_Rect.Y) + int (Grid_Info.Margin_Y);
      Grid_W        : constant int := int (Grid_Info.Grid_Width);
      Grid_H        : constant int := int (Grid_Info.Grid_Height);
      Tile_Px       : constant int := int (Grid_Info.Tile_Size);
   begin
      Standard.Raylib.BeginDrawing;

      if Gabyx.Drivers.Raylib.Window_Mgr.Get_Display_Mode = Borderless_Fullscreen then
         Standard.Raylib.ClearBackground (Border_Color);
      else
         Standard.Raylib.ClearBackground (Color_Vp_Margin);
      end if;

      --  1. GÓRNY PASEK HUD
      Standard.Raylib.DrawRectangle
        (Vp_X + int (Layout.Top_Bar_Rect.X),
         Vp_Y + int (Layout.Top_Bar_Rect.Y),
         int (Layout.Top_Bar_Rect.Width),
         int (Layout.Top_Bar_Rect.Height),
         Color_Top);

      --  2. VIEWPORT: Bordowe tło marginesów centrujących
      Standard.Raylib.DrawRectangle
        (Vp_X + int (Layout.Viewport_Rect.X),
         Vp_Y + int (Layout.Viewport_Rect.Y),
         int (Layout.Viewport_Rect.Width),
         int (Layout.Viewport_Rect.Height),
         Color_Vp_Margin);

      --  3. AKTYWNY OBSZAR SIATKI: Bezwzględnie czarny podkład pod pełne pola
      Standard.Raylib.DrawRectangle
        (Grid_Origin_X, Grid_Origin_Y, Grid_W, Grid_H, Color_Black_Under_Grid);

      --  4. RYSOWANIE LINII SIATKI (Gdy włączona)
      if Grid_Visible then
         --  Linie pionowe (kolumny)
         for Col in 0 .. Grid_Info.Columns loop
            declare
               Line_X : constant int := Grid_Origin_X + (int (Col) * Tile_Px);
            begin
               Standard.Raylib.DrawLine (Line_X, Grid_Origin_Y, Line_X, Grid_Origin_Y + Grid_H, Color_Grid_Line);
            end;
         end loop;

         --  Linie poziome (wiersze)
         for Row in 0 .. Grid_Info.Rows loop
            declare
               Line_Y : constant int := Grid_Origin_Y + (int (Row) * Tile_Px);
            begin
               Standard.Raylib.DrawLine (Grid_Origin_X, Line_Y, Grid_Origin_X + Grid_W, Line_Y, Color_Grid_Line);
            end;
         end loop;
      end if;

      --  5. DOLNY PASEK HUD
      Standard.Raylib.DrawRectangle
        (Vp_X + int (Layout.Bottom_Bar_Rect.X),
         Vp_Y + int (Layout.Bottom_Bar_Rect.Y),
         int (Layout.Bottom_Bar_Rect.Width),
         int (Layout.Bottom_Bar_Rect.Height),
         Color_Bottom);

      --  Kontury
      Standard.Raylib.DrawRectangleLines (Vp_X, Vp_Y, Virtual_W, Virtual_H, Text_Gray);

      --  TREŚĆ GÓRNEGO PASKA
      if Top_View = View_A then
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            Gabyx.UI.Panels.Get_Top_Bar_Text
              (View          => Top_View,
               Virtual_W     => Positive (Virtual_W),
               Virtual_H     => Positive (Virtual_H),
               Screen_W      => Positive (Screen_W),
               Screen_H      => Positive (Screen_H),
               Is_Ultra_Wide => Layout.Is_Ultra_Wide,
               Active_Tier   => Layout.Active_Tier,
               Font_Family   => Font_Name,
               FPS           => (if Win_Cfg.Target_FPS > 0 then Natural (Win_Cfg.Target_FPS) else 60)),
            (x => C_float (Vp_X + 20), y => C_float (Vp_Y + 8)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            Text_White);
      else
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            "SIATKA: " & Grid_Info.Columns'Image & "x" & Grid_Info.Rows'Image & " (" &
            Grid_Info.Total_Tiles'Image & " pol) | KAFELEK: " & Grid_Info.Tile_Size'Image &
            "px | MARGINESY: X=" & Grid_Info.Margin_X'Image & "px, Y=" & Grid_Info.Margin_Y'Image & "px",
            (x => C_float (Vp_X + 20), y => C_float (Vp_Y + 8)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            Text_Cyan);
      end if;

      --  TREŚĆ DOLNEGO PASKA
      if Bottom_View = View_A then
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            Gabyx.UI.Panels.Get_Bottom_Bar_Text (View => Bottom_View, Is_Ultra_Wide => Layout.Is_Ultra_Wide),
            (x => C_float (Vp_X + 20), y => C_float (Vp_Y + int (Layout.Bottom_Bar_Rect.Y) + 12)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            Text_Gold);
      else
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            "SKROTY SIATKI: [S] Zmien kolor siatki  [Option+S] Wlacz/Wylacz siatke" & Ada.Characters.Latin_1.LF &
            "[Option+5] 30px  [Option+6] 42px  [Option+7] 48px  [Option+8] 64px  [Option+9] 96px",
            (x => C_float (Vp_X + 20), y => C_float (Vp_Y + int (Layout.Bottom_Bar_Rect.Y) + 12)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            Text_White);
      end if;

      Standard.Raylib.EndDrawing;
   end Render_Frame;

end Gabyx.Drivers.Raylib.Renderer;
