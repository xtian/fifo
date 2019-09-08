extern crate nix;
#[macro_use]
extern crate rustler;

use nix::{
    fcntl::{self, OFlag},
    sys::stat::Mode,
};

use rustler::{Encoder, Env, Error, Term};
use std::error::Error as _;

mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;
    }
}

rustler::rustler_export_nifs! {
    "Elixir.Fifo.Native",
    [
        ("open_file_readonly", 1, open_file_readonly),
        ("open_file_writeonly", 1, open_file_writeonly)
    ],
    None
}

fn open_file_readonly<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    do_open(env, args, OFlag::O_RDONLY)
}

fn open_file_writeonly<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    do_open(env, args, OFlag::O_WRONLY)
}

fn do_open<'a>(env: Env<'a>, args: &[Term<'a>], flag: OFlag) -> Result<Term<'a>, Error> {
    let path: String = args[0].decode()?;
    let flags = OFlag::O_NONBLOCK | flag;

    fcntl::open(path.as_str(), flags, Mode::empty())
        .map({ |fd| (atoms::ok(), fd).encode(env) })
        .or_else({ |err| Ok((atoms::error(), err.description()).encode(env)) })
}
