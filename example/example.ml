open Tap

let suite t = (

  t.test "test" (fun () ->
    t.not_ok true;
    t.not_ok false;
    t.equal 42 42;
    t.not_equal 42 0;
    let x = ref 42 in
    let y = ref 42 in
    t.same x x;
    t.not_same x y;
    t.throws Not_found (fun () -> raise Not_found);
    t.does_not_throw (fun () -> ());
  );

  t.skip "skip" (fun () ->
    t.pass ();
    t.fail ();
  );

)

let _ = Tap.run [suite]
