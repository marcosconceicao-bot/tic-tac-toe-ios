#!/usr/bin/env python3
"""
Create App Icon for Tic Tac Toe iOS
Generates a simple but professional app icon
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_app_icon():
    """Create a simple but attractive app icon for the Tic Tac Toe game"""
    
    # Icon size (1024x1024 for App Store)
    size = 1024
    
    # Create image with gradient background
    image = Image.new('RGB', (size, size), '#4A90E2')  # Nice blue background
    draw = ImageDraw.Draw(image)
    
    # Create gradient effect
    for y in range(size):
        alpha = int(255 * (1 - y / size * 0.3))  # Subtle gradient
        color = f'#{min(255, 74 + alpha//8):02x}{min(255, 144 + alpha//8):02x}{min(255, 226):02x}'
        draw.line([(0, y), (size, y)], fill=color)
    
    # Draw rounded rectangle background
    corner_radius = size // 6
    draw.rounded_rectangle(
        [corner_radius//2, corner_radius//2, size-corner_radius//2, size-corner_radius//2],
        radius=corner_radius,
        fill='#FFFFFF',
        outline='#E0E0E0',
        width=8
    )
    
    # Draw tic-tac-toe grid
    grid_size = size // 2
    start_x = (size - grid_size) // 2
    start_y = (size - grid_size) // 2
    
    line_width = 12
    grid_color = '#2C3E50'  # Dark blue-gray
    
    # Vertical lines
    for i in range(1, 3):
        x = start_x + (grid_size * i // 3)
        draw.line([(x, start_y + 20), (x, start_y + grid_size - 20)], 
                  fill=grid_color, width=line_width)
    
    # Horizontal lines  
    for i in range(1, 3):
        y = start_y + (grid_size * i // 3)
        draw.line([(start_x + 20, y), (start_x + grid_size - 20, y)], 
                  fill=grid_color, width=line_width)
    
    # Draw X and O symbols
    cell_size = grid_size // 3
    
    # X in top-left (red)
    x_color = '#E74C3C'
    cell_x = start_x + cell_size // 2
    cell_y = start_y + cell_size // 2
    margin = cell_size // 4
    
    draw.line([cell_x - margin, cell_y - margin, cell_x + margin, cell_y + margin], 
              fill=x_color, width=line_width)
    draw.line([cell_x + margin, cell_y - margin, cell_x - margin, cell_y + margin], 
              fill=x_color, width=line_width)
    
    # O in center (blue)
    o_color = '#3498DB'
    cell_x = start_x + cell_size + cell_size // 2
    cell_y = start_y + cell_size + cell_size // 2
    radius = cell_size // 3
    
    draw.ellipse([cell_x - radius, cell_y - radius, cell_x + radius, cell_y + radius],
                 outline=o_color, width=line_width)
    
    # Add subtle shadow effect
    shadow_offset = 8
    shadow_image = Image.new('RGBA', (size + shadow_offset * 2, size + shadow_offset * 2), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow_image)
    
    # Draw shadow
    shadow_draw.rounded_rectangle(
        [corner_radius//2 + shadow_offset, corner_radius//2 + shadow_offset, 
         size-corner_radius//2 + shadow_offset, size-corner_radius//2 + shadow_offset],
        radius=corner_radius,
        fill=(0, 0, 0, 30)  # Semi-transparent shadow
    )
    
    # Composite shadow with main image
    final_image = Image.new('RGB', (size, size), '#4A90E2')
    shadow_cropped = shadow_image.crop((shadow_offset, shadow_offset, 
                                       shadow_offset + size, shadow_offset + size))
    final_image.paste(shadow_cropped, (0, 0))
    final_image.paste(image, (0, 0))
    
    return final_image

def create_all_icon_sizes():
    """Create all required iOS app icon sizes"""
    
    # Create the main 1024x1024 icon
    main_icon = create_app_icon()
    
    # iOS app icon sizes required
    sizes = [
        (1024, 1024, "AppStore"),
        (180, 180, "iPhone@3x"),
        (120, 120, "iPhone@2x"),
        (87, 87, "iPhone@3x-Settings"),
        (80, 80, "iPhone@2x-Spotlight"),
        (76, 76, "iPad"),
        (152, 152, "iPad@2x"),
        (167, 167, "iPad Pro"),
        (60, 60, "iPhone@2x-Notification"),
        (40, 40, "iPhone@2x-Spotlight"),
        (29, 29, "iPhone-Settings"),
        (58, 58, "iPhone@2x-Settings")
    ]
    
    # Create assets directory
    assets_dir = "TicTacToe/Resources/Assets.xcassets/AppIcon.appiconset"
    os.makedirs(assets_dir, exist_ok=True)
    
    print("🎨 Creating app icons...")
    
    for width, height, name in sizes:
        # Resize the main icon
        resized_icon = main_icon.resize((width, height), Image.Resampling.LANCZOS)
        
        # Save with appropriate filename
        filename = f"icon-{width}x{height}.png"
        filepath = os.path.join(assets_dir, filename)
        resized_icon.save(filepath, "PNG", quality=95)
        
        print(f"  ✅ Created {filename} ({width}x{height})")
    
    # Update Contents.json with actual filenames
    contents_json = {
        "images": [
            {"idiom": "iphone", "scale": "2x", "size": "20x20", "filename": "icon-40x40.png"},
            {"idiom": "iphone", "scale": "3x", "size": "20x20", "filename": "icon-60x60.png"},
            {"idiom": "iphone", "scale": "2x", "size": "29x29", "filename": "icon-58x58.png"},
            {"idiom": "iphone", "scale": "3x", "size": "29x29", "filename": "icon-87x87.png"},
            {"idiom": "iphone", "scale": "2x", "size": "40x40", "filename": "icon-80x80.png"},
            {"idiom": "iphone", "scale": "3x", "size": "40x40", "filename": "icon-120x120.png"},
            {"idiom": "iphone", "scale": "2x", "size": "60x60", "filename": "icon-120x120.png"},
            {"idiom": "iphone", "scale": "3x", "size": "60x60", "filename": "icon-180x180.png"},
            {"idiom": "ipad", "scale": "1x", "size": "20x20", "filename": "icon-40x40.png"},
            {"idiom": "ipad", "scale": "2x", "size": "20x20", "filename": "icon-40x40.png"},
            {"idiom": "ipad", "scale": "1x", "size": "29x29", "filename": "icon-29x29.png"},
            {"idiom": "ipad", "scale": "2x", "size": "29x29", "filename": "icon-58x58.png"},
            {"idiom": "ipad", "scale": "1x", "size": "40x40", "filename": "icon-40x40.png"},
            {"idiom": "ipad", "scale": "2x", "size": "40x40", "filename": "icon-80x80.png"},
            {"idiom": "ipad", "scale": "1x", "size": "76x76", "filename": "icon-76x76.png"},
            {"idiom": "ipad", "scale": "2x", "size": "76x76", "filename": "icon-152x152.png"},
            {"idiom": "ipad", "scale": "2x", "size": "83.5x83.5", "filename": "icon-167x167.png"},
            {"idiom": "ios-marketing", "scale": "1x", "size": "1024x1024", "filename": "icon-1024x1024.png"}
        ],
        "info": {
            "author": "xcode",
            "version": 1
        }
    }
    
    import json
    with open(os.path.join(assets_dir, "Contents.json"), "w") as f:
        json.dump(contents_json, f, indent=2)
    
    print("✅ App icon creation complete!")
    print("📱 All iOS app icon sizes generated")
    print("🎯 Ready for App Store submission")

if __name__ == "__main__":
    try:
        create_all_icon_sizes()
    except ImportError:
        print("❌ PIL (Pillow) not installed. Installing...")
        os.system("pip3 install Pillow")
        create_all_icon_sizes()
    except Exception as e:
        print(f"❌ Error creating app icons: {e}")
        print("Creating simplified version...")
        
        # Fallback: create a simple colored square
        simple_icon = Image.new('RGB', (1024, 1024), '#4A90E2')
        draw = ImageDraw.Draw(simple_icon)
        
        # Simple X and O
        draw.text((400, 450), "X O", fill='white', font_size=200)
        draw.text((350, 500), "Tic Tac Toe", fill='white', font_size=72)
        
        simple_icon.save("TicTacToe/Resources/Assets.xcassets/AppIcon.appiconset/icon-1024x1024.png")
        print("✅ Simple app icon created")