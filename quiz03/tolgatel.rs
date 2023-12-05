use std::{
    fs::File,
    io::{prelude::*, BufReader},
    path::Path,
};


fn main() {
    let values = lines_from_file("Aoc3.txt");
    let char_matrix = get_2D_array(&values);
    let zero_matrix = onlyzeros(&values);
    let exercise1 = true;
    if exercise1{
        let false_matrix = zeros(&values); 
        let first_marks = adjacency(&char_matrix, false_matrix);
        let final_marks = spread_marks(&char_matrix, first_marks);
        let result_a = get_num(&char_matrix, &final_marks);
    }
    else{
        let first_res = new_adj(&char_matrix, zero_matrix);
        let mark_spread = new_spread(&char_matrix, first_res.0);
        let result_b = calc(&char_matrix, mark_spread, first_res.1);
    }
}

fn get_2D_array(list_of_strings: &Vec<String>) -> Vec<Vec<char>>{
    let mut vec = Vec::new();
    for element in list_of_strings{
        let temp_vec: Vec<char> = element.chars().collect();
        vec.push(temp_vec);
    }
    return vec
}

fn check_symbol(i: usize, j: usize,char_matrix: &Vec<Vec<char>>) -> bool{
    if char_matrix[i][j].is_digit(10) || char_matrix[i][j] == '.'{
        return false;
    }
    else{
        return true;
    }
}

fn check_num(i:usize, j:usize, char_matrix: &Vec<Vec<char>>) -> bool{
    return char_matrix[i][j].is_digit(10);
}

fn get_dim(char_matrix: &Vec<Vec<char>>) -> (usize, usize){
    let dimensiony = char_matrix.len();
    let dimensionx = char_matrix[0].len();
    return (dimensionx, dimensiony)
}

fn zeros(list_of_strings: &Vec<String>) -> Vec<Vec<bool>> {
    let mut zero_mat = Vec::new();
    for element in list_of_strings{
        if element.len() != 0{
            let size_line: usize = element.len();
            let temp_vec: Vec<bool> = vec![false; size_line];
            zero_mat.push(temp_vec);
        }
    }
    return zero_mat
}

fn onlyzeros(list_of_strings: &Vec<String>) -> Vec<Vec<i32>> {
    let mut zero_mat = Vec::new();
    for element in list_of_strings{
        if element.len() != 0{
            let size_line: usize = element.len();
            let temp_vec: Vec<i32> = vec![0; size_line];
            zero_mat.push(temp_vec);
        }
    }
    return zero_mat
}


fn adjacency(char_matrix: &Vec<Vec<char>>, zeros: Vec<Vec<bool>>) -> Vec<Vec<bool>>{
    let dimension = get_dim(&char_matrix);
    let mut zero_mat = zeros;
    for i in 0..dimension.1-1{
        for j in 0..dimension.0-1{
            if char_matrix[i].len() != 0{
                if check_num(i, j, &char_matrix){
                    if i == 0 && j==0{
                        if check_symbol(i+1,j,&char_matrix) || check_symbol(i,j+1,&char_matrix) || check_symbol(i+1,j+1,&char_matrix){
                            zero_mat[i][j] = true;
                        }
                    }
                    else if i == 0 && j == dimension.0-2{
                        if check_symbol(i+1,j,&char_matrix) || check_symbol(i,j-1,&char_matrix) || check_symbol(i+1,j-1,&char_matrix){
                            zero_mat[i][j] = true;
                        }
                    }
                    else if i == dimension.1-2 && j == 0{
                        if check_symbol(i,j+1,&char_matrix) || check_symbol(i-1,j,&char_matrix) || check_symbol(i-1,j+1,&char_matrix){
                            zero_mat[i][j] = true;
                        }
                    }
                    else if i == dimension.1-2 && j == dimension.0-1{
                        if check_symbol(i,j-1,&char_matrix) || check_symbol(i-1,j,&char_matrix) || check_symbol(i-1,j-1,&char_matrix){
                            zero_mat[i][j] = true;
                        }
                    }
                    else if i == 0{
                        if check_symbol(i,j-1,&char_matrix) || check_symbol(i,j+1,&char_matrix) || check_symbol(i+1,j-1,&char_matrix) || check_symbol(i+1,j,&char_matrix) || check_symbol(i+1,j+1,&char_matrix){
                            zero_mat[i][j] = true;
                        }
                    }
                    else if j == 0{
                        if check_symbol(i-1,j,&char_matrix) || check_symbol(i+1,j,&char_matrix) || check_symbol(i-1,j+1,&char_matrix) || check_symbol(i,j+1,&char_matrix) || check_symbol(i+1,j+1,&char_matrix){
                            zero_mat[i][j] = true;
                        }
                    }
                    else if i == dimension.1-2{
                        if check_symbol(i-1,j-1,&char_matrix) || check_symbol(i-1,j,&char_matrix) || check_symbol(i-1,j+1,&char_matrix) || check_symbol(i,j-1,&char_matrix) || check_symbol(i,j+1,&char_matrix){
                            zero_mat[i][j] = true;
                        }
                    }
                    else if j == dimension.0-2{
                        if check_symbol(i-1,j-1,&char_matrix) || check_symbol(i,j-1,&char_matrix) || check_symbol(i+1,j-1,&char_matrix) || check_symbol(i-1,j,&char_matrix) || check_symbol(i+1,j,&char_matrix){
                            zero_mat[i][j] = true;
                        }
                    }
                    else{
                        if check_symbol(i-1,j-1,&char_matrix) || check_symbol(i,j-1,&char_matrix) || check_symbol(i+1,j-1,&char_matrix) || check_symbol(i-1,j,&char_matrix) || check_symbol(i+1,j,&char_matrix) || check_symbol(i-1,j+1,&char_matrix) || check_symbol(i,j+1,&char_matrix) || check_symbol(i+1,j+1,&char_matrix){
                            zero_mat[i][j] = true;
                        }
                    }
                }
            }
        }
    }
    return zero_mat
}


fn spread_marks(char_matrix: &Vec<Vec<char>>, zero_mat: Vec<Vec<bool>>) -> Vec<Vec<bool>>{
    let dimension = get_dim(&char_matrix);
    let mut marks = zero_mat;
    for i in 0..dimension.1-1{
        for j in 0..dimension.0-1{
            if marks[i].len() == 0{
                break
            }
            if marks[i][j]{
                for k in 1..j+1{
                    if check_num(i,j-k,char_matrix){
                        marks[i][j-k] = true;
                    }
                    else{
                        break
                    }
                }
                for k in 1..dimension.0-(j-1){
                    if check_num(i,j+k,char_matrix){
                        marks[i][j+k] = true;
                    }
                    else{
                        break
                    }
                }
            }
        }
    }
    return marks
}


fn get_num(char_matrix: &Vec<Vec<char>>, marks: &Vec<Vec<bool>>){
    let dimension = get_dim(&char_matrix);
    let mut numbers_sum = 0;
    for i in 0..dimension.1-1{
        let mut number = String::new();
        for j in 0..dimension.0-1{
            if marks[i].len() == 0{
                break
            }
            if marks[i][j]{
                number.push(char_matrix[i][j]);
                if j == dimension.0-2{
                    let number_int: i32 = number.parse().unwrap();
                    println!("int: {}", number_int);
                    numbers_sum = numbers_sum + number_int;
                    number = String::new();
                }
            }
            else if number.len() > 0 {
                let number_int: i32 = number.parse().unwrap();
                println!("int: {}", number_int);
                numbers_sum = numbers_sum + number_int;
                number = String::new();
            }
        }
    }
    println!("{}", numbers_sum);
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

fn ind(char_matrix: &Vec<Vec<char>>, i: usize, j: usize) -> char{
    let dimension = get_dim(&char_matrix);
    if i >= 0 as usize && i < dimension.1-1 && j >= 0 as usize && j < dimension.0-1{
        return char_matrix[i][j];
    }
    return '.';
}

fn new_adj(char_matrix: &Vec<Vec<char>>, zeros: Vec<Vec<i32>>) -> (Vec<Vec<i32>>, i32) {
    let dimension = get_dim(&char_matrix);
    let mut zeros = zeros;
    let mut big_count = 1;
    for i in 0..dimension.1-1{
        for j in 0..dimension.0-1{
            if char_matrix[i][j] == '*'{
                let mut counter = 0;
                let mut marker= Vec::new();
                if ind(char_matrix,i-1,j-1).is_digit(10){
                    counter = counter + 1;
                    let mark = (i-1,j-1);
                    marker.push(mark);
                }
                if ind(char_matrix,i-1,j).is_digit(10) && !ind(char_matrix,i-1,j-1).is_digit(10){
                    counter = counter + 1;
                    let mark = (i-1,j);
                    marker.push(mark);
                }
                if ind(char_matrix,i-1,j+1).is_digit(10) && !ind(char_matrix,i-1,j).is_digit(10){
                    counter = counter + 1;
                    let mark = (i-1,j+1);
                    marker.push(mark);
                }
                if ind(char_matrix,i,j-1).is_digit(10){
                    counter = counter + 1;
                    let mark = (i,j-1);
                    marker.push(mark);
                }
                if ind(char_matrix,i,j+1).is_digit(10){
                    counter = counter + 1;
                    let mark = (i,j+1);
                    marker.push(mark);
                }
                if ind(char_matrix,i+1,j-1).is_digit(10){
                    counter = counter + 1;
                    let mark = (i+1,j-1);
                    marker.push(mark);
                }
                if ind(char_matrix,i+1,j).is_digit(10) && !ind(char_matrix,i+1,j-1).is_digit(10){
                    counter = counter + 1;
                    let mark = (i+1,j);
                    marker.push(mark);
                }
                if ind(char_matrix,i+1,j+1).is_digit(10) && !ind(char_matrix,i+1,j).is_digit(10){
                    counter = counter + 1;
                    let mark = (i+1,j+1);
                    marker.push(mark);
                }
                if counter == 2{
                    zeros[marker[0].0][marker[0].1] = big_count;
                    zeros[marker[1].0][marker[1].1] = big_count;
                    big_count = big_count + 1;
                }
            }
        }
    }
    return (zeros, big_count)
}

fn new_spread(char_matrix: &Vec<Vec<char>>, zero_mat: Vec<Vec<i32>>) -> Vec<Vec<i32>>{
    let dimension = get_dim(&char_matrix);
    let mut marks = zero_mat;
    for i in 0..dimension.1-1{
        for j in 0..dimension.0-1{
            if marks[i].len() == 0{
                break
            }
            if marks[i][j]>0{
                for k in 1..j+1{
                    if check_num(i,j-k,char_matrix){
                        marks[i][j-k] = marks[i][j];
                    }
                    else{
                        break
                    }
                }
                for k in 1..dimension.0-(j)+1{
                    if check_num(i,j+k,char_matrix){
                        marks[i][j+k] = marks[i][j];
                    }
                    else{
                        break
                    }
                }
            }
        }
    }
    return marks
}


fn calc(char_matrix: &Vec<Vec<char>>, marks: Vec<Vec<i32>>, big_count: i32){
    let dimension = get_dim(&char_matrix);
    let mut sum_of_all = 0;
    for k in 1..big_count{
        let mut prod = 1;
        for i in 0..dimension.1-1{
            let mut number = String::new();
            for j in 0..dimension.0-1{
                if marks[i].len() == 0{
                    break
                }
                if marks[i][j] == k{
                    number.push(char_matrix[i][j]);
                    println!("num: {}", number);
                    if j == dimension.0-2{
                        let number_int: i32 = number.parse().unwrap();
                        println!("int: {}", number_int);
                        prod = prod * number_int;
                        number = String::new();
                    }
                }
                else if number.len() > 0 {
                    let number_int: i32 = number.parse().unwrap();
                    println!("int: {}", number_int);
                    prod = prod * number_int;
                    number = String::new();
                }
            }
        }
        sum_of_all = sum_of_all + prod;
    }
    println!("{}", sum_of_all);
}
