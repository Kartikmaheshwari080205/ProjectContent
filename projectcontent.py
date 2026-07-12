import os
import sys
import subprocess
from tkinter import Tk, filedialog
from datetime import datetime
import pyperclip

# ----------------------------------------
# Configuration
# ----------------------------------------

IGNORE_DIRS = {
    ".git",
    ".idea",
    ".vscode",
    "node_modules",
    "venv",
    ".venv",
    "__pycache__",
    ".pytest_cache",
    ".mypy_cache",
    ".gradle",
    "target",
    "build",
    "dist",
    "bin",
    "out",
    ".next",
    ".cache",
    ".dart_tool",
    ".terraform"
}

OUTPUT_DIRECTORY = os.path.join(
    os.path.expanduser("~"),
    "Desktop", "ProjectContent"
)

os.makedirs(OUTPUT_DIRECTORY, exist_ok=True)


# ----------------------------------------
# Clipboard
# ----------------------------------------

def copy_to_clipboard(text):
    pyperclip.copy(text)


# ----------------------------------------
# Binary Detection
# ----------------------------------------

def is_binary(file_path):
    try:
        with open(file_path, "rb") as f:
            chunk = f.read(1024)

        if b"\0" in chunk:
            return True

        chunk.decode("utf-8")
        return False

    except Exception:
        return True


# ----------------------------------------
# Project Structure
# ----------------------------------------

def write_project_structure(folder_path, out):

    out.write("=" * 80 + "\n")
    out.write("PROJECT STRUCTURE\n")
    out.write("=" * 80 + "\n\n")

    for root, dirs, files in os.walk(folder_path):

        dirs[:] = sorted(
            d for d in dirs
            if d not in IGNORE_DIRS
        )

        relative = os.path.relpath(root, folder_path)

        if relative == ".":
            indent = ""
            out.write(f"{os.path.basename(folder_path)}/\n")
        else:
            level = relative.count(os.sep) + 1
            indent = "    " * level
            out.write(f"{indent}{os.path.basename(root)}/\n")

        for file in sorted(files):

            path = os.path.join(root, file)

            if is_binary(path):
                continue

            out.write(f"{indent}    {file}\n")

    out.write("\n\n")


# ----------------------------------------
# File Contents
# ----------------------------------------

def write_file_contents(folder_path, out):

    for root, dirs, files in os.walk(folder_path):

        dirs[:] = sorted(
            d for d in dirs
            if d not in IGNORE_DIRS
        )

        for file in sorted(files):

            path = os.path.join(root, file)

            if is_binary(path):
                continue

            relative = os.path.relpath(path, folder_path)

            out.write("=" * 80 + "\n")
            out.write(f"FILE: {relative}\n")
            out.write("=" * 80 + "\n")

            try:
                with open(path, "r", encoding="utf-8") as f:
                    out.write(f.read())
            except Exception as e:
                out.write(f"[Could not read file: {e}]")

            out.write("\n\n")


# ----------------------------------------
# Dump Project
# ----------------------------------------

def dump_project(folder_path):

    project_name = os.path.basename(os.path.abspath(folder_path))

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    output_file = os.path.join(
        OUTPUT_DIRECTORY,
        f"{project_name}_{timestamp}_ProjectContent.txt"
    )

    with open(output_file, "w", encoding="utf-8") as out:
        write_project_structure(folder_path, out)
        write_file_contents(folder_path, out)

    with open(output_file, "r", encoding="utf-8") as f:
        content = f.read()

    copy_to_clipboard(content)

    print("\nDone!")
    print(f"Saved to:\n{output_file}")
    print("✓ Project content copied to clipboard.")


# ----------------------------------------
# Folder Picker
# ----------------------------------------

def select_folder():

    root = Tk()
    root.withdraw()

    folder = filedialog.askdirectory(
        title="Select Project Folder"
    )

    root.destroy()

    return folder


# ----------------------------------------
# Main
# ----------------------------------------

if __name__ == "__main__":

    if len(sys.argv) > 1:
        folder = sys.argv[1]
    else:
        folder = select_folder()

    if not folder:
        print("No folder selected.")
        sys.exit()

    if not os.path.isdir(folder):
        print("Invalid folder.")
        sys.exit()

    dump_project(folder)