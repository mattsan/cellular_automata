use rustler::Binary;
use rustler::OwnedBinary;

#[rustler::nif]
fn next(width: usize, height: usize, field: Binary) -> OwnedBinary {
    let mut next_field = OwnedBinary::new(width * height).unwrap();

    next_field.fill(0);
    for y in 0..height {
        for x in 0..width {
            let mut count = 0u8;
            let left = (x + width - 1) % width;
            let right = (x + 1) % width;
            let top = (y + height - 1) % height;
            let bottom = (y + 1) % height;

            count += field[top * width + left];
            count += field[top * width + x];
            count += field[top * width + right];

            count += field[y * width + left];
            count += field[y * width + right];

            count += field[bottom * width + left];
            count += field[bottom * width + x];
            count += field[bottom * width + right];

            if field[y * width + x] == 0 {
                next_field[y * width + x] = if count == 3 { 1 } else { 0 };
            } else {
                next_field[y * width + x] = if count == 2 || count == 3 { 1 } else { 0 };
            }
        }
    }

    next_field
}

rustler::init!("Elixir.GameOfLife.Nif", [next]);
