open Tap;;

let suite t =

  t.test "foo" (fun () ->

    t.test "nested" (fun () ->
      let x = ref 1 in
      let y = ref 1 in
      t.comment "comment";
      t.ok true;
      t.not_ok false;
      t.equal 42 42;
      t.not_equal 42 0;
      t.same x x;
      t.not_same x y;
      t.throws Not_found (fun () -> raise Not_found);
      t.does_not_throw (fun () -> ());
    );

    skip "skipped" (fun () ->
      fail ();
    );

  );
