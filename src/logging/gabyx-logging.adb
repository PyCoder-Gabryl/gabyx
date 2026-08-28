--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja fasady loggera. Generuje stemple czasu, filtruje wagi
--                   i dystrybuuje wpisy do konsoli ANSI oraz pliku JSON Lines.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging.adb
--  CREATED:         2026-08-28
--  ============================================================================


with Ada.Calendar;
with Ada.Calendar.Formatting;
with Ada.Strings.Unbounded;
with Gabyx.Logging.JSON;
with Gabyx.Logging.Console;
with Gabyx.Logging.File;

package body Gabyx.Logging is

   use Ada.Strings.Unbounded;

   Console_Min : Log_Level := Level_Info;
   File_Min    : Log_Level := Level_Debug;
   Use_Colors  : Boolean   := True;
   File_Active : Boolean   := True;

   function Get_Timestamp return String is
      Now : constant Ada.Calendar.Time := Ada.Calendar.Clock;
   begin
      return Ada.Calendar.Formatting.Image (Now);
   end Get_Timestamp;

   procedure Initialize (Cfg : Gabyx.Config.Logger.Logger_Configuration) is
   begin
      Console_Min := String_To_Level (To_String (Cfg.Console_Min_Level), Level_Info);
      File_Min    := String_To_Level (To_String (Cfg.File_Min_Level), Level_Debug);
      Use_Colors  := Cfg.Console_Colored;
      File_Active := Cfg.File_Enabled;

      if File_Active then
         Gabyx.Logging.File.Initialize (To_String (Cfg.File_Path));
      end if;

      Log_Info (Domain_Engine, "Zainicjalizowano podsystem logowania Gabyx");
   end Initialize;

   procedure Log
     (Level   : Log_Level;
      Domain  : Log_Domain;
      Message : String)
   is
      Stamp : constant String := Get_Timestamp;
   begin
      --  1. Wyjście konsolowe ANSI
      if Level >= Console_Min then
         Gabyx.Logging.Console.Print (Stamp, Level, Domain, Message, Use_Colors);
      end if;

      --  2. Zapis do pliku JSON Lines
      if File_Active and then Level >= File_Min then
         declare
            Line : constant String := Gabyx.Logging.JSON.Format_NDJSON (Stamp, Level, Domain, Message);
         begin
            Gabyx.Logging.File.Write_Entry (Line);
         end if;
      end if;
   end Log;

   procedure Log_Trace (Domain : Log_Domain; Message : String) is
   begin
      Log (Level_Trace, Domain, Message);
   end Log_Trace;

   procedure Log_Debug (Domain : Log_Domain; Message : String) is
   begin
      Log (Level_Debug, Domain, Message);
   end Log_Debug;

   procedure Log_Info (Domain : Log_Domain; Message : String) is
   begin
      Log (Level_Info, Domain, Message);
   end Log_Info;

   procedure Log_Warn (Domain : Log_Domain; Message : String) is
   begin
      Log (Level_Warning, Domain, Message);
   end Log_Warn;

   procedure Log_Error (Domain : Log_Domain; Message : String) is
   begin
      Log (Level_Error, Domain, Message);
   end Log_Error;

   procedure Log_Critical (Domain : Log_Domain; Message : String) is
   begin
      Log (Level_Critical, Domain, Message);
   end Log_Critical;

   procedure Shutdown is
   begin
      Log_Info (Domain_Engine, "Zamykanie podsystemu logowania Gabyx");
      Gabyx.Logging.File.Close;
   end Shutdown;

end Gabyx.Logging;
