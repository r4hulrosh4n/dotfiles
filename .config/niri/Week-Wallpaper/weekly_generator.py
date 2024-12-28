from PIL import Image, ImageDraw, ImageFont
import sys
from datetime import datetime
import math


def create_gradient(width, height, colors, angle):
    gradient = Image.new("RGBA", (width, height))

    radian = math.radians(angle)

    num_colors = len(colors)

    for y in range(height):
        for x in range(width):
            ratio = ((y / height) * math.cos(radian) -
                     (x / width) * math.sin(radian) + 1) / 2
            ratio = min(max(ratio, 0), 1)

            left_index = int(ratio * (num_colors - 1))
            right_index = min(left_index + 1, num_colors - 1)
            left_color = colors[left_index]
            right_color = colors[right_index]

            interp_ratio = (ratio * (num_colors - 1)) - left_index
            r = int(left_color[0] * (1 - interp_ratio) +
                    right_color[0] * interp_ratio)
            g = int(left_color[1] * (1 - interp_ratio) +
                    right_color[1] * interp_ratio)
            b = int(left_color[2] * (1 - interp_ratio) +
                    right_color[2] * interp_ratio)
            a = 255

            gradient.putpixel((x, y), (r, g, b, a))

    return gradient


def draw_glassy_box(draw, position, fill, radius=10):
    x1, y1, x2, y2 = position
    draw.rounded_rectangle([x1, y1, x2, y2], radius=radius, fill=fill)


def generate_wallpaper(output_file):
    width, height = 3840, 2160  # 4K resolution

    colors = [
        (255, 0, 195),
        (209, 35, 186),
        (164, 45, 219),
        (123, 47, 151),
        (85, 43, 128),
        (52, 36, 101),
        (24, 26, 72),
        (5, 11, 43)
    ]

    bg_image = create_gradient(width, height, colors, 194)

    dob = datetime(2001, 10, 29)
    today = datetime.now()
    weeks_lived = (today - dob).days // 7

    wallpaper = Image.new("RGBA", (width, height))

    draw = ImageDraw.Draw(wallpaper)

    unfilled_box_color = (0, 0, 0, 25)
    filled_box_color = (0, 0, 0, 50)
    box_count_width = 91
    box_count_height = 51

    box_size = 32
    padding = 10

    total_box_width = box_count_width * (box_size + padding) - padding
    total_box_height = box_count_height * (box_size + padding) - padding
    x_offset = ((width - total_box_width) // 2)
    y_offset = ((height - total_box_height) // 2)

    box_count = 0
    for col in range(box_count_width):
        for row in range(box_count_height):
            x = x_offset + col * (box_size + padding)
            y = y_offset + row * (box_size + padding)

            color = filled_box_color if box_count < weeks_lived else unfilled_box_color

            draw_glassy_box(draw, (x, y, x + box_size,
                            y + box_size), color, radius=5)
            box_count += 1

            if box_count >= box_count_width * box_count_height:
                break
        if box_count >= box_count_width * box_count_height:
            break

    wallpaper = Image.alpha_composite(bg_image, wallpaper)

    draw = ImageDraw.Draw(wallpaper)

    text = f"{weeks_lived}/4696"
    font_size = 38
    text_color = (255, 255, 255, 255)
    try:
        font_path = "JetBrainsMono-Bold.ttf"
        font = ImageFont.truetype(font_path, font_size)
    except IOError:
        font = ImageFont.load_default()
        print("Font loading failed, using default font")

    text_bbox = draw.textbbox((0, 0), text, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]
    text_position = (width - text_width - 50, height - text_height - 60)

    draw.text(text_position, text, fill=text_color, font=font)

    wallpaper.save(output_file, "PNG")
    print(f"Wallpaper generated at: {output_file}")


if len(sys.argv) < 2:
    print("Usage: python weekly_generator.py <output_file_path>")
    sys.exit(1)

generate_wallpaper(sys.argv[1])
