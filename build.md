# Build Instructions

This document describes how to set up the local development environment for this Jekyll project.

## Local Ruby Environment Setup

To avoid conflicts with macOS's system Ruby and ensure proper dependency isolation, we use `rbenv` to manage Ruby versions locally (similar to Python virtual environments).

### Prerequisites

- Homebrew installed on macOS
- Command line tools

### Setup Steps

#### 1. Install system dependencies

```bash
# Install rbenv for Ruby version management
brew install rbenv ruby-build

# Install ImageMagick (required by jekyll-imagemagick plugin)
brew install imagemagick
```

#### 2. Configure rbenv in your shell

Add the following line to your `~/.zshrc` (or `~/.bash_profile` if using bash):

```bash
eval "$(rbenv init - zsh)"
```

Then reload your shell configuration:

```bash
source ~/.zshrc
```

#### 3. Install Ruby locally for this project

```bash
# Install Ruby 3.3.6 (or latest stable version)
rbenv install 3.3.6

# Set it as the Ruby version for this project directory
rbenv local 3.3.6
```

This creates a `.ruby-version` file that pins the Ruby version for this project.

#### 4. Install Bundler

```bash
gem install bundler
```

#### 5. Configure Bundler for local gem installation

```bash
# Install gems in the project's vendor/bundle directory
bundle config set --local path 'vendor/bundle'
```

#### 6. Install project dependencies

```bash
bundle install
```

## Python Environment Setup

This project uses Jupyter notebooks, which requires a Python environment with Jupyter installed.

### Setup Steps

#### 1. Install Python dependencies using uv

```bash
# Install uv if you haven't already
# See: https://github.com/astral-sh/uv

# Create virtual environment
uv venv

# Install dependencies from requirements.txt
uv pip install -r requirements.txt
```

This creates a `.venv` directory with Python and all required packages including Jupyter.

## Running the Project

To run the Jekyll development server, you need both Ruby and Python environments active:

```bash
# Activate Python virtual environment and run Jekyll with LSI
source ./.venv/bin/activate && bundle exec jekyll serve --lsi
```

The site will be available at <http://127.0.0.1:4000>

### Alternative: Running without LSI

If you don't need Latent Semantic Indexing (related posts feature):

```bash
source ./.venv/bin/activate && bundle exec jekyll serve
```

### Notes

- The `.ruby-version` file ensures everyone on the project uses the same Ruby version
- Gems are installed in `vendor/bundle/` to keep them project-local
- Always prefix Jekyll commands with `bundle exec` to use the correct gem versions
- These directories should be in `.gitignore`: `vendor/bundle/`, `.bundle/`
