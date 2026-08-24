--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja maszyny stanów silnika w SPARK.
--  ----------------------------------------------------------------------------
--  PATH:            src/core/gabyx-state_machine.adb
--  CREATED:         2026-08-24
--  ============================================================================


package body Gabyx.State_Machine with
   SPARK_Mode => On
is

   Current_State : App_State := State_Splash;

   procedure Set_State (New_State : App_State) is
   begin
      Current_State := New_State;
   end Set_State;

   function Get_State return App_State is (Current_State);

   function Is_In_State (State : App_State) return Boolean is
     (Current_State = State);

end Gabyx.State_Machine;
