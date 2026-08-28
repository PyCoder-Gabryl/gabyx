--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja bezpiecznego zapisu plikowego z obsługą wyjątków I/O.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging-file.adb
--  CREATED:         2026-08-28
--  ============================================================================


with Ada.Text_IO;

package body Gabyx.Logging.File is

   Log_Handle : Ada.Text_IO.File_Type;
   File_Open  : Boolean := False;

   procedure Initialize (Target_Path : String) is
   begin
      if File_Open then
         Ada.Text_IO.Close (Log_Handle);
         File_Open := False;
      end if;

      Ada.Text_IO.Create (Log_Handle, Ada.Text_IO.Out_File, Target_Path);
      File_Open := True;
   exception
      when others =>
         File_Open := False;
   end Initialize;

   procedure Write_Entry (JSON_Line : String) is
   begin
      if File_Open then
         Ada.Text_IO.Put_Line (Log_Handle, JSON_Line);
         Ada.Text_IO.Flush (Log_Handle);
      end if;
   end Write_Entry;

   procedure Close is
   begin
      if File_Open then
         Ada.Text_IO.Close (Log_Handle);
         File_Open := False;
      end if;
   end Close;

   function Is_Active return Boolean is (File_Open);

end Gabyx.Logging.File;
