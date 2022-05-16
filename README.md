# FenneLove

requires Nix

## Helper Utility

The Nix shell creates a small bash helper utility with a couple options.

### Build

Compiles the Fennel source code into the `.build/` directory.
```sh
fnlove build
```

### Run

Compiles the source code and opens it in Löve.
```sh
fnlove run
```

### Publish

Compiles the source code and packages it into a `.love` file.
```sh
fnlove publish <Your Game Name>
```