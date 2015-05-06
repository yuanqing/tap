type t = {
  test : string -> (unit -> unit) -> unit;
  skip : string -> (unit -> unit) -> unit;
  ok : ?msg:string -> bool -> unit;
  not_ok : ?msg:string -> bool -> unit;
  equal : 'a. ?msg:string -> 'a -> 'a -> unit;
  not_equal : 'a. ?msg:string -> 'a -> 'a -> unit;
  same : 'a. ?msg:string -> 'a -> 'a -> unit;
  not_same : 'a. ?msg:string -> 'a -> 'a -> unit;
  throws : 'a. ?msg:string -> exn -> (unit -> 'a) -> unit;
  does_not_throw : 'a. ?msg:string -> (unit -> 'a) -> unit;
  comment : string -> unit;
  pass : ?msg:string -> unit -> unit;
  fail : ?msg:string -> unit -> unit;
}
val run : (t -> unit) list -> unit
