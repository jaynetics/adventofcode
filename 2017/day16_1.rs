// this only works with rust nightly build
// $ rustc -O day16_1.rs && ./day16_1

#![feature(slice_rotate)]

fn main() {
    let mut programs = ["a", "b", "c", "d", "e", "f", "g", "h",
                        "i", "j", "k", "l", "m", "n", "o", "p"];

    for instr in input().split(",").collect::<Vec<_>>() {
        let kind = &instr[0..1];
        let data = &instr[1..instr.len()].split("/").collect::<Vec<_>>();
        match kind.as_ref() {
            "s" => rotate(&mut programs, &data),
            "p" => swap_by_name(&mut programs, &data),
            "x" => swap_by_index(&mut programs, &data),
            _   => println!("unknown instruction '{}'", instr),
        }
    }

    println!("The result is: {}", programs.join(""));
}

fn rotate(programs: &mut [&str], data: &Vec<&str>) {
    programs.reverse();
    programs.rotate(data[0].parse::<usize>().unwrap());
    programs.reverse();
}

fn swap_by_index(programs: &mut [&str], data: &Vec<&str>) {
    let a = data[0].parse::<usize>().unwrap();
    let b = data[1].parse::<usize>().unwrap();
    programs.swap(a, b);
}

fn swap_by_name(programs: &mut [&str], data: &Vec<&str>) {
    let a = programs.iter().position(|&r| r == data[0]).unwrap();
    let b = programs.iter().position(|&r| r == data[1]).unwrap();
    programs.swap(a, b);
}

fn input() -> &'static str {
    "... paste input here ..."
}
