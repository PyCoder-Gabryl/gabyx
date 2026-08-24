--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja parsera pliku camera.toml. Odczytuje parametry
--                   zoomu oraz dynamiczną tablicę kolorów siatki z sekcji [[grid.colors]].
--  ----------------------------------------------------------------------------
--  PATH:            src/config/display/gabyx-config-camera.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Text_IO;
with TOML;
with TOML.File_IO;
with Gabyx.Config.Helpers;

package body Gabyx.Config.Camera is

   use type TOML.Any_Value_Kind;
   use Gabyx.Config.Helpers;

   function Get_Default_Configuration return Camera_Configuration is
      Config : Camera_Configuration;
   begin
      return Config;
   end Get_Default_Configuration;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Camera_Configuration
   is
      Config : Camera_Configuration := Get_Default_Configuration;
      Result : constant TOML.Read_Result := TOML.File_IO.Load_File (File_Path);
   begin
      if not Result.Success then
         Ada.Text_IO.Put_Line ("[CONFIG] Brak pliku " & File_Path & " - uzyto konfiguracji kamery domyslnej.");
         return Config;
      end if;

      declare
         Root : constant TOML.TOML_Value := Result.Value;
      begin
         --  1. Sekcja [zoom]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("zoom") then
            declare
               Zoom_Tab : constant TOML.TOML_Value := Root.Get ("zoom");
               Idx      : constant Integer := Read_Integer (Zoom_Tab, "active_zoom_index", 4);
            begin
               if Idx in 1 .. 5 then
                  Config.Active_Zoom_Index := Idx;
               end if;
            end;
         end if;

         --  2. Sekcja [grid]
         if Root.Kind = TOML.TOML_Table and then Root.Has ("grid") then
            declare
               Grid_Tab : constant TOML.TOML_Value := Root.Get ("grid");
            begin
               Config.Grid_Visible := Read_Boolean (Grid_Tab, "visible", True);
               Config.Active_Color_Index := Positive (Read_Integer (Grid_Tab, "active_color_index", 1));

               --  Dynamiczny odczyt tablicy tabel [[grid.colors]]
               if Grid_Tab.Kind = TOML.TOML_Table and then Grid_Tab.Has ("colors") then
                  declare
                     Colors_Arr : constant TOML.TOML_Value := Grid_Tab.Get ("colors");
                     Count      : constant Integer := Integer (Colors_Arr.Length);
                  begin
                     if Count > 0 then
                        Config.Color_Count := (if Count > 8 then 8 else Count);
                        for I in 1 .. Config.Color_Count loop
                           declare
                              Elem : constant TOML.TOML_Value := Colors_Arr.Item (Positive (I));
                           begin
                              Config.Palette (I).R := Color_Component (Read_Integer (Elem, "r", 46));
                              Config.Palette (I).G := Color_Component (Read_Integer (Elem, "g", 204));
                              Config.Palette (I).B := Color_Component (Read_Integer (Elem, "b", 113));
                              Config.Palette (I).A := Color_Component (Read_Integer (Elem, "a", 140));
                           end;
                        end loop;
                     end if;
                  end;
               end if;
            end;
         end if;
      end;

      return Config;
   end Load_Configuration;

end Gabyx.Config.Camera;
