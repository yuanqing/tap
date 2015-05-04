open Tap

let suite t =

  t.test "foo" (fun () ->

    t.test "nested" (fun () ->
      let x = ref 1 in
      let y = ref 1 in
      t.ok true;
      t.not_ok false;
      t.equal 42 42;
      t.not_equal 42 0;
      t.comment "comment";
      t.same x x;
      t.not_same x y;
      t.throws Not_found (fun () -> raise Not_found);
      t.does_not_throw (fun () -> ());
    );

    t.skip "skipped" (fun () ->
      t.fail ();
    );

  );
