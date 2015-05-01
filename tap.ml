let _ = print_endline "TAP version 13"

let test (name:string) (fn:unit -> unit) =
  let _ = Printf.printf "# %s\n" name in
  fn ()

let skip (_:string) (_:unit -> unit) =
  ()

let has_failure = ref false

let result =
  let count = ref 0 in
  fun (is_ok:bool) (msg:string) ->
    let _ = incr count in
    let is_ok =
      if is_ok then
        "ok"
      else
        let _ = has_failure := true in
        "not ok" in
    print_endline (String.trim (Printf.sprintf ("%s %d %s") is_ok !count msg))

let has_exited = ref false

let _ = at_exit (fun x ->
  if !has_exited then
    ()
  else
    let _ = has_exited := true in
    let _ = exit (if !has_failure then 1 else 0) in
    ()
)

let ok ?(msg="ok") x =
  result (x = true) msg

let not_ok ?(msg="not ok") x =
  result (x = false) msg

let equal ?(msg="equal") x y =
  result (x = y) msg

let not_equal ?(msg="not equal") x y =
  result (x <> y) msg

let same ?(msg="same") x y =
  result (x == y) msg

let not_same ?(msg="not same") x y =
  result (x != y) msg

let fail ?(msg="fail") () =
  result false msg

exception Not_ok

let throws ?(msg="throws") (expected_exn:exn) (fn:unit -> 'a) =
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

let does_not_throw ?(msg="does not throw") (fn:unit -> 'a) =
  try
    let _ = fn () in
    result true msg
  with _ ->
    result false msg
