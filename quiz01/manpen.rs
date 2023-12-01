use std::{
    fs::File,
    io::{BufRead as _, BufReader},
};

fn first_last(mut digits: impl Iterator<Item = char>) -> Option<u32> {
    let first = digits.next()?;
    let last = digits.last().unwrap_or(first);
    Some(10 * (first as u32 - '0' as u32) + (last as u32 - '0' as u32))
}

fn quiz1(line: &str) -> Option<u32> {
    first_last(line.chars().filter(|x| x.is_ascii_digit()))
}

fn quiz2(mut line: String) -> Option<u32> {
    const DIGITS: [&str; 10] = [
        "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
    ];

    for (i, d) in DIGITS.iter().enumerate() {
        line = line.replace(d, &format!("{d}{i}{d}"));
    }
    quiz1(&line)
}

fn main() -> std::io::Result<()> {
    let lines: Vec<_> = BufReader::new(File::open("manpen.txt")?)
        .lines()
        .map(|x| x.unwrap())
        .collect();

    let res1: u32 = lines.iter().map(|x| quiz1(x).unwrap()).sum();
    let res2: u32 = lines.into_iter().map(|x| quiz2(x).unwrap()).sum();

    println!("Quiz1: {res1} \nQuiz2: {res2}");
    Ok(())
}

#[cfg(test)]
mod test {
    #[test]
    fn quiz1() {
        let res: u32 = "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet"
            .lines()
            .filter_map(super::quiz1)
            .sum();
        assert_eq!(res, 142);
    }

    #[test]
    fn quiz2() {
        let res : u32 = "two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen".lines().filter_map(|x| super::quiz2(String::from(x)) ).sum();
        assert_eq!(res, 281);
    }
}
