open Tap

let suite t = (

  let x = ref true in
  let y = ref true in

  t.test "pass" (fun () ->
    t.pass ();
  );

  t.test "fail" (fun () ->
    t.fail ();
  );

  t.test "ok" (fun () ->
    t.ok true;
    t.ok false;
  );

  t.test "not ok" (fun () ->
    t.not_ok false;
    t.not_ok true;
  );

  t.test "equal" (fun () ->
    t.equal true true;
    t.equal true false;
  );

  t.test "not equal" (fun () ->
    t.not_equal true false;
    t.not_equal true true;
  );

  t.test "same" (fun () ->
    t.same x x;
    t.same x y;
  );

  t.test "not same" (fun () ->
    t.not_same x y;
    t.not_same x x;
  );

  t.test "throws" (fun () ->
    t.throws Not_found (fun () -> raise Not_found);
    t.throws Not_found (fun () -> failwith "foo");
  );

  t.test "does not throw" (fun () ->
    t.does_not_throw (fun () -> ());
    t.does_not_throw (fun () -> raise Not_found);
  );

  t.test "comment" (fun () ->
    t.comment "comment";
  );

)

let _ = run [suite]
