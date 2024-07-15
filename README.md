# natsearch

This is a simple command line utility for searching a codebase using natural language. It uses [ZachNagengast/similarity-search-kit](https://github.com/ZachNagengast/similarity-search-kit). It supports macOS 12 and up.

natsearch can be run by typing ```natsearch "<query>"``` (" are optional, but required in cases of multiword queries, because of shell behaviour) and replacing <query> with what you want to find. natsearch will then analyse all of the text/code files in current directory and subdirectories. Analysis is conducted by splitting each file into parts of 5 lines and then calculating embeddings for each of them. The tool will then reply with 3 most similar fragments (fragments content, line range and file). All these parameters can be changed by using command line arguments (--depth, --split-length, --results-number, --json, --quiet). There is also ```natsearch engine``` which allows for faster continous searches as files are indexed only once at the beginning.

In future, there will be a cache mode (a database of embeddings will be optionally saved in the directory) and rolling-window mode (instead of splitting, embeddings will be calculated for each range of specified length, eg. 1-5, 2-6, 3-7, allowing for better results).

It is not very efficient, but with time improvements will be made. One of the these improvements will be making it asynchronous and have a cache for directories which are often searched.

## Installing

There are no binaries at the moment. Check Building.

## Building

natsearch works only on macOS 12 and up. To build, Xcode is required.

First, clone this repository:
```git clone https://github.com/Extiri/natsearch```

Then open natsearch.xcodeproj file in Xcode. Then run the project. Then go to Product > Show build folder in Finder and then Products > Debug. natsearch is the built executable. You can alias it in your shell and, if you want, add it to your shell config.

## Help
Type ```natsearch --help``` or ```natsearch <command> --help``` to get help and options for specific command.
