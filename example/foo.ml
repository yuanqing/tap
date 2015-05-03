open Tap;;

let suite () =

  test "foo" (fun () ->

    test "nested" (fun () ->
      let x = ref 1 in
      let y = ref 1 in
      ok true;
      not_ok false;
      equal 42 42;
      not_equal 42 0;
      same x x;
      not_same x y;
      throws Not_found (fun () -> raise Not_found);
      does_not_throw (fun () -> ());
    );

    skip "skipped" (fun () ->
      fail ();
    );

  );
