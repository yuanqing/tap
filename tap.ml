exception Not_ok

let test (name:string) (fn:unit -> unit) =
  let _ = print_endline ("# " ^ name) in
  fn ()

let result =
  let count = ref 0 in
  fun (is_ok:bool) (msg:string) ->
    let _ = incr count in
    let _ = print_string (if is_ok then "ok" else "not ok") in
    print_endline (" " ^ (string_of_int !count) ^ " " ^ msg)

let equal ?msg:(msg="equal") (x:'a) (y:'a) =
  result (x = y) msg

let not_equal ?msg:(msg="not equal") (x:'a) (y:'a) =
  result (x <> y) msg

let throws ?msg:(msg="throws") (expected_exn:exn) (fn:unit -> 'a) =
  try
    let _ = fn () in
    raise Not_ok
  with
    | Not_ok ->
      result false msg
    | actual_exn when expected_exn <> actual_exn ->
      result false msg
    | _ ->
      result true msg
