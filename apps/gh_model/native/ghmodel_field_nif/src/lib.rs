use rustler::Binary;
use rustler::OwnedBinary;

#[rustler::nif]
fn develop(width: usize, height: usize, prev_field: Binary) -> OwnedBinary {
    let mut next_field = OwnedBinary::new(width * height).unwrap();
    next_field.fill(0);
    for y in 0..height {
        for x in 0..width {
            next_field[y * width + x] =
            match prev_field[y * width + x] {
                1 => 2,
                2 => 0,
                _ => {
                    let mut cell = 0u8;
                    if x > 0 { cell |= prev_field[y * width + x - 1]; }
                    if x < width - 1 { cell |= prev_field[y * width + x + 1]; }
                    if y > 0 { cell |= prev_field[(y - 1) * width + x]; }
                    if y < height - 1 { cell |= prev_field[(y + 1) * width + x]; }
                    cell & 1
                }
            }
        }
    }
    next_field
}

rustler::init!("Elixir.GHModel.Field.Nif", [develop]);
