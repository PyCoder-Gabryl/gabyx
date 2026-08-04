--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Główny punkt wejściowy (Starter) gry Gabyx.
--                    Odpowiada za zainicjowanie podstawowych informacji,
--                    wczytanie i sparsowanie pliku konfiguracyjnego TOML,
--                    wyświetlenie parametrów rozdzielczości oraz terminalowego
--                    menu wyboru aktywnego silnika graficznego.
--  ----------------------------------------------------------------------------
--  PATH:            src/main.adb
--  VERSION:         0.1.0
--  CREATED:         2026-08-04
--  ============================================================================



with Ada.Text_IO;
with Ada.Strings.Unbounded;
with TOML;
with TOML.File_IO;

procedure Main is

   --  ============================================================================
   --  SEKCJA DEFINICJI
   --  ============================================================================
   Config_Path : constant String := "configs/window.toml";

begin
   --  Rysowanie ASCII nagłówka
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("==================================================");
   Ada.Text_IO.Put_Line ("           GABYX OMNI-ENGINE STARTER              ");
   Ada.Text_IO.Put_Line ("==================================================");
   Ada.Text_IO.New_Line;

   --  EDU: Parsowanie struktury TOML za pomocą bezpiecznego parsera ada_toml
   declare
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (Config_Path);
   begin
      if Result.Success then
         Ada.Text_IO.Put_Line ("[INFO] Pomyslnie wczytano plik: " & Config_Path);

         declare
            Window_Table : constant TOML.TOML_Value := Result.Value.Get ("window");
            Title_Val    : constant TOML.TOML_Value := Window_Table.Get ("title");
            Width_Val    : constant TOML.TOML_Value := Window_Table.Get ("width");
            Height_Val   : constant TOML.TOML_Value := Window_Table.Get ("height");
         begin
            Ada.Text_IO.Put_Line ("[CONFIG] Tytul okna : " & Title_Val.As_String);
            Ada.Text_IO.Put_Line ("[CONFIG] Szerokosc  : " & Width_Val.As_Integer'Image);
            Ada.Text_IO.Put_Line ("[CONFIG] Wysokosc   : " & Height_Val.As_Integer'Image);
         end;
      else
         Ada.Text_IO.Put_Line ("[BLAD] Nie udalo sie wczytac konfiguracji: " & Config_Path);
         Ada.Text_IO.Put_Line (Ada.Strings.Unbounded.To_String (Result.Message));
      end if;
   end;

   --  Prezentacja menu wyboru (Komunikaty po polsku, czysty format ASCII)
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("--------------------------------------------------");
   Ada.Text_IO.Put_Line ("Wybierz sterownik graficzny:");
   Ada.Text_IO.Put_Line ("1. Terminal ANSI (Czysty SPARK)");
   Ada.Text_IO.Put_Line ("2. Raylib 2D Engine (Atrapa)");
   Ada.Text_IO.Put_Line ("3. SDL2 Engine (Atrapa)");
   Ada.Text_IO.Put_Line ("4. Wyjscie");
   Ada.Text_IO.Put_Line ("--------------------------------------------------");
   Ada.Text_IO.Put_Line ("Wybor: [Menu wyboru zostanie wdrozone w nastepnym kroku]");
   Ada.Text_IO.New_Line;

end Main;
