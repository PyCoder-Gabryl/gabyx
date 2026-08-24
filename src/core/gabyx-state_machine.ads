--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Formalna maszyna stanów aplikacji (Application State Machine).
--                   Zarządza globalnym cyklem życia silnika: ekranem Splash,
--                   menu głównym, oknem ustawień oraz stanem aktywnej rozgrywki.
--  ----------------------------------------------------------------------------
--  PATH:            src/core/gabyx-state_machine.ads
--  CREATED:         2026-08-24
--  ============================================================================


package Gabyx.State_Machine with
   SPARK_Mode => On
is

   --  Dostępne stany globalne silnika
   type App_State is
     (State_Splash,
      State_Main_Menu,
      State_In_Game,
      State_Settings,
      State_Quit);

   --  Zmienia bieżący stan aplikacji
   procedure Set_State (New_State : App_State);

   --  Zwraca aktualny stan aplikacji
   function Get_State return App_State;

   --  Sprawdza, czy silnik znajduje się w zadanym stanie
   function Is_In_State (State : App_State) return Boolean;

end Gabyx.State_Machine;
