open Tap

let suite t = (

  t.skip "skip" (fun () ->
    t.fail ();
  );

  t.test "test" (fun () ->
    t.pass ();
  );

)

let _ = run [suite]
