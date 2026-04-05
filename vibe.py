import tkinter as tk
from tkinter import font

# Function definitions for menu options
def function_one():
    print("Function One Executed")

def function_two():
    print("Function Two Executed")

def function_three():
    print("Function Three Executed")

def function_four():
    print("Function Four Executed")

# Create the main window
root = tk.Tk()
root.title("Vibe App")
root.geometry("800x600")

# Create the left frame for AI output
left_frame = tk.Frame(root, bg='#f0f0f0', width=400)
left_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

# Create the right frame for menu options
right_frame = tk.Frame(root, bg='#e0e0e0', width=400)
right_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

# UI Design for left frame
chat_display = tk.Text(left_frame, bg='white', font=('Arial', 12), wrap='word')
chat_display.pack(fill=tk.BOTH, expand=True)

# UI Design for right frame
menu_font = font.Font(family='Arial', size=14)
menu_options = [
    ("Function One", function_one),
    ("Function Two", function_two),
    ("Function Three", function_three),
    ("Function Four", function_four)
]

for option, func in menu_options:
    button = tk.Button(right_frame, text=option, command=func, font=menu_font, bg='#4CAF50', fg='white')
    button.pack(pady=10, padx=10, fill=tk.X)

# Run the application
root.mainloop()