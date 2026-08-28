--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja kolorowego formatowania ANSI w konsoli.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging-console.adb
--  CREATED:         2026-08-28
--  ============================================================================


with Ada.Text_IO;

package body Gabyx.Logging.Console is

   --  Kody kolorów ANSI
   Code_Reset    : constant String := ASCII.ESC & "[0m";
   Code_Trace    : constant String := ASCII.ESC & "[90m";   -- Szary
   Code_Debug    : constant String := ASCII.ESC & "[36m";   -- Cyjan
   Code_Info     : constant String := ASCII.ESC & "[32m";   -- Zielony
   Code_Warn     : constant String := ASCII.ESC & "[33m";   -- Żółty
   Code_Error    : constant String := ASCII.ESC & "[31m";   -- Czerwony
   Code_Critical : constant String := ASCII.ESC & "[1;35m"; -- Jaskrawa magenta

   function Get_Color_Code (Level : Log_Level) return String is
     (case Level is
         when Level_Trace    => Code_Trace,
         when Level_Debug    => Code_Debug,
         when Level_Info     => Code_Info,
         when Level_Warning  => Code_Warn,
         when Level_Error    => Code_Error,
         when Level_Critical => Code_Critical);

   procedure Print
     (Timestamp  : String;
      Level      : Log_Level;
      Domain     : Log_Domain;
      Message    : String;
      Use_Colors : Boolean)
   is
      Lvl_Str : constant String := Level_To_String (Level);
      Dom_Str : constant String := Domain_To_String (Domain);
      Padding : constant String := (if Lvl_Str'Length = 4 then " " else "");
   begin
      if Use_Colors then
         Ada.Text_IO.Put_Line
           ("[" & Timestamp & "] " &
            Get_Color_Code (Level) & "[" & Lvl_Str & Padding & "]" & Code_Reset &
            " [" & Dom_Str & "] " & Message);
      else
         Ada.Text_IO.Put_Line
           ("[" & Timestamp & "] [" & Lvl_Str & Padding & "] [" & Dom_Str & "] " & Message);
      end if;
   end Print;

end Gabyx.Logging.Console;
