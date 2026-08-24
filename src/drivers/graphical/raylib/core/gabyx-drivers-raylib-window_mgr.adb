--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja menedżera okna Raylib. Obsługuje tablicę 9 presetów
--                   oraz bezpiecznik sprawdzający wymiary robocze monitora głównego.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/core/gabyx-drivers-raylib-window_mgr.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Interfaces.C;
with Ada.Strings.Unbounded;
with Raylib;

package body Gabyx.Drivers.Raylib.Window_Mgr is

   use Interfaces.C;
   use type Standard.Raylib.ConfigFlags;

   type Preset_Dim is record
      Width  : int;
      Height : int;
   end record;

   Presets_Table : constant array (1 .. 9) of Preset_Dim :=
     [1 => (Width => 1280, Height => 720),
      2 => (Width => 1440, Height => 900),
      3 => (Width => 1600, Height => 900),
      4 => (Width => 1920, Height => 1080),
      5 => (Width => 1920, Height => 1200),
      6 => (Width => 2560, Height => 1080),
      7 => (Width => 2560, Height => 1440),
      8 => (Width => 3440, Height => 1440),
      9 => (Width => 3840, Height => 2160)];

   Current_Mode : Display_Mode_Type := Windowed;
   Virtual_W    : int := 1280;
   Virtual_H    : int := 720;
   Is_Frameless : Boolean := False;
   Mon_W        : int := 1920;
   Mon_H        : int := 1080;

   procedure Center_Window (Target_W, Target_H : Integer) is
      Pos_X : constant int := (Mon_W - int (Target_W)) / 2;
      Pos_Y : constant int := (Mon_H - int (Target_H)) / 2;
   begin
      Standard.Raylib.SetWindowPosition (Pos_X, Pos_Y);
   end Center_Window;

   procedure Initialize (Win_Cfg : Gabyx.Config.Window.Window_Configuration) is
      Title_Str : constant String := Ada.Strings.Unbounded.To_String (Win_Cfg.Title);
      FPS       : constant int := (if Win_Cfg.Target_FPS > 0 then int (Win_Cfg.Target_FPS) else 60);
      Cur_Mon   : int := 0;
   begin
      Current_Mode := Win_Cfg.Display_Mode;
      Virtual_W    := int (Win_Cfg.Width);
      Virtual_H    := int (Win_Cfg.Height);
      Is_Frameless := (Win_Cfg.Display_Mode /= Windowed);

      if Win_Cfg.High_DPI then
         Standard.Raylib.SetConfigFlags (Standard.Raylib.FLAG_WINDOW_HIGHDPI);
      end if;
      if Win_Cfg.VSync then
         Standard.Raylib.SetConfigFlags (Standard.Raylib.FLAG_VSYNC_HINT);
      end if;
      if Current_Mode = Borderless then
         Standard.Raylib.SetConfigFlags (Standard.Raylib.FLAG_WINDOW_UNDECORATED);
      elsif Current_Mode = Borderless_Fullscreen then
         Standard.Raylib.SetConfigFlags
           (Standard.Raylib.FLAG_WINDOW_UNDECORATED or Standard.Raylib.FLAG_WINDOW_TOPMOST);
      end if;

      Standard.Raylib.InitWindow (Virtual_W, Virtual_H, Title_Str);
      Standard.Raylib.SetTargetFPS (FPS);

      --  Wyłączenie domyślnego zamykania aplikacji klawiszem ESC w bibliotece Raylib
      Standard.Raylib.SetExitKey (Standard.Raylib.KeyboardKey'Val (0));

      Cur_Mon := Standard.Raylib.GetCurrentMonitor;
      Mon_W   := Standard.Raylib.GetMonitorWidth (Cur_Mon);
      Mon_H   := Standard.Raylib.GetMonitorHeight (Cur_Mon);

      if Current_Mode = Borderless_Fullscreen then
         Standard.Raylib.SetWindowSize (Mon_W, Mon_H);
         Standard.Raylib.SetWindowPosition (0, 0);
      else
         if Virtual_W > Mon_W or else Virtual_H > Mon_H then
            Virtual_W := 1280;
            Virtual_H := 720;
            Standard.Raylib.SetWindowSize (Virtual_W, Virtual_H);
         end if;
         if Win_Cfg.Center_On_Screen then
            Center_Window (Integer (Virtual_W), Integer (Virtual_H));
         end if;
      end if;
   end Initialize;

   procedure Apply_Preset (Index : Positive) is
      Req_W : constant int := Presets_Table (Index).Width;
      Req_H : constant int := Presets_Table (Index).Height;
   begin
      if Current_Mode = Borderless_Fullscreen then
         Virtual_W := Req_W;
         Virtual_H := Req_H;
      else
         if Req_W <= Mon_W and then Req_H <= Mon_H then
            Virtual_W := Req_W;
            Virtual_H := Req_H;
            Standard.Raylib.SetWindowSize (Virtual_W, Virtual_H);
            Center_Window (Integer (Virtual_W), Integer (Virtual_H));
         end if;
      end if;
   end Apply_Preset;

   procedure Toggle_Borderless is
   begin
      if Current_Mode /= Borderless_Fullscreen then
         Is_Frameless := not Is_Frameless;
         if Is_Frameless then
            Standard.Raylib.SetWindowState (Standard.Raylib.FLAG_WINDOW_UNDECORATED);
            Current_Mode := Borderless;
         else
            Standard.Raylib.ClearWindowState (Standard.Raylib.FLAG_WINDOW_UNDECORATED);
            Current_Mode := Windowed;
         end if;
         Center_Window (Integer (Virtual_W), Integer (Virtual_H));
      end if;
   end Toggle_Borderless;

   function Get_Virtual_Width return Integer is (Integer (Virtual_W));
   function Get_Virtual_Height return Integer is (Integer (Virtual_H));
   function Get_Display_Mode return Display_Mode_Type is (Current_Mode);

   procedure Close is
   begin
      Standard.Raylib.CloseWindow;
   end Close;

end Gabyx.Drivers.Raylib.Window_Mgr;
