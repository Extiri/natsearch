# natsearch

This is a simple command line utility for searching a codebase using natural language. It uses [ZachNagengast/similarity-search-kit](https://github.com/ZachNagengast/similarity-search-kit). It supports macOS 12 and up.

natsearch can be run by typing ```natsearch "<query>"``` (" are optional, but required in cases of multiword queries, because of shell behaviour) and replacing <query> with what you want to find. natsearch will then analyse all of the text/code files in current directory and subdirectories (in future it will be possible to choose depth). Analysis is conducted by splitting each file into parts of 5 lines (in future, configurable) and then calculating embeddings for each of them. The tool will then reply with 3 (again, in future, configurable) most similar fragments (fragments content, line range and file).

In future, there will be a chat-like mode for multiple queries, a cache mode (a database of embeddings will be saved in the directory), rolling-window mode (instead of splitting, embeddings will be calculated for each range of specified length, eg. 1-5, 2-6, 3-7, allowing for better results)

It is not very efficient, but with time improvements will be made. One of the these improvements will be making it asynchronous and have a cache for directories which are often searched.

## Roadmap
[ ] Searching
