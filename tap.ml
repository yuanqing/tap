let num_test = ref 0
let num_fail = ref 0
let results : string Queue.t = Queue.create ()

let test (name:string) (fn:unit -> unit) =
  let _ = Queue.add (Printf.sprintf "# %s" name) results in
  fn ()

let skip (_:string) (_:unit -> unit) =
  ()

let result (is_ok:bool) (msg:string) : unit =
  let r =
    if is_ok then
      "ok"
    else
      let _ = incr num_fail in
      "not ok" in
  let _ = incr num_test in
  let result = String.trim (Printf.sprintf ("%s %s") r msg) in
  Queue.add result results

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

let pass ?(msg="pass") () =
  result true msg

let fail ?(msg="fail") () =
  result false msg

let comment msg =
  Queue.add ("# " ^ msg) results

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
  with
    | _ ->
      result false msg

type t = {
  test: string -> (unit -> unit) -> unit;
  skip: string -> (unit -> unit) -> unit;
  comment: string -> unit;
  ok: ?msg:string -> bool -> unit;
  not_ok: ?msg:string -> bool -> unit;
  equal: 'a. ?msg:string -> 'a -> 'a -> unit;
  not_equal: 'a. ?msg:string -> 'a -> 'a -> unit;
  same: 'a. ?msg:string -> 'a -> 'a -> unit;
  not_same: 'a. ?msg:string -> 'a -> 'a -> unit;
  pass: ?msg:string -> unit -> unit;
  fail: ?msg:string -> unit -> unit;
  throws: 'a. ?msg:string -> exn -> (unit -> 'a) -> unit;
  does_not_throw: 'a. ?msg:string -> (unit -> 'a) -> unit;
}

let t : t = {
  test;
  skip;
  comment;
  ok;
  not_ok;
  equal;
  not_equal;
  same;
  not_same;
  pass;
  fail;
  throws;
  does_not_throw;
}

let run (suites:(t -> unit) list) =

  let _ = print_endline "TAP version 13" in
  let fd_in, fd_out = Unix.pipe () in
  let _ = List.iteri (fun i suite ->
    match Unix.fork () with
      | 0 ->
        let () = Unix.close fd_in in
        let ochan = Unix.out_channel_of_descr fd_out in
        let _ = suite t in
        let results : string list = Queue.fold (fun acc x -> x::acc) [] results in
        let () = Marshal.to_channel ochan (i, (!num_test, !num_fail, results)) [] in
        exit 0
      | _ -> ()
  ) suites in

  (* close the `fd_out` end of the pipe *)
  let () = Unix.close fd_out in

  (* read results from `ichan` *)
  let ichan = Unix.in_channel_of_descr fd_in in
  let results : (int * (int * int * (string list))) list = List.fold_left (fun acc _ ->
    (Marshal.from_channel ichan)::acc
  ) [] suites in

  (* wait for each child process to end *)
  let _ = List.iter (fun _ ->
    ignore (Unix.wait ())
  ) suites in

  (* return results sorted based on their index in `xs` *)
  let compare (i, _) (j, _) =
    if i < j then (-1) else 1 in
  let results = List.fast_sort compare results in
  let results = List.split results in
  let r = snd results in

  let _ = List.iter (fun (_, _, r) ->
    List.iter (fun x ->
      print_endline x
    ) (List.rev r)
  ) r in

  let num_test, num_fail = List.fold_left (fun acc (num_test, num_fail, _) ->
    ((fst acc) + num_test, (snd acc) + num_fail)
  ) (0, 0) r in

  let _ = Printf.printf ("1..%d\n") num_test in
  let _ = Printf.printf ("# tests %d\n") num_test in
  let _ = Printf.printf ("# pass  %d\n") (num_test - num_fail) in
  let _ = Printf.printf ("# fail  %d\n") num_fail in

  ()
