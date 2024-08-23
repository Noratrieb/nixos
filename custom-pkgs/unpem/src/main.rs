use std::{
    error::Error,
    io::{BufReader, Read, Write},
};

use clap::Parser;

#[derive(clap::Parser)]
struct Args {
    file: Option<String>,
}

fn main() -> Result<(), Box<dyn Error>> {
    let args = Args::parse();

    match args.file {
        None => unpem(&mut std::io::stdin().lock()),
        Some(file) => {
            let file = std::fs::File::open(file)?;
            let mut file = BufReader::new(file);
            unpem(&mut file)
        }
    }
}

fn unpem(input: &mut dyn Read) -> Result<(), Box<dyn Error>> {
    let mut v = Vec::new();
    input.read_to_end(&mut v)?;
    let pem = pem::parse(v)?;

    std::io::stdout().write_all(pem.contents())?;

    Ok(())
}
