open Tap;;

let suite t =

  t.test "bar" (fun () ->

    t.fail ();

  );
