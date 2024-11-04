from PIL import Image, ImageDraw, ImageFont
import sys
from datetime import datetime
import math

# Function to create a diagonal linear gradient background with multiple colors
def create_gradient(width, height, colors, angle):
    gradient = Image.new("RGBA", (width, height))
    
    # Convert angle to radians
    radian = math.radians(angle)

    # Calculate number of colors
    num_colors = len(colors)

    for y in range(height):
        for x in range(width):
            # Calculate the ratio based on the angle
            ratio = ((y / height) * math.cos(radian) - (x / width) * math.sin(radian) + 1) / 2
            ratio = min(max(ratio, 0), 1)  # Clamp ratio between 0 and 1

            # Find which two colors to interpolate between
            left_index = int(ratio * (num_colors - 1))
            right_index = min(left_index + 1, num_colors - 1)
            left_color = colors[left_index]
            right_color = colors[right_index]

            # Calculate the color at the current pixel
            interp_ratio = (ratio * (num_colors - 1)) - left_index
            r = int(left_color[0] * (1 - interp_ratio) + right_color[0] * interp_ratio)
            g = int(left_color[1] * (1 - interp_ratio) + right_color[1] * interp_ratio)
            b = int(left_color[2] * (1 - interp_ratio) + right_color[2] * interp_ratio)
            a = 255  # Full opacity

            gradient.putpixel((x, y), (r, g, b, a))

    return gradient

# Function to create a box with rounded corners
def draw_glassy_box(draw, position, fill, radius=10):
    x1, y1, x2, y2 = position
    draw.rounded_rectangle([x1, y1, x2, y2], radius=radius, fill=fill)

# Function to generate a wallpaper with overlay text
def generate_wallpaper(output_file):
    # Set resolution for 4K
    width, height = 3840, 2160  # 4K resolution

    # Define gradient colors (from top right to bottom left)
    colors = [
        (255, 0, 195),  # #ff00c3
        (209, 35, 186), # #d123ba
        (164, 45, 219), # #a42dab
        (123, 47, 151), # #7b2f97
        (85, 43, 128),  # #552b80
        (52, 36, 101),  # #342465
        (24, 26, 72),   # #181a48
        (5, 11, 43)     # #050b2b
    ]

    # Create diagonal gradient background at 194 degrees
    bg_image = create_gradient(width, height, colors, 194)

    # Calculate weeks lived
    dob = datetime(2001, 10, 29)
    today = datetime.now()
    weeks_lived = (today - dob).days // 7

    # Create a new image for the wallpaper
    wallpaper = Image.new("RGBA", (width, height))

    # Create a draw object for the wallpaper
    draw = ImageDraw.Draw(wallpaper)

    # Define colors and transparency
    unfilled_box_color = (0, 0, 0, 25)  # Black with 10% transparency
    filled_box_color = (0, 0, 0, 50)  # Black with 15% transparency
    box_count_width = 91  # Number of boxes in width
    box_count_height = 51  # Number of boxes in height

    # Set box size and padding
    box_size = 32  # Box size
    padding = 10    # Increased gap between boxes

    # Calculate offsets for centering with additional margin
    total_box_width = box_count_width * (box_size + padding) - padding
    total_box_height = box_count_height * (box_size + padding) - padding
    x_offset = ((width - total_box_width) // 2)
    y_offset = ((height - total_box_height) // 2)

    # Create the wallpaper boxes (top-to-bottom filling order)
    box_count = 0
    for col in range(box_count_width):
        for row in range(box_count_height):
            x = x_offset + col * (box_size + padding)
            y = y_offset + row * (box_size + padding)

            # Choose color based on weeks lived
            color = filled_box_color if box_count < weeks_lived else unfilled_box_color

            # Draw a box with rounded corners
            draw_glassy_box(draw, (x, y, x + box_size, y + box_size), color, radius=5)
            box_count += 1

            # Stop if we've reached the total box count
            if box_count >= box_count_width * box_count_height:
                break
        if box_count >= box_count_width * box_count_height:
            break

    # Combine the diagonal gradient background with the wallpaper
    wallpaper = Image.alpha_composite(bg_image, wallpaper)

    # Create a draw object for text
    draw = ImageDraw.Draw(wallpaper)

    # Define text and font settings
    text = f"{weeks_lived} / 4696"
    font_size = 50  # Set font size to 50
    text_color = (255, 255, 255, 255)  # White with 30% transparency
    try:
        font_path = "JetBrainsMono-Bold.ttf"  # Path to the bold JetBrains Mono font
        font = ImageFont.truetype(font_path, font_size)  # JetBrains Mono Bold
    except IOError:
        font = ImageFont.load_default()
        print("Font loading failed, using default font")

    # Position text 80px above the bottom and 125px from the right edge
    text_bbox = draw.textbbox((0, 0), text, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]
    text_position = (width - text_width - 50, height - text_height - 60)

    # Draw the text with specified transparency
    draw.text(text_position, text, fill=text_color, font=font)  # Transparent white text

    # Save the final image
    wallpaper.save(output_file, "PNG")
    print(f"Wallpaper generated at: {output_file}")

# Check if output file path is provided
if len(sys.argv) < 2:
    print("Usage: python weekly_generator.py <output_file_path>")
    sys.exit(1)

# Generate the wallpaper
generate_wallpaper(sys.argv[1])

