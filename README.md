<img src='./logo.png' style='display: block; width: 100px; height: 100px; border-radious: 10%; margin: 0 0 10px 0 '>

# Shortcut

TLTR: Shortcut - record, save & execute your most used scripts in the terminal.

Example:

```ruby
sc fe be    # Boots your fe and be project in two separate terminal tabs

sc my_dir   # Instead of typing N cd, move stright to the directory
```

**SUPPORTS**: iTerm, Terminal

## About

A cli tool enhancing your terminal usage by allowing you to save your most used commands/scripts and then executing them in no time.

## How does it work?

1. You record your script or copy an existing one to the directory.

2. Execute saved script - it will open in a separate tab/s.

## Install with homebrew:

```console
brew tap devs-on-remote/shortcut

brew install shortcut
```

To troubleshoot install issues:

```console
brew install --build-from-source --verbose --debug shortcut
```

## Update

```console
brew update

brew upgrade shortcut
```

## Available commands (via homebrew):

`sc <script_name>` - executes the saved script

`sc --record` - turns on the record mode and allows you to add a script to the directory

`sc --delete` - deletes the script from the directory

`sc --list` - lists all saved scripts

`sc --edit` - allows to edit the script

`sc --help` - lists all sc commands

`sc --licence` - displays the content of LICENCE file

`sc --version` - displays the current version

## Available commands (from project dir):

Use `bin/shortcut` instead of `shortcut` or `sc`

## Contribution

When contributing remember to update the CHANGELOG and update version.rb
