-- / A Lib module
module DataDefinitions
where
-- Data Definitions
data Named_Value =
   String_Value String String
   | Integer_Value String Int
  deriving(Eq,Show)
--data Type_Variable =
--  Predicate (String)
--  | Input (String)
--  deriving(Eq,Show)
data Missing_Vars =
  Missing_Vars [String]
  deriving(Eq,Show)
data Available_Vars =
  Available_Vars [String]
  deriving(Eq,Show)
--data Function =
--  Function ([Type_Variable],Type_Variable, Execution->Execution)
--  deriving(Show)
--data Compilation =
--  Compilation (Available_Vars,Missing_Vars)--,[Function])
--  deriving(Show)
--data Execution =
--  Execution [Named_Value]
--  deriving(Show)
data EDRL_File =
  EDRL_File String String
  deriving(Eq,Show)
data Event =
  Add_File EDRL_File
  | Start_Execution EDRL_File
  | Read_Output
  | Trigger_Event Named_Value
  deriving(Eq,Show)
data State =
  Empty_State   --finally my own State !!
  | Filled_State Missing_Vars Available_Vars
  deriving(Eq,Show)
