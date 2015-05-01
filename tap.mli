val equal : ?msg:string -> 'a -> 'a -> unit
val not_equal : ?msg:string -> 'a -> 'a -> unit
val fail : ?msg:string -> unit -> unit
val throws : ?msg:string -> exn -> (unit -> 'a) -> unit
val skip : 'a -> 'b -> unit
val test : string -> (unit -> unit) -> unit
