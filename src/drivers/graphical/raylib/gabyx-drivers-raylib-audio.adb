--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja proceduralnego generatora fal PCM dla raudio w Raylib.
--                   Syntetyzuje fale sinusoidalne w pamięci RAM i konwertuje do struktur Sound.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib-audio.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Interfaces.C;
with Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
with Raylib;

package body Gabyx.Drivers.Raylib.Audio is

   use Interfaces.C;
   use Ada.Numerics.Elementary_Functions;

   Audio_Ready    : Boolean := False;
   Sound_Move     : Standard.Raylib.Sound;
   Sound_Select   : Standard.Raylib.Sound;
   Sound_Set_Open : Standard.Raylib.Sound;
   Sound_Set_Move : Standard.Raylib.Sound;

   type Sample_Array_Short is array (0 .. 1763) of short;
   Move_Samples     : aliased Sample_Array_Short := [others => 0];
   Select_Samples   : aliased Sample_Array_Short := [others => 0];
   Set_Open_Samples : aliased Sample_Array_Short := [others => 0];
   Set_Move_Samples : aliased Sample_Array_Short := [others => 0];

   procedure Synthesize_Sounds;

   procedure Synthesize_Sounds is
      Wave_Move     : Standard.Raylib.Wave;
      Wave_Select   : Standard.Raylib.Wave;
      Wave_Set_Open : Standard.Raylib.Wave;
      Wave_Set_Move : Standard.Raylib.Wave;
      Two_Pi        : constant Float := 2.0 * Ada.Numerics.Pi;
   begin
      --  1. Dźwięk menu (880 Hz, 0.04s)
      for I in Move_Samples'Range loop
         declare
            T   : constant Float := Float (I) / 44100.0;
            Env : constant Float := 1.0 - (Float (I) / Float (Move_Samples'Length));
            Val : constant Float := Sin (Two_Pi * 880.0 * T) * Env * 16000.0;
         begin
            Move_Samples (I) := short (Val);
         end;
      end loop;
      Wave_Move.frameCount := unsigned (Move_Samples'Length);
      Wave_Move.sampleRate := 44100;
      Wave_Move.sampleSize := 16;
      Wave_Move.channels   := 1;
      Wave_Move.data       := Move_Samples'Address;
      Sound_Move := Standard.Raylib.LoadSoundFromWave (Wave_Move);

      --  2. Dźwięk wyboru (Dwuton 587 -> 880 Hz)
      for I in Select_Samples'Range loop
         declare
            T    : constant Float := Float (I) / 44100.0;
            Freq : constant Float := (if I < Select_Samples'Length / 2 then 587.33 else 880.0);
            Env  : constant Float := 1.0 - (Float (I) / Float (Select_Samples'Length));
            Val  : constant Float := Sin (Two_Pi * Freq * T) * Env * 20000.0;
         begin
            Select_Samples (I) := short (Val);
         end;
      end loop;
      Wave_Select.frameCount := unsigned (Select_Samples'Length);
      Wave_Select.sampleRate := 44100;
      Wave_Select.sampleSize := 16;
      Wave_Select.channels   := 1;
      Wave_Select.data       := Select_Samples'Address;
      Sound_Select := Standard.Raylib.LoadSoundFromWave (Wave_Select);

      --  3. Dźwięk otwarcia Ustawień (Miękki ton 440 -> 660 Hz)
      for I in Set_Open_Samples'Range loop
         declare
            T    : constant Float := Float (I) / 44100.0;
            Freq : constant Float := 440.0 + (Float (I) / Float (Set_Open_Samples'Length)) * 220.0;
            Env  : constant Float := 1.0 - (Float (I) / Float (Set_Open_Samples'Length));
            Val  : constant Float := Sin (Two_Pi * Freq * T) * Env * 18000.0;
         begin
            Set_Open_Samples (I) := short (Val);
         end;
      end loop;
      Wave_Set_Open.frameCount := unsigned (Set_Open_Samples'Length);
      Wave_Set_Open.sampleRate := 44100;
      Wave_Set_Open.sampleSize := 16;
      Wave_Set_Open.channels   := 1;
      Wave_Set_Open.data       := Set_Open_Samples'Address;
      Sound_Set_Open := Standard.Raylib.LoadSoundFromWave (Wave_Set_Open);

      --  4. Dźwięk nawigacji w Ustawieniach (Niski subtelny klik 440 Hz, 0.02s)
      for I in Set_Move_Samples'Range loop
         declare
            T   : constant Float := Float (I) / 44100.0;
            Env : constant Float := 1.0 - (Float (I) / Float (Set_Move_Samples'Length));
            Val : constant Float := Sin (Two_Pi * 440.0 * T) * Env * 14000.0;
         begin
            Set_Move_Samples (I) := short (Val);
         end;
      end loop;
      Wave_Set_Move.frameCount := unsigned (Set_Move_Samples'Length);
      Wave_Set_Move.sampleRate := 44100;
      Wave_Set_Move.sampleSize := 16;
      Wave_Set_Move.channels   := 1;
      Wave_Set_Move.data       := Set_Move_Samples'Address;
      Sound_Set_Move := Standard.Raylib.LoadSoundFromWave (Wave_Set_Move);
   end Synthesize_Sounds;

   procedure Initialize (Audio_Cfg : Gabyx.Config.Audio.Audio_Configuration) is
   begin
      Standard.Raylib.InitAudioDevice;
      Audio_Ready := Boolean (Standard.Raylib.IsAudioDeviceReady);

      if Audio_Ready then
         Standard.Raylib.SetMasterVolume (C_float (Audio_Cfg.Master_Volume) / 100.0);
         Synthesize_Sounds;
      end if;
   end Initialize;

   procedure Play_Menu_Move is
   begin
      if Audio_Ready then Standard.Raylib.PlaySound (Sound_Move); end if;
   end Play_Menu_Move;

   procedure Play_Menu_Select is
   begin
      if Audio_Ready then Standard.Raylib.PlaySound (Sound_Select); end if;
   end Play_Menu_Select;

   procedure Play_Settings_Open is
   begin
      if Audio_Ready then Standard.Raylib.PlaySound (Sound_Set_Open); end if;
   end Play_Settings_Open;

   procedure Play_Settings_Move is
   begin
      if Audio_Ready then Standard.Raylib.PlaySound (Sound_Set_Move); end if;
   end Play_Settings_Move;

   procedure Close is
   begin
      if Audio_Ready then
         Standard.Raylib.UnloadSound (Sound_Move);
         Standard.Raylib.UnloadSound (Sound_Select);
         Standard.Raylib.UnloadSound (Sound_Set_Open);
         Standard.Raylib.UnloadSound (Sound_Set_Move);
         Standard.Raylib.CloseAudioDevice;
      end if;
   end Close;

end Gabyx.Drivers.Raylib.Audio;
