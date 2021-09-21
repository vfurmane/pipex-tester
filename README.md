# Pipex Tester

This repo provides test scripts for your **pipex** project @42School.

> Note that the tester doesn't check the norm. The purpose of this repo is to be more effective in evaluation, not to botch it up.

> Furthermore, the tester is absolutely not official and many tests may be irrelevant. It is intended for helping you design your project. Please do not use it as an absolute reference during defense.

## Installation

First things first, clone this repo (the preferred path is alongside the **pipex**'s directory).

```shell
git clone https://github.com/vfurmane/pipex-tester
```

## Usage

```shell
./run.sh [-cltu] [tests_no]...
```

Once the installation is done, `cd` into the tester's directory, and run the `./run.sh` script. You should be prompted some configuration questions. If you have answered any of them incorrectly, you can execute `./run.sh -c` or `./run.sh --config` to be prompted the questions again.

To stop the tester earlier, you can press Ctrl-C, and it will show you your grade at that moment.

The logs are stored in the `outs` directory. You'll find three types of file:

- `test-xx.txt`: this is the outfile of pipex.
- `test-xx-original.txt`: this is the outfile we would get with bash.
- `test-xx-tty.txt`: this is what your program writes (`stdout` and `stderr`)
- `test-xx-exit.txt`: this is the exit code of your program

You may find files like that `test-xx.x.txt`. These are log files for command executed twice during the same test.

There is a man page for the tester:

```shell
man ./man/man1/pipex-tester.1
```

### Arguments

#### test number

Run the specified tests.

```shell
./run.sh 1 2 3
```

#### -c

Allow you to reconfigure the tester.

```shell
./run.sh -c
```

#### -l

Disable the leaks tests.

```shell
./run.sh -l
```

#### -t

Disable the timeout tests. May run the tests faster.

```shell
./run.sh -t
```

#### -u

Force the tester to update (if needed only).

```shell
./run.sh -u
```

## Troubleshooting

If you encounter another problem, please feel free to open an Issue using the **GitHub**'s tab.
