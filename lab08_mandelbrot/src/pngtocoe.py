from PIL import Image

def process_image(image_path):
    # Open the image and ensure it's in RGB mode
    img = Image.open(image_path).convert('RGB')

    # Get the pixel data
    pixels = list(img.getdata())

    # List to store the 12-bit packed color values
    hex_values = []

    for pixel in pixels:
        r8, g8, b8 = pixel  # Get 8-bit RGB components

        # Map each component from 0-255 to 0-15 (4 bits)
        r4 = (r8 * 15 + 7) // 255  # R component
        g4 = (g8 * 15 + 7) // 255  # G component
        b4 = (b8 * 15 + 7) // 255  # B component

        # Pack the components into 12 bits in RBG order
        # Bits 11-8: R, Bits 7-4: B, Bits 3-0: G
        packed_value = (r4 << 8) | (b4 << 4) | g4

        # Convert the packed value to a 3-digit hex string
        hex_str = format(packed_value, '03x')  # Lowercase hex, pad with zeros if necessary

        # Add the hex string to the list
        hex_values.append(hex_str)
    
    return hex_values

def main():
    # List of image filenames to process
    image_files = ['brick.png'] + [f'ball_tile_{i}.png' for i in range(4)]

    # List to hold all hex values
    all_hex_values = []

    for image_file in image_files:
        hex_values = process_image(image_file)
        all_hex_values.extend(hex_values)

    # Write the COE file
    with open('sprites.coe', 'w') as f:
        f.write('memory_initialization_radix=16;\n')
        f.write('memory_initialization_vector=\n')

        # Write the hex values separated by commas and line breaks
        for i, hex_value in enumerate(all_hex_values):
            # Add a comma after each value except the last one
            if i != len(all_hex_values) - 1:
                f.write(hex_value + ',\n')
            else:
                f.write(hex_value + ';\n')  # End with a semicolon

    print("COE file 'sprites.coe' has been created successfully.")

if __name__ == "__main__":
    main()
