use std::{
    fs::File,
    io::{prelude::*, BufReader},
    path::Path,
};


use std::cmp;


fn main() {
    let line_vec = lines_from_file("AoC4.txt");
    let mut count:i32 = 0;
    for line in line_vec{
        count = get_numbers(&line) + count;
    }
    println!("Exercise 1: {}", count);
    let line_vec = lines_from_file("AoC4.txt");
    let mut vec: Vec<i32> = Vec::new();
    for i in 0..line_vec.len(){
        vec.push(1);
    }
    let mut player = 0;
    let mut count2:i32 = 0;
    for line in line_vec{
        let cur_win = get_numbers2(&line);
        for _i in 0..vec[player]{
            vec = calc_bonus(vec, cur_win.1 as usize, player as usize);
        }
        player = player + 1;
    }
    let sum: i32 = vec.iter().sum();
    println!("Exercise 2: {}", sum);
}


fn get_numbers(line: &String) -> i32{
    let mut first_split = line.split(':');
    let mut helpmestr = first_split.nth(1).unwrap();
    helpmestr.to_string().pop();
    let mut second_split = helpmestr.split('|');
    let mut win_list: Vec<&str> = second_split.next().unwrap().split(" ").collect();
    win_list.retain(|&x| x.len() > 0);
    let doesthiswork: &Vec<&str> = &win_list;
    let mut drawn_list: Vec<&str> = second_split.next().unwrap().split(" ").collect();
    drawn_list.retain(|&x| x.len() > 0);
    let mut doesthisworktoo: &Vec<&str> = &drawn_list;
    let mut another_vectortoo: Vec<String> = Vec::new();
    for elem in doesthisworktoo{
        let mut element = elem.to_string();
        let better_str = trim_newline(element);
        another_vectortoo.push(better_str)
    }
    let mut another_vector: Vec<String> = Vec::new();
    for elem in doesthiswork{
        let mut element = elem.to_string();
        let better_str = trim_newline(element);
        another_vector.push(better_str)
    }
    let mut counter = 0;
    for elem in another_vector{
        if another_vectortoo.contains(&elem){
            if counter == 0{
                counter = 1
            }
            else{
                counter = counter * 2
            }
        }
    }
    return counter
}

fn trim_newline(t: String) -> String{
    let mut s = t;
    while s.ends_with('\n') || s.ends_with('\r') {
        s.pop();
    }
    return s;
}


fn calc_bonus(bonus_vec: Vec<i32>, count: usize, cur_num: usize) -> Vec<i32>{
    let mut bonus = bonus_vec;
    for i in cur_num+1..cmp::min(cur_num+count+1, bonus.len()){
        bonus[i] = bonus[i] +1
    }
    bonus
}


fn lines_from_file(filename: &str) -> Vec<String> {
    let mut file = match File::open(filename) {
        Ok(file) => file,
        Err(_) => panic!("no such file"),
    };
    let mut file_contents = String::new();
    file.read_to_string(&mut file_contents)
        .ok()
        .expect("failed to read!");
    let lines: Vec<String> = file_contents.split("\n")
        .map(|s: &str| s.to_string())
        .collect();
    lines
}


fn get_numbers2(line: &String) -> (i32, i32){
    let mut first_split = line.split(':');
    let mut helpmestr = first_split.nth(1).unwrap();
    helpmestr.to_string().pop();
    let mut second_split = helpmestr.split('|');
    let mut win_list: Vec<&str> = second_split.next().unwrap().split(" ").collect();
    win_list.retain(|&x| x.len() > 0);
    let doesthiswork: &Vec<&str> = &win_list;
    let mut drawn_list: Vec<&str> = second_split.next().unwrap().split(" ").collect();
    drawn_list.retain(|&x| x.len() > 0);
    let mut doesthisworktoo: &Vec<&str> = &drawn_list;
    let mut another_vectortoo: Vec<String> = Vec::new();
    for elem in doesthisworktoo{
        let mut element = elem.to_string();
        let better_str = trim_newline(element);
        another_vectortoo.push(better_str)
    }
    let mut another_vector: Vec<String> = Vec::new();
    for elem in doesthiswork{
        let mut element = elem.to_string();
        let better_str = trim_newline(element);
        another_vector.push(better_str)
    }
    let mut counter = 0;
    let mut counter2 = 0;
    for elem in another_vector{
        if another_vectortoo.contains(&elem){
            counter2 = counter2+1;
            if counter == 0{
                counter = 1
            }
            else{
                counter = counter * 2
            }
        }
    }
    return (counter, counter2)
}
