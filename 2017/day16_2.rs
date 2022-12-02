// this only works with rust nightly build
// $ rustc -O day16_2.rs && ./day16_2

#![feature(slice_rotate)]

fn main() {
    let initial = ["a", "b", "c", "d", "e", "f", "g", "h",
                   "i", "j", "k", "l", "m", "n", "o", "p"];
    let mut programs = initial;

    let total_rounds = 1000000000;
    let mut todo = total_rounds;

    loop {
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

        todo -= 1;
        if todo == 0 { break; }
        else if programs == initial {
            let rounds_done = total_rounds - todo;
            todo = total_rounds % rounds_done;
            println!("Back to initial state after {:?} rounds, doing {:?} more to simulate {:?}.",
                     rounds_done, todo, total_rounds);
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
