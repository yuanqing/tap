type t = {
  test : string -> (unit -> unit) -> unit;
  skip : string -> (unit -> unit) -> unit;
  comment : string -> unit;
  ok : ?msg:string -> bool -> unit;
  not_ok : ?msg:string -> bool -> unit;
  equal : 'a. ?msg:string -> 'a -> 'a -> unit;
  not_equal : 'a. ?msg:string -> 'a -> 'a -> unit;
  same : 'a. ?msg:string -> 'a -> 'a -> unit;
  not_same : 'a. ?msg:string -> 'a -> 'a -> unit;
  pass : ?msg:string -> unit -> unit;
  fail : ?msg:string -> unit -> unit;
  throws : 'a. ?msg:string -> exn -> (unit -> 'a) -> unit;
  does_not_throw : 'a. ?msg:string -> (unit -> 'a) -> unit;
}

val test : string -> (unit -> unit) -> unit
val skip : string -> (unit -> unit) -> unit
val comment : string -> unit
val ok : ?msg:string -> bool -> unit
val not_ok : ?msg:string -> bool -> unit
val equal : ?msg:string -> 'a -> 'a -> unit
val not_equal : ?msg:string -> 'a -> 'a -> unit
val same : ?msg:string -> 'a -> 'a -> unit
val not_same : ?msg:string -> 'a -> 'a -> unit
val pass : ?msg:string -> unit -> unit
val fail : ?msg:string -> unit -> unit
val throws : ?msg:string -> exn -> (unit -> 'a) -> unit
val does_not_throw : ?msg:string -> (unit -> 'a) -> unit

val run : (t -> unit) list -> unit
