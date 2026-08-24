--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Logiczny model Menu Głównego w czystym SPARK. Definiuje 8 pozycji
--                   menu, stany dostępności (aktywna sesja gry, obecność zapisu) oraz
--                   algorytm nawigacji z automatycznym pomijaniem wyszarzonych opcji.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/gabyx-ui-menu.ads
--  CREATED:         2026-08-24
--  ============================================================================


package Gabyx.UI.Menu with
   SPARK_Mode => On,
   Pure
is

   --  8 pozycji Menu Głównego w ustalonej kolejności
   type Menu_Item_ID is
     (Item_New_Game,
      Item_Continue,
      Item_Save_Game,
      Item_Load_Game,
      Item_Settings,
      Item_Help,
      Item_About,
      Item_Quit);

   type Menu_State is record
      Selected_Item   : Menu_Item_ID := Item_New_Game;
      Has_Save_File   : Boolean      := False;
      Has_Active_Game : Boolean      := False;
   end record;

   --  Sprawdza, czy dana pozycja menu jest aktywna (niewyszarzona)
   function Is_Item_Enabled
     (State : Menu_State;
      Item  : Menu_Item_ID) return Boolean;

   --  Nawigacja w dół z automatycznym omijaniem pozycji wyszarzonych
   procedure Select_Next (State : in out Menu_State);

   --  Nawigacja w górę z automatycznym omijaniem pozycji wyszarzonych
   procedure Select_Prev (State : in out Menu_State);

   --  Zwraca czytelną etykietę tekstową pozycji menu
   function Get_Item_Label (Item : Menu_Item_ID) return String;

end Gabyx.UI.Menu;
