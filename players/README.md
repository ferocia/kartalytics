## Installation

Install required native dependencies and Ruby gems.
```sh
brew bundle
bundle install
```

## Usage

Generate player QR codes as SVGs. See `output` directory for results.
```sh
ruby lib/generate.rb
```

Scan for QR codes.
```sh
ruby lib/scan.rb
```
