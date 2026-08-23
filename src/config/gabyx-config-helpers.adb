--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja narzedzi defensywnego parsowania TOML.
--                    Wykorzystuje biblioteke ada_toml do sprawdzania typow wezlow.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-helpers.adb
--  CREATED:         2026-08-23
--  ============================================================================


package body Gabyx.Config.Helpers is

   use type TOML.Any_Value_Kind;

   function Read_String
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : String) return String
   is
   begin
      if Table.Kind = TOML.TOML_Table and then Table.Has (Key) then
         declare
            Val : constant TOML.TOML_Value := Table.Get (Key);
         begin
            if Val.Kind = TOML.TOML_String then
               return Val.As_String;
            end if;
         end;
      end if;
      return Default;
   end Read_String;

   function Read_Boolean
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Boolean) return Boolean
   is
   begin
      if Table.Kind = TOML.TOML_Table and then Table.Has (Key) then
         declare
            Val : constant TOML.TOML_Value := Table.Get (Key);
         begin
            if Val.Kind = TOML.TOML_Boolean then
               return Val.As_Boolean;
            end if;
         end;
      end if;
      return Default;
   end Read_Boolean;

   function Read_Integer
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Integer) return Integer
   is
   begin
      if Table.Kind = TOML.TOML_Table and then Table.Has (Key) then
         declare
            Val : constant TOML.TOML_Value := Table.Get (Key);
         begin
            if Val.Kind = TOML.TOML_Integer then
               return Integer (Val.As_Integer);
            end if;
         end;
      end if;
      return Default;
   end Read_Integer;

   function Read_Float
     (Table   : TOML.TOML_Value;
      Key     : String;
      Default : Float) return Float
   is
   begin
      if Table.Kind = TOML.TOML_Table and then Table.Has (Key) then
         declare
            Val : constant TOML.TOML_Value := Table.Get (Key);
         begin
            if Val.Kind = TOML.TOML_Integer then
               return Float (Val.As_Integer);
            end if;
         end;
      end if;
      return Default;
   end Read_Float;

end Gabyx.Config.Helpers;
