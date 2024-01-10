# RISCOF test exporter

## What is this?

If you're developing a RISC-V implementation, then you need to be able to test whether it's compatible with known-good RISC-V implementations.

This isn't enough to be certified as RISC-V compliant, but it's a pretty good start.

The official RISC-V test suite is implemented as a tool called RISCOF.

The problems:

- RISCOF really wants to run on Ubuntu with a fairly old version of Python. (The docs say 3.6, but I couldn't get it working below 3.8, which does work.)
- RISCOF wants to pollute the global directories of your machine.
- RISCOF is incredibly huge, but not for any especially good reason.

So, this tool installs RISCOF in VirtualBox using `vagrant` (a virtual machine manager)

To do this, it follows the instructions from the [RISCOF quickstart](https://riscof.readthedocs.io/en/stable/installation.html). The reference device has been replaced with a dummy device that crashes if you try to use it, and the device under test is spike_simple from [Incore Semiconductors](https://gitlab.com/incoresemi/riscof-plugins/-/tree/master/spike_simple?ref_type=heads).

Afterwards, it dumps the output in RISCOF's preferred format into `outbox`

## Why Vagrant? Why not Docker or WSL?

I already know and like Vagrant. Docker on Windows is a pretty miserable experience, and WSL is Windows-specific. Vagrant offers an identical experience on every platform I have tried it on (Mac and Windows) so it seems like a really good compromise.

## What if I don't like VirtualBox?

That's fine, but you'll need to rewrite the Vagrantfile, which uses `type: "virtualbox"` to create a two-way mount and uses a VirtualBox-specific directive to give itself more memory to cross-compile GCC with.

## How long does this take?

Installation takes about six hours on my PC, and I have a fairly beefy computer. It downloads about 6 GiB of files as part of setting up the RISC-V GNU toolchain.

Once it's installed, you can get a run of output in about 30 seconds.

If that's too slow, just download `example_output/` from this repo and use that.

## What commands do I run?

On any operating system, you can run the following: 

```bash
$ mkdir outbox
$ vagrant up  # start the machine
$ vagrant ssh -c "sudo /project/riscof-test-exporter/run_tests.sh"
```

The raw output you seek is in the `outbox/` directory.

## What does the output look like?

Because I can't imagine most people who find this repo will want to wait six hours for the commands to run, I included an example of the output in `example_output/`.

It's a mixture of ELF files and "signatures." A signature is a run of values from the data section of a test program. You'll want to read the RISCOF documentation for an explanation of that -- here is the [relevant page](https://riscof.readthedocs.io/en/stable/testformat.html). 

There's also some YAML documents. I'm going to freely admit that I don't understand most of them, but `test_list.yaml` is likely to help you: it tells you what processor features each test is actually supposed to be making assertions about.

## How would I use this to test my RISC-V implementation?

You can parse the ELF file, set up your RISC-V implementation, and extract the signature yourself.

If you have the same signatures under test as Spike does (the reference implementation), then your implementation probably isn't completely busted.

If you don't, your implementation is definitely busted.

## Can I run this in CI?

I really, really would not recommend you do that. Like I said, it takes six hours and eats a ton of bandwidth. If you run your own CI server, you might be able to optimize it, but I would instead recommend you use this tool, extract the output, prettify it, and use that battery of tests in CI. 

The output of the tool is only about 7MiB on my machine, so you could easily version that.

## Is this a substitute for RISCOF?

Not really: it only substitutes for the final series of assertions. RISCOF's test generator is something I have absolutely no desire to substitute for.

If you want to generate a lot of RISC-V binaries fast, which is the main other thing RISCOF does, it's pretty easy to cross-compile them on Linux or Windows using clang:

```bash
clang -nostdlib --target=riscv32 -march=rv32i input.c -o output.elf
```

Getting any other part of the testing process working after you've done this is an exercise for the reader -- spike is nontrivial to install, at least on the platforms I tried it on. 

I would love it if someone gave me a tool to inject ELF binaries and use them as tests -- pull requests will be accepted!

## I think the program hanged? 

If you see the script freeze on any of these lines, it's not dead, I promise:

- `Cloning into /project/workspace/riscv-gnu-toolchain/binutils`: Sorry, the repo's really big. I didn't make it!

Like I said, the repo is really big! I'm really sorry it takes so long.

## Can I have a crash course on Vagrant?

Yeah! I gave you the commands you need earlier.

To create the VM in Virtualbox and provision it, run this:

```bash
$ vagrant up
```

If you've changed the config file, run this:

```bash
$ vagrant reload
```

If you want to log into the VM and see for yourself what's going on, you can SSH in:

```bash
$ vagrant ssh
```

This is reasonable if (for instance) the VM is complaining about missing files.

For a much better Vagrant tutorial, go to the Vagrant website. [This](https://developer.hashicorp.com/vagrant/tutorials/getting-started) is a pretty good tutorial, but if you're relatively technical, you will get more out of just reading the Fundamentals section of the documentation [here](https://developer.hashicorp.com/vagrant/docs).