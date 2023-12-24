use std::{
    fs::File,
    io::{prelude::*, BufReader},
    path::Path,
};


fn main(){
    let values = lines_from_file("AoC1.txt");
    let mut sum_of_all: i32 = 0;
    for val in values{
        sum_of_all = sum_of_all + first_and_last1(val);
    }
    println!("Aufgabe 1: {}", sum_of_all);
    let values2 = lines_from_file("AoC1.txt");
    let mut sum_of_all: i32 = 0;
    for val in values2{
        sum_of_all = sum_of_all + first_and_last2(val);
    }
    println!("Aufgabe 2: {}", sum_of_all);
    /* 
    let values3 = lines_from_file("AoC1.txt");
    let mut sum_of_all: i32 = 0;
    for val in values3{
        sum_of_all = sum_of_all + first_and_last2_upgrade(val);
    }
    println!("Aufgabe 2: {}", sum_of_all);
    */
}

fn first_and_last1(s: String) -> i32{
    let t: String = s.chars().filter(|c| c.is_digit(10)).collect();
    if t.len() == 0{
        return 0
    }
    let number1 = t.chars().next().unwrap();
    let mut total_string = String::from(number1);
    let number2 = t.chars().nth(t.len()-1).unwrap();
    total_string.push(number2);
    let output: i32 = total_string.parse().unwrap();
    return output;
}

fn first_and_last2(s: String) -> i32{
    // Damit Überlappungen nicht zum Problem werden (eightwo)
    let noword = s.replace("one", "one1one").replace("two","two2two").replace("three","three3three").replace("four","four4four").replace("five","five5five").replace("six","six6six").replace("seven","seven7seven").replace("eight","eight8eight").replace("nine","nine9nine");
    let t: String = noword.chars().filter(|c| c.is_digit(10)).collect();
    if t.len() == 0{
        return 0
    }
    let number1 = t.chars().next().unwrap();
    let mut total_string = String::from(number1);
    let number2 = t.chars().nth(t.len()-1).unwrap();
    total_string.push(number2);
    let output: i32 = total_string.parse().unwrap();
    return output;
}

fn first_and_last2_upgrade(s: String) -> i32{
    // Läuft etwas schneller, da die Strings nicht unnötig in die Länge gezogen werden
    let noword = s.replace("one", "o1e").replace("two","t2o").replace("three","t3e").replace("four","4").replace("five","5e").replace("six","6").replace("seven","7n").replace("eight","e8t").replace("nine","n9e");
    let t: String = noword.chars().filter(|c| c.is_digit(10)).collect();
    if t.len() == 0{
        return 0
    }
    let number1 = t.chars().next().unwrap();
    let mut total_string = String::from(number1);
    let number2 = t.chars().nth(t.len()-1).unwrap();
    total_string.push(number2);
    let output: i32 = total_string.parse().unwrap();
    return output;
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
