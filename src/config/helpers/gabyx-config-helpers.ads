--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Modul narzedziowy wspomagajacy bezpieczny odczyt danych TOML.
--                    Zawiera funkcje odczytu wartosci skalarnych (napisy, liczby,
--                    flagi logiczne) z gwarancja zwrotu bezpiecznych wartosci
--                    domyslnych (fallback) w przypadku brakujacych lub blednych kluczy.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/helpers/gabyx-config-helpers.ads
--  CREATED:         2026-08-23
--  ============================================================================


with TOML;

package Gabyx.Config.Helpers is

   --  Bezpieczny odczyt lancucha znakow z tabeli TOML
   function Read_String
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : String) return String;

   --  Bezpieczny odczyt wartosci logicznej z tabeli TOML
   function Read_Boolean
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Boolean) return Boolean;

   --  Bezpieczny odczyt liczby calkowitej z tabeli TOML
   function Read_Integer
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Integer) return Integer;

   --  Bezpieczny odczyt liczby zmiennoprzecinkowej z tabeli TOML
   function Read_Float
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Float) return Float;

end Gabyx.Config.Helpers;
