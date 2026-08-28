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

   --  Wcześniejsza deklaracja funkcji pomocniczej (wymóg stylu -gnatys)
   function Get_Timestamp return String;

   function Level_To_String (Level : Log_Level) return String is
     (case Level is
         when Level_Trace    => "TRACE",
         when Level_Debug    => "DEBUG",
         when Level_Info     => "INFO",
         when Level_Warning  => "WARN",
         when Level_Error    => "ERROR",
         when Level_Critical => "CRITICAL");

   function Domain_To_String (Domain : Log_Domain) return String is
     (case Domain is
         when Domain_Engine => "ENGINE",
         when Domain_Config => "CONFIG",
         when Domain_Window => "WINDOW",
         when Domain_Render => "RENDER",
         when Domain_Audio  => "AUDIO",
         when Domain_Input  => "INPUT",
         when Domain_UI     => "UI",
         when Domain_Game   => "GAME",
         when Domain_Save   => "SAVE");

   function String_To_Level (Str : String; Default : Log_Level) return Log_Level is
   begin
      if Str = "TRACE" then return Level_Trace;
      elsif Str = "DEBUG" then return Level_Debug;
      elsif Str = "INFO" then return Level_Info;
      elsif Str = "WARN" or Str = "WARNING" then return Level_Warning;
      elsif Str = "ERROR" then return Level_Error;
      elsif Str = "CRITICAL" or Str = "FATAL" then return Level_Critical;
      else return Default;
      end if;
   end String_To_Level;

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
      if Level >= Console_Min then
         Gabyx.Logging.Console.Print (Stamp, Level, Domain, Message, Use_Colors);
      end if;

      if File_Active and then Level >= File_Min then
         declare
            Line : constant String := Gabyx.Logging.JSON.Format_NDJSON (Stamp, Level, Domain, Message);
         begin
            Gabyx.Logging.File.Write_Entry (Line);
         end;
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
