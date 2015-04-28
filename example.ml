open Tap;;

test "example" (fun t ->

  t.equal 42 42;
  t.not_equal 42 0;
  t.throws Not_found (fun () -> raise Not_found);

);
