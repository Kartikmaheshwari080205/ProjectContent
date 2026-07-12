# ProjectContent

ProjectContent is a lightweight Windows utility that generates a complete text representation of any source code project for use with Large Language Models (LLMs) such as ChatGPT, Claude, Gemini, and others.

With a single right-click, ProjectContent recursively scans a project, captures its directory structure and source files, copies the generated output to the clipboard, and saves it as a timestamped text file.

---

## Features

* Generates a complete snapshot of a project
* Includes both project structure and file contents
* Supports any text-based programming language
* Automatically skips binary files
* Ignores common build and cache directories
* Copies the generated output directly to the clipboard
* Integrates with the Windows right-click context menu
* Saves generated files to `Desktop/ProjectContent`

Supported languages include:

* Java
* Python
* C
* C++
* JavaScript
* TypeScript
* Go
* Rust
* Kotlin
* C#
* HTML/CSS
* JSON
* XML
* YAML
* Markdown
* Any other text-based language

---

## Why?

When working with LLMs, providing an entire project as context often produces significantly better responses than sharing individual files.

ProjectContent automates this process by generating a single text file containing the complete project, ready to paste into an LLM or upload as a file.

---

## Requirements

* Windows
* Python 3.10 or later

Install the required dependency:

```bash
pip install pyperclip
```

---

## Installation

1. Clone this repository or download it as a ZIP.

2. Place the project in a permanent location, for example:

   `C:\Tools\ProjectContent`

3. Run:

   ```text
   install.bat
   ```

The installer automatically:

* Registers the Windows context menu.
* Detects the installation directory automatically.
* Configures everything required to use ProjectContent.

---

## Uninstallation

To remove ProjectContent from the Windows context menu, simply run:

```text
uninstall.bat
```

---

## Usage

Right-click any project folder and select:

`Generate Project Content`

The utility will:

1. Scan the project recursively.
2. Generate a timestamped project content file.
3. Save it to `Desktop/ProjectContent`.
4. Copy the generated content to the clipboard.

The output can then be pasted directly into ChatGPT or another LLM using `Ctrl + V`.

---

## Ignored Directories

The following directories are skipped by default:

* `.git`
* `.idea`
* `.vscode`
* `node_modules`
* `venv`
* `.venv`
* `__pycache__`
* `.pytest_cache`
* `.mypy_cache`
* `.gradle`
* `target`
* `build`
* `dist`
* `bin`
* `out`
* `.next`
* `.cache`
* `.dart_tool`
* `.terraform`

Binary files are automatically ignored.

---

## Repository Structure

```text
ProjectContent/
├── projectcontent.py
├── generate_context.bat
├── install.bat
├── uninstall.bat
└── README.md
```

---