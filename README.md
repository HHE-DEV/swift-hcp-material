# swift-hcp-material

A command line tool to parse pricing from a pdf and generate an updated
csv file for [House Call Pro](https://housecallpro.com).

## General

This tool requires a little bit of familiarity with using a terminal /
command line.

## Installation

This tool can be installed using [Homebrew](https://brew.sh).  Click the link
to install if you do not already have [Homebrew](https://brew.sh) installed.

Once you have brew installed, you can run the following command to install
this command line tool.

```
brew tap HHE-DEV/hcp-material && brew install swift-hcp-material
```

Homebrew manages installation, un-installation, updates, and shell completion.
The terminal application may have to be restarted for shell completion to take
effect.

### Installation Notes

Currently there are pre-built binaries for macOS `Big Sur` and `Monterey`.  
For macOS `Monterey` there are pre-built binaries for both `arm` and `x86`.
If you are not on macOS `Big Sur` or `Monterey` then a full version of
[Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12) will be required
to build the binary using homebrew.

## Usage

To check that installation was successful and the binary is found in your path.
You can use the following command.

```
hcp-material --help
```

This tool currently ships with two commands. Below is an explanation and usage
of the commands.

### Update Command

This is the default command that is used.  It requires a path to the pdf to
parse for the updated pricing and part numbers, a path to the csv file of your
current material pricing and part numbers, and a directory to write the new / updated
csv file to.

[Click here to learn how to export your price book materials.](https://help.housecallpro.com/en/articles/5087891-how-to-export-your-price-book)

For this example we will say that the pricing is located at `~/Downloads/Pricing.pdf` and
that our exported material csv is located at `~/Downloads/Materials.csv`.  We also want
to write the output file to the `/tmp` directory.

```
hcp-material --pdf ~/Downloads/Pricing.pdf --csv ~/Downloads/Materials.csv --output /tmp
```

You can also ignore parsing pages of the pdf, by adding one or more of the following
options to your command above.

```
--ignoring-page 1 --ignoring-page 2
```

Above would not parse / ignore pages 1 and 2.

After running the above command, then there should be an output file at `/tmp/output.csv`.
The updated pricing gets added as a new column / doesn't over-write the existing `cost`
column, so that you can review / make changes prior to uploading back to `House Call Pro`.

#### Update Command Notes

The `updated_cost` column will always have a value in it, if the part number was not
found in the parsed pdf, then it will have the current cost of the item. This is so that
once you have reviewed and are happy with the values in the column, the whole column can
be copied / replace the entire `cost` column.  You can then delete the `updated_cost` column
and the csv will be ready to be uploaded back to `House Call Pro`.

[Click here to learn how to import materials back into your price book](https://help.housecallpro.com/en/articles/5722461-how-to-import-materials-into-your-price-book)

Sometimes the update command will print an error like below.

`CoreGraphics PDF has logged an error. Set environment variable "CG_PDF_VERBOSE" to learn more.`

I have not found a way to remove this error, however it does not seem to affect the
updating process.

### Parse Command

The tool also comes with a command to print / show what gets parsed from the pdf or csv.

#### CSV Parsing
An example of a csv parsing command.  In this example we will parse and print a csv file
located at `~/Downloads/Materials.csv`

```
hcp-material parse csv ~/Downloads/Materials.csv
```

#### PDF Parsing
There is currently only one parsing strategy, which looks for items / lines that end in a
value that can be parsed to a number (this is used as the updated cost).  If a number is 
able to be parsed from the end of the line, then it looks at the begining of the line, if the
beginning of the line can be parsed as a string, it uses that as the part number.

The part number can not contain any spaces or it will likely not parse the way that you are
expecting it to.

The parsed output of the pdf may contain some strange key / value pairs (for example it
will sometimes parse the page numbers and footer section). These extra key / value pairs
should not affect the updating process.

An example of the parse command is below.  In this example we will parse and print the
results from a pdf located at `~/Downloads/Pricing.pdf`

```
hcp-material parse pdf ~/Downloads/Pricing.pdf
```

You can also ignore parsing pages of the pdf, by adding one or more of the following
options to your command above.

```
--ignoring-page 1 --ignoring-page 2
```

Above would not parse / ignore pages 1 and 2.

## Known Issues / Difficulties

The description field of an item is a known difficulty. We do our best to handle them, but some
items that are potentially problematic and cause failures are having quotes inside a description
field, or using a quote to represent inches in an item's description.

### Example

An item that has description of `6" duct upgrade` will not properly parse / fail, but using a
description such as `6 in. duct upgrade` will not be a problem.

### Potential Work Around

If you have a lot of descriptions that are complex or have nested quotes, then you can open the
input csv file and remove the entire description column, then re-export to a new csv file, run
the update command, then add the column of descriptions back prior to importing to House Call Pro.
