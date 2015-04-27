open Tap;;

test "example" (fun _ ->

  equal 42 42;
  not_equal 42 0;
  throws Not_found (fun _ -> raise Not_found);

);
