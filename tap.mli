val test : string -> (unit -> unit) -> unit
val skip : string -> (unit -> unit) -> unit
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
