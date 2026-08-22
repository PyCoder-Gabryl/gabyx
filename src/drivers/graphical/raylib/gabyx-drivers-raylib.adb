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

package body Gabyx.Drivers.Raylib is

   --  ============================================================================
   --  IMPLEMENTACJA INTERFEJSU PUBLICZNEGO
   --  ============================================================================

   procedure Run (Config : Gabyx.Config.Window_Configuration) is
      use Interfaces.C;

      --  Konwersja składowych koloru z konfiguracji do formatu rekordu Raylib
      Clear_Color : constant Standard.Raylib.Color :=
        (r => unsigned_char (Config.Clear_Color.R),
         g => unsigned_char (Config.Clear_Color.G),
         b => unsigned_char (Config.Clear_Color.B),
         a => unsigned_char (Config.Clear_Color.A));

      --  Zdefiniowane stałe kolorów tekstu
      Text_White : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Text_Gray  : constant Standard.Raylib.Color := (r => 180, g => 180, b => 180, a => 255);
      Text_Gold  : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0,   a => 255);

      Title_Str : constant String :=
        Ada.Strings.Unbounded.To_String (Config.Title);
      Win_W     : constant int := int (Config.Width);
      Win_H     : constant int := int (Config.Height);
      FPS       : constant int :=
        (if Config.Target_FPS > 0 then int (Config.Target_FPS) else 60);

   begin
      --  1. Inicjalizacja okna graficznego i kontekstu graficznego
      Standard.Raylib.InitWindow (Win_W, Win_H, Title_Str);
      Standard.Raylib.SetTargetFPS (FPS);

      --  2. Główna pętla renderowania okna
      while not Boolean (Standard.Raylib.WindowShouldClose) loop
         Standard.Raylib.BeginDrawing;
         Standard.Raylib.ClearBackground (Clear_Color);

         --  Wyświetlenie informacji diagnostycznych na ekranie
         Standard.Raylib.DrawText
           ("GABYX OMNI-ENGINE (RAYLIB 2D BACKEND)",
            40,
            40,
            24,
            Text_White);

         Standard.Raylib.DrawText
           ("Rozdzielczosc: " & Integer (Win_W)'Image & " x " & Integer (Win_H)'Image & " px",
            40,
            80,
            18,
            Text_Gray);

         Standard.Raylib.DrawText
           ("Docelowy klatkarz: " & Integer (FPS)'Image & " FPS",
            40,
            110,
            18,
            Text_Gray);

         Standard.Raylib.DrawText
           ("Nacisnij ESC lub zamknij okno, aby wrocic do menu.",
            40,
            160,
            18,
            Text_Gold);

         Standard.Raylib.EndDrawing;
      end loop;

      --  3. Bezpieczne zwolnienie zasobów GPU i zamknięcie okna
      Standard.Raylib.CloseWindow;
   end Run;

end Gabyx.Drivers.Raylib;
