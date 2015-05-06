# tap [![Version](https://img.shields.io/badge/version-v0.1.0-orange.svg?style=flat)](https://github.com/yuanqing/tap/releases) [![Build Status](https://img.shields.io/travis/yuanqing/tap.svg?branch=master&style=flat)](https://travis-ci.org/yuanqing/tap)

> A simple, [TAP](http://testanything.org/)-compliant test harness for OCaml.

## Usage

Given the following [`example.ml`](https://github.com/yuanqing/tap/blob/master/example/example.ml):

```ocaml
open Tap

let suite t = (

  t.test "test" (fun () ->
    t.ok true;
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
```

To compile and run, do:

```
$ ocamlfind ocamlc -package tap -linkpkg example.ml -o example.byte
$ ./example.byte
TAP version 13
# test
ok 1 ok
ok 2 not ok
ok 3 equal
ok 4 not equal
ok 5 same
ok 6 not same
ok 7 throws
ok 8 does not throw
1..8
# test 8
# pass 8
# fail 0
```

(We can also compile using the `ocamlopt` native-code compiler; see [the example Makefile](https://github.com/yuanqing/tap/blob/master/example/Makefile).)

The test run exits with code 0 if and only if every test passed:

```
$ echo $?
0
```

## API

```ocaml
type t = {
  test : string -> (unit -> unit) -> unit;
  skip : string -> (unit -> unit) -> unit;
  ok : ?msg:string -> bool -> unit;
  not_ok : ?msg:string -> bool -> unit;
  equal : 'a. ?msg:string -> 'a -> 'a -> unit;
  not_equal : 'a. ?msg:string -> 'a -> 'a -> unit;
  same : 'a. ?msg:string -> 'a -> 'a -> unit;
  not_same : 'a. ?msg:string -> 'a -> 'a -> unit;
  throws : 'a. ?msg:string -> exn -> (unit -> 'a) -> unit;
  does_not_throw : 'a. ?msg:string -> (unit -> 'a) -> unit;
  comment : string -> unit;
  pass : ?msg:string -> unit -> unit;
  fail : ?msg:string -> unit -> unit;
}
val run : (t -> unit) list -> unit
```

## Installation

First, install [ocamlfind](https://opam.ocaml.org/packages/ocamlfind/ocamlfind.1.5.5/) with [OPAM](https://opam.ocaml.org):

```
$ opam install ocamlfind
```

Then do:

```
$ git clone https://github.com/yuanqing/tap
$ cd tap
$ make install
```

## License

[MIT](https://github.com/yuanqing/tap/blob/master/LICENSE)
