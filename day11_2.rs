// $ rustc -O day11_2.rs && ./day11_2

const ORDERED_DIRECTIONS: [&'static str; 6] = ["n", "ne", "se", "s", "sw", "nw"];

fn main() {
    let instructions = &input().split(",").collect::<Vec<_>>();

    let mut max = 0;

    for i in 0..(instructions.len()) {
        let current_instructions = &instructions[0..(i+1)];
        let optimized_count = optimized_instructions(current_instructions).len();
        if optimized_count > max { max = optimized_count; }
    }

    println!("Max distance is {}", max);
}

use std::collections::HashMap;

fn optimized_instructions<'a>(instructions: &[&str]) -> Vec<&'a str> {
    let mut counts: HashMap<&str, u32> = HashMap::new();

    for instr in instructions.iter() {
        *counts.entry(instr).or_insert(0) += 1;
    }

    let mut optimized: Vec<&str> = Vec::with_capacity(instructions.len());

    fn looped_index(index: usize) -> usize { index % 6 }

    // cancel opposite moves
    for (i, &dir) in ORDERED_DIRECTIONS[0..3].iter().enumerate() {
        let opposite = ORDERED_DIRECTIONS[looped_index(i + 3)];
        loop {
            let dir_count = *counts.entry(dir).or_insert(0);
            let opp_count = *counts.entry(opposite).or_insert(0);
            if dir_count == 0 || opp_count == 0 { break; }
            *counts.get_mut(dir).unwrap() -= 1;
            *counts.get_mut(opposite).unwrap() -= 1;
        }
    }

    // join reconcilable moves
    for (i, &dir) in ORDERED_DIRECTIONS.iter().enumerate() {
        let joinable = ORDERED_DIRECTIONS[looped_index(i + 2)];
        let join_dir = ORDERED_DIRECTIONS[looped_index(i + 1)];
        loop {
            let dir_count = *counts.entry(dir).or_insert(0);
            let jbd_count = *counts.entry(joinable).or_insert(0);
            if dir_count == 0 || jbd_count == 0 { break; }
            else {
                optimized.push(join_dir);
                *counts.get_mut(dir).unwrap() -= 1;
                *counts.get_mut(joinable).unwrap() -= 1;
            }
        }
    }

    // add rest
    for &dir in ORDERED_DIRECTIONS.iter() {
        for _ in 0..*counts.entry(dir).or_insert(0) {
            optimized.push(dir);
        }
    }

    optimized
}

fn input() -> &'static str {
    "... paste input here ..."
}
