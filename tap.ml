exception Not_ok

let result =
  let count = ref 0 in
  fun (is_ok:bool) (msg:string) ->
    let _ = incr count in
    let _ = print_string (if is_ok then "ok" else "not ok") in
    print_endline (" " ^ (string_of_int !count) ^ " " ^ msg)

type t = {
  equal: 'a. ?msg:string -> 'a -> 'a -> unit;
  not_equal: 'a. ?msg:string -> 'a -> 'a -> unit;
  fail: 'a. ?msg:string -> unit -> unit;
  throws: 'a. ?msg:string -> exn -> (unit -> 'a) -> unit;
}

let t = {
  equal = (fun ?(msg="equal") x y ->
    result (x = y) msg
  );
  not_equal = (fun ?(msg="not equal") x y ->
    result (x <> y) msg
  );
  fail = (fun ?(msg="not equal") () ->
    result false msg
  );
  throws = (fun ?(msg="throws") expected_exn fn ->
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
  );
}

let test (name:string) (fn:'a -> unit) =
  let _ = print_endline ("# " ^ name) in
  fn t
