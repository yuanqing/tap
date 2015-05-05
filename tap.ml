type tap_output =
  | Result of bool * string
  | Comment of string

let tap_output : tap_output Queue.t = Queue.create ()

let log_result (is_ok:bool) (msg:string) : unit =
  Queue.add (Result (is_ok, msg)) tap_output

let log_comment (msg:string) : unit =
  Queue.add (Comment msg) tap_output

let test name fn =
  let _ = log_comment name in
  fn ()

let skip _ _ =
  ()

let comment msg =
  log_comment msg

let ok ?(msg="ok") x =
  log_result (x = true) msg

let not_ok ?(msg="not ok") x =
  log_result (x = false) msg

let equal ?(msg="equal") x y =
  log_result (x = y) msg

let not_equal ?(msg="not equal") x y =
  log_result (x <> y) msg

let same ?(msg="same") x y =
  log_result (x == y) msg

let not_same ?(msg="not same") x y =
  log_result (x != y) msg

let pass ?(msg="pass") () =
  log_result true msg

let fail ?(msg="fail") () =
  log_result false msg

exception Not_ok

let throws ?(msg="throws") expected_exn fn =
  try
    let _ = fn () in
    raise Not_ok
  with
    | Not_ok ->
      log_result false msg
    | actual_exn when expected_exn <> actual_exn ->
      log_result false msg
    | _ ->
      log_result true msg

let does_not_throw ?(msg="does not throw") fn =
  try
    let _ = fn () in
    log_result true msg
  with
    | _ ->
      log_result false msg

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

let run_suite (fd_out:Unix.file_descr) (i:int) (suite:t -> unit) : unit =

  (* Create an output channel that writes to `fd_out`. *)
  let ochan = Unix.out_channel_of_descr fd_out in

  (* Run the tests. *)
  let _ = suite t in

  (* Convert the TAP output queue into a list. *)
  let tap_output : tap_output list = Queue.fold (fun acc x -> x::acc) []
    tap_output in

  (* Pipe the list to the main process. *)
  let tap_output = List.rev tap_output in
  Marshal.to_channel ochan (i, tap_output) []

let read_tap_output (fd_in:Unix.file_descr) (suites:(t -> unit) list)
  : tap_output list =

  (* Create an input channel that reads from `fd_in`. *)
  let ichan = Unix.in_channel_of_descr fd_in in

  (* Accumulate the TAP output from `ichan` into a list. *)
  let f acc _ =
    (Marshal.from_channel ichan)::acc in
  let tap_output : (int * tap_output list) list = List.fold_left f [] suites in

  (* Call `wait` on each child process. *)
  let f _ =
    let _ = Unix.wait () in
    () in
  let _ = List.iter f suites in

  (* Sort the TAP output by their original order. *)
  let compare (i, _) (j, _) =
    if i < j then (-1) else 1 in
  let tap_output = List.fast_sort compare tap_output in

  (* Splice out the TAP output, and concatenate the list of lists. *)
  List.split tap_output |> snd |> List.concat

let print_tap_output (tap_output:tap_output list) : unit =

  (* Print the TAP version. *)
  let _ = print_endline "TAP version 13" in

  (* Iterate over and print `tap_output`, while also updating the counts for
  `num_test` and `num_fail`. *)
  let num_test = ref 0 in
  let num_fail = ref 0 in
  let f x =
    let str =
      match x with
        | Result (is_ok, msg) ->
          let _ = incr num_test in
          let is_ok =
            if is_ok then
              "ok"
            else
              let _ = incr num_fail in
              "not ok" in
          Printf.sprintf "%s %d %s\n" is_ok !num_test msg
        | Comment str ->
          Printf.sprintf "# %s\n" str in
    print_endline (String.trim str) in
  let _ = List.iter f tap_output in

  (* Print the summary. *)
  let num_test = !num_test in
  let num_fail = !num_fail in
  let _ = Printf.printf ("1..%d\n") num_test in
  let _ = Printf.printf ("# test %d\n") num_test in
  let _ = Printf.printf ("# pass %d\n") (num_test - num_fail) in
  let _ = Printf.printf ("# fail %d\n") num_fail in

  (* Exit with code 0 if no failures, else exit with code 1. *)
  let _ = exit (if num_fail = 0 then 0 else 1) in
  ()

let run (suites:(t -> unit) list) : unit =

  (* Create a pipe with `fd_in` and `fd_out` for sending TAP output from
  each child processes (ie. each test suite in `suites`) to the main
  process (ie. the current process). *)
  let fd_in, fd_out = Unix.pipe () in

  (* Fork a new process for each test suite, run the test suite, and exit. *)
  let _ = List.iteri (fun i suite ->
    match Unix.fork () with
      | 0 ->
        let () = Unix.close fd_in in
        let () = run_suite fd_out i suite in
        exit 0
      | _ ->
        ()
  ) suites in

  (* In the main process, read the TAP output from each test suite, and
  print it to `stdout`. *)
  let () = Unix.close fd_out in
  let tap_output = read_tap_output fd_in suites in
  print_tap_output tap_output
