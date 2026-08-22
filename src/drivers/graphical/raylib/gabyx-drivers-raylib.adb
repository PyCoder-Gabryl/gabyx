--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib.adb
--  CREATED:         2026-08-22
--  ============================================================================


with Interfaces.C;
with Ada.Strings.Unbounded;
with Raylib;
with Raylib.Colors;

package body Gabyx.Drivers.Raylib is

   --  ============================================================================
   --  IMPLEMENTACJA INTERFEJSU PUBLICZNEGO
   --  ============================================================================

   procedure Run (Config : Gabyx.Config.Window_Configuration) is
      use Interfaces.C;

      --  Konwersja składowych koloru z konfiguracji do formatu Raylib
      Clear_Color : constant global::Raylib.Color :=
        (R => unsigned_char (Config.Clear_Color.R),
         G => unsigned_char (Config.Clear_Color.G),
         B => unsigned_char (Config.Clear_Color.B),
         A => unsigned_char (Config.Clear_Color.A));

      Title_Str : constant String :=
        Ada.Strings.Unbounded.To_String (Config.Title);
      Win_W     : constant Integer := Integer (Config.Width);
      Win_H     : constant Integer := Integer (Config.Height);
      FPS       : constant Integer :=
        (if Config.Target_FPS > 0 then Integer (Config.Target_FPS) else 60);

   begin
      --  1. Inicjalizacja okna graficznego i kontekstu OpenGL / Metal
      global::Raylib.Init_Window (Win_W, Win_H, Title_Str);
      global::Raylib.Set_Target_FPS (FPS);

      --  2. Główna pętla renderowania okna
      while not global::Raylib.Window_Should_Close loop
         global::Raylib.Begin_Drawing;
         global::Raylib.Clear_Background (Clear_Color);

         --  Wyświetlenie informacji diagnostycznych na ekranie
         global::Raylib.Draw_Text
           ("GABYX OMNI-ENGINE (RAYLIB 2D BACKEND)",
            40,
            40,
            24,
            global::Raylib.Colors.Ray_White);

         global::Raylib.Draw_Text
           ("Rozdzielczosc: " & Win_W'Image & " x " & Win_H'Image & " px",
            40,
            80,
            18,
            global::Raylib.Colors.Light_Gray);

         global::Raylib.Draw_Text
           ("Docelowy klatkarz: " & FPS'Image & " FPS",
            40,
            110,
            18,
            global::Raylib.Colors.Light_Gray);

         global::Raylib.Draw_Text
           ("Nacisnij ESC lub zamknij okno, aby wrocic do menu.",
            40,
            160,
            18,
            global::Raylib.Colors.Gold);

         global::Raylib.End_Drawing;
      end loop;

      --  3. Bezpieczne zwolnienie kontekstu GPU i zamknięcie okna
      global::Raylib.Close_Window;
   end Run;

end Gabyx.Drivers.Raylib;
