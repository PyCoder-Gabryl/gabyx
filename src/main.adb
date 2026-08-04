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
with Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;
with TOML;
with TOML.File_IO;

procedure Main is

   --  ============================================================================
   --  SEKCJA DEFINICJI
   --  ============================================================================
   Config_Path : constant String := "configs/window.toml";

   Choice         : Integer := 0;
   Exit_Requested : Boolean := False;

begin
   --  Rysowanie ASCII nagłówka
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("==================================================");
   Ada.Text_IO.Put_Line ("           GABYX OMNI-ENGINE STARTER             ");
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

   --  Glowna petla interaktywnego menu wyboru
   while not Exit_Requested loop
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line ("--------------------------------------------------");
      Ada.Text_IO.Put_Line ("Wybierz sterownik prezentacji:");
      Ada.Text_IO.Put_Line ("   Tryby tekstowe (TUI):");
      Ada.Text_IO.Put_Line ("   1. ANSI Escape Codes (Czysty SPARK)");
      Ada.Text_IO.Put_Line ("   2. Ncurses TUI (Wydajnosc okienkowa)");
      Ada.Text_IO.Put_Line ("   3. Trendy_Terminal TUI (Deklaratywne)");
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line ("   Tryby graficzne (GUI):");
      Ada.Text_IO.Put_Line ("   4. Raylib 2D Engine (Glowny)");
      Ada.Text_IO.Put_Line ("   5. SDL2 Engine (Atrapa)");
      Ada.Text_IO.Put_Line ("   6. GtkAda GUI (Atrapa)");
      Ada.Text_IO.Put_Line ("   7. ASFML Engine (SFML - Atrapa)");
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line ("   Zarzadzanie:");
      Ada.Text_IO.Put_Line ("   8. Wyjscie");
      Ada.Text_IO.Put_Line ("--------------------------------------------------");
      Ada.Text_IO.Put ("Wybor: ");

      begin
         Ada.Integer_Text_IO.Get (Choice);
         Ada.Text_IO.Skip_Line; -- Czyszczenie bufora wejściowego

         case Choice is
            when 1 =>
               Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika ANSI Escape Codes...");
            when 2 =>
               Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika Ncurses TUI...");
            when 3 =>
               Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika Trendy_Terminal TUI...");
            when 4 =>
               Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika Raylib 2D Engine...");
            when 5 =>
               Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika SDL2 Engine...");
            when 6 =>
               Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika GtkAda GUI...");
            when 7 =>
               Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika ASFML Engine (SFML)...");
            when 8 =>
               Exit_Requested := True;
               Ada.Text_IO.Put_Line ("[INFO] Zamykanie programu. Do zobaczenia!");
            when others =>
               Ada.Text_IO.Put_Line ("[BLAD] Niepoprawny wybor! Wprowadz liczbe od 1 do 8.");
         end case;
      exception
         when others =>
            Ada.Text_IO.Put_Line ("[BLAD] Blad wejscia! Wprowadz poprawna liczbe.");
            Ada.Text_IO.Skip_Line; -- Zapobieganie pętli nieskończonej przy błędnym znaku
      end;
   end loop;

end Main;
