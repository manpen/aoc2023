use std::{
    fs::File,
    io::{prelude::*, BufReader},
    path::Path,
};

fn main(){
    exercise1();
    exercise2()
}

fn exercise1() {
    let values = lines_from_file("AoC2.txt");
    let mut game_number: i32 = 0;
    let mut wrong_games: i32 = 0;
    for game in values{
        game_number = game_number+1;
        let mut parts = game.split(":");
        let mut false_already = false;
        let helpme = parts.nth(1);
        if helpme.is_some(){
            let draws = helpme.unwrap().split(";");
            for draw in draws{
                let colors = draw.split(",");
                for color in colors{
                    if color.contains("green"){
                        let t: String = color.chars().filter(|c| c.is_digit(10)).collect();
                        let number: i32 = t.parse::<i32>().unwrap();
                        if number > 13 && !false_already{
                            wrong_games = wrong_games + game_number;
                            false_already = true;
                            break
                        }
                    } else if color.contains("red"){
                        let t: String = color.chars().filter(|c| c.is_digit(10)).collect();
                        let number: i32 = t.parse::<i32>().unwrap();
                        if number > 12 && !false_already{
                            wrong_games = wrong_games + game_number;
                            false_already = true;
                            break
                        }
                    } else if color.contains("blue"){
                        let t: String = color.chars().filter(|c| c.is_digit(10)).collect();
                        let number: i32 = t.parse::<i32>().unwrap();
                        if number > 14 && !false_already{
                            wrong_games = wrong_games + game_number;
                            false_already = true;
                            break
                        }
                    }
                }
            }
        }
        
    }
    println!("Game Numbers: {}", 50*101 - wrong_games); 
}


fn exercise2() {
    let values = lines_from_file("AoC2.txt");
    let mut power_set_sum: i32 = 0;
    for game in values{
        let mut parts = game.split(":");
        let helpme = parts.nth(1);
        let mut max_greens = 0;
        let mut max_reds = 0;
        let mut max_blues = 0;
        if helpme.is_some(){
            let draws = helpme.unwrap().split(";");
            for draw in draws{
                let colors = draw.split(",");
                for color in colors{
                    if color.contains("green"){
                        let t: String = color.chars().filter(|c| c.is_digit(10)).collect();
                        let number: i32 = t.parse::<i32>().unwrap();
                        if number > max_greens{
                            max_greens = number;
                        }
                    } else if color.contains("red"){
                        let t: String = color.chars().filter(|c| c.is_digit(10)).collect();
                        let number: i32 = t.parse::<i32>().unwrap();
                        if number > max_reds{
                            max_reds = number;
                        }
                    } else if color.contains("blue"){
                        let t: String = color.chars().filter(|c| c.is_digit(10)).collect();
                        let number: i32 = t.parse::<i32>().unwrap();
                        if number > max_blues{
                            max_blues = number;
                        }
                    }
                }
            }
            let power_set = max_blues*max_greens*max_reds;
            power_set_sum = power_set_sum + power_set;
        }
        
    }
    println!("Power Set Sum: {}", power_set_sum); 
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
