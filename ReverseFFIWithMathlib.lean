import Batteries.Data.RBMap.Basic
import Batteries.Data.String.Basic

@[export my_min]
def my_min (x y z: USize) : Float :=
  let map : Batteries.RBSet USize compare := Batteries.RBSet.ofList [x,y,z] _
  (map.toList.head!).toUInt64.toFloat

@[export my_add]
def my_add (x y: USize) : USize :=
  x + y

@[export my_concat]
def my_concat (s1 s2: String) : String :=
  s1 ++ s2


@[export my_count]
def my_count (s: String) (c:Char): USize :=
  String.count s c |>.toUSize

@[export my_monad]
def my_monad (x:USize): IO USize := do
  IO.println "Hello from my_monad!"
  return x
