# Brainfuck

This is a gas assembly brainfuck interpreter that I wrote as a university assignment. 

There are a few files in here for you:

 - main.s:
    This file contains the main function.
    It reads a file from a command line argument and passes it to your brainfuck implementation.

 - read_file.s:
    Holds a subroutine for reading the contents of a file.
    This subroutine is used by the main function in main.s.

 - brainfuck.s:
    Contains the interpreter implementation. It is a subroutine that takes a single argument: a string holding the code to execute.

 - Makefile:
    A file containing compilation information.  If you have a working make,
    you can compile the code in this directory by simply running the command `make`.


Feel free to have a look at the different files, but keep in mind that all you need to do is:

  1. Edit `brainfuck.s`
  2. Run `make`
  3. Run `./brainfuck`
