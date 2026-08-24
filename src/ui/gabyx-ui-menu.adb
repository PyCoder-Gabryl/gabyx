--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja nawigacji menu w SPARK. Gwarantuje matematyczny
--                   brak zapętlenia oraz zatrzymywanie wyboru wyłącznie na aktywnych opcjach.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/gabyx-ui-menu.adb
--  CREATED:         2026-08-24
--  ============================================================================


package body Gabyx.UI.Menu with
   SPARK_Mode => On
is

   function Is_Item_Enabled
     (State : Menu_State;
      Item  : Menu_Item_ID) return Boolean
   is
   begin
      case Item is
         when Item_New_Game | Item_Settings | Item_Help | Item_About | Item_Quit =>
            return True;
         when Item_Continue | Item_Load_Game =>
            return State.Has_Save_File;
         when Item_Save_Game =>
            return State.Has_Active_Game;
      end case;
   end Is_Item_Enabled;

   procedure Select_Next (State : in out Menu_State) is
      Current : Menu_Item_ID := State.Selected_Item;
   begin
      for Step in 1 .. 8 loop
         Current := (if Current = Menu_Item_ID'Last then Menu_Item_ID'First else Menu_Item_ID'Succ (Current));
         if Is_Item_Enabled (State, Current) then
            State.Selected_Item := Current;
            return;
         end if;
      end loop;
   end Select_Next;

   procedure Select_Prev (State : in out Menu_State) is
      Current : Menu_Item_ID := State.Selected_Item;
   begin
      for Step in 1 .. 8 loop
         Current := (if Current = Menu_Item_ID'First then Menu_Item_ID'Last else Menu_Item_ID'Pred (Current));
         if Is_Item_Enabled (State, Current) then
            State.Selected_Item := Current;
            return;
         end if;
      end loop;
   end Select_Prev;

   function Get_Item_Label (Item : Menu_Item_ID) return String is
     (case Item is
         when Item_New_Game  => "1. NOWA GRA",
         when Item_Continue  => "2. KONTYNUUJ",
         when Item_Save_Game => "3. ZAPISZ GRE",
         when Item_Load_Game => "4. WCZYTAJ GRE",
         when Item_Settings  => "5. USTAWIENIA",
         when Item_Help      => "6. POMOC / STEROWANIE",
         when Item_About     => "7. O GRZE",
         when Item_Quit      => "8. WYJSCIE");

end Gabyx.UI.Menu;
