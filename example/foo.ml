open Tap;;

test "foo" (fun _ ->

  test "nested" (fun _ ->
    equal 42 42;
    throws Not_found (fun () -> raise Not_found);
  );

  skip "skipped" (fun _ ->
    fail ();
  );

);
