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
with Gabyx.UI.Panels;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Window_Mgr;
with Raylib;

package body Gabyx.Drivers.Raylib.Renderer is

   use Interfaces.C;
   use Gabyx.Types;
   use Gabyx.UI.Types;

   procedure Render_Frame
     (Layout      : Gabyx.UI.Types.Layout_Cache;
      Top_View    : Gabyx.UI.Types.HUD_View_Type;
      Bottom_View : Gabyx.UI.Types.HUD_View_Type;
      HUD_Cfg     : Gabyx.Config.HUD.HUD_Configuration;
      Win_Cfg     : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg    : Gabyx.Config.Fonts.Font_Configuration)
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

      Color_Vp : constant Standard.Raylib.Color :=
        (r => unsigned_char (HUD_Cfg.Color_Viewport.R),
         g => unsigned_char (HUD_Cfg.Color_Viewport.G),
         b => unsigned_char (HUD_Cfg.Color_Viewport.B),
         a => unsigned_char (HUD_Cfg.Color_Viewport.A));

      Border_Color : constant Standard.Raylib.Color :=
        (r => unsigned_char (Win_Cfg.Border_Bars_Color.R),
         g => unsigned_char (Win_Cfg.Border_Bars_Color.G),
         b => unsigned_char (Win_Cfg.Border_Bars_Color.B),
         a => unsigned_char (Win_Cfg.Border_Bars_Color.A));

      Text_White : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Text_Gray  : constant Standard.Raylib.Color := (r => 180, g => 180, b => 180, a => 255);
      Text_Gold  : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0,   a => 255);
      Text_Cyan  : constant Standard.Raylib.Color := (r => 80,  g => 220, b => 240, a => 255);
   begin
      Standard.Raylib.BeginDrawing;

      if Gabyx.Drivers.Raylib.Window_Mgr.Get_Display_Mode = Borderless_Fullscreen then
         Standard.Raylib.ClearBackground (Border_Color);
      else
         Standard.Raylib.ClearBackground (Color_Vp);
      end if;

      --  A. GÓRNY PASEK (Top Toolbar)
      Standard.Raylib.DrawRectangle
        (Vp_X + int (Layout.Top_Bar_Rect.X),
         Vp_Y + int (Layout.Top_Bar_Rect.Y),
         int (Layout.Top_Bar_Rect.Width),
         int (Layout.Top_Bar_Rect.Height),
         Color_Top);

      --  B. VIEWPORT ŚWIATA (Środek - bordowy)
      Standard.Raylib.DrawRectangle
        (Vp_X + int (Layout.Viewport_Rect.X),
         Vp_Y + int (Layout.Viewport_Rect.Y),
         int (Layout.Viewport_Rect.Width),
         int (Layout.Viewport_Rect.Height),
         Color_Vp);

      --  C. DOLNY PASEK (Bottom Dashboard)
      Standard.Raylib.DrawRectangle
        (Vp_X + int (Layout.Bottom_Bar_Rect.X),
         Vp_Y + int (Layout.Bottom_Bar_Rect.Y),
         int (Layout.Bottom_Bar_Rect.Width),
         int (Layout.Bottom_Bar_Rect.Height),
         Color_Bottom);

      --  Kontur Viewportu
      Standard.Raylib.DrawRectangleLines (Vp_X, Vp_Y, Virtual_W, Virtual_H, Text_Gray);

      --  Tekst Górnego Paska
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
         (if Top_View = View_A then Text_White else Text_Cyan));

      --  Tekst Viewportu
      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "OBSZAR VIEWPORTU SWIATA (BORDOWE TLO TESTOWE)" & Ada.Characters.Latin_1.LF &
         "Wymiary bufora lochu: " & Layout.Viewport_Rect.Width'Image & " x " &
         Layout.Viewport_Rect.Height'Image & " px" & Ada.Characters.Latin_1.LF &
         "Gotowy na przyjecie siatki kafelkow i gracza @ w kolejnym kroku.",
         (x => C_float (Vp_X + 40), y => C_float (Vp_Y + int (Layout.Viewport_Rect.Y) + 40)),
         C_float (Font_Cfg.Size_Regular),
         1.0,
         Text_White);

      --  Tekst Dolnego Paska
      Standard.Raylib.DrawTextEx
        (Cur_Font,
         Gabyx.UI.Panels.Get_Bottom_Bar_Text (View => Bottom_View, Is_Ultra_Wide => Layout.Is_Ultra_Wide),
         (x => C_float (Vp_X + 20), y => C_float (Vp_Y + int (Layout.Bottom_Bar_Rect.Y) + 12)),
         C_float (Font_Cfg.Size_Small),
         1.0,
         (if Bottom_View = View_A then Text_Gold else Text_White));

      Standard.Raylib.EndDrawing;
   end Render_Frame;

end Gabyx.Drivers.Raylib.Renderer;
