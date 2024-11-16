import Batteries.Data.RBMap.Basic
import Batteries.Data.String.Basic
import localDep
@[export my_min]
def my_min (x y z: USize) : USize :=
  let map : Batteries.RBSet USize compare := Batteries.RBSet.ofList [x,y,z] _
  (map.toList.head!)

@[export my_add]
def my_add (x y: USize) : USize :=
  x + y

@[export my_concat]
def my_concat (s1 s2: String) : String :=
  s1 ++ s2


@[export my_count]
def my_count (s: String) (c:Char): USize :=
  String.count s c |>.toUSize


def my_monad_helper : IO String := do
  return "Hello from my_monad_helper!"


@[export my_monad]
def my_monad (x:UInt32): IO UInt32 := do
  let help ← my_monad_helper
  IO.println s!"Hello from my_monad! Also {help}"
  return x

@[export my_local]
def my_local (s:String): String :=
  s!"{hello}, {s}!"

partial def factorial_helper (n: UInt64) (acc: UInt64): UInt64 :=
  if n == 0 then acc
  else factorial_helper (n-1) (n*acc)

@[export my_factorial]
def my_factorial (n:UInt64): UInt64 := factorial_helper n 1


def main : IO Unit := do
  let result := my_factorial 20
  IO.println s!"Factorial of 20 is {result}"
