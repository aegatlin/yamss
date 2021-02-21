# Yams

Yet Another Machine Setup

Copy and paste the machine-appropriate script into your terminal to setup your machine.

```zsh
# For a local MacOS machine
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/setup_scripts/mac.zsh)"
```

```zsh
# For a remote Ubuntu Desktop VM
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/ubuntu_remote.zsh)"
```

```zsh
# For a local Ubuntu Desktop
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/ubuntu_desktop.zsh)"
```

## Usage Notes

Keeping the `.vimrc` and `.tmux.conf` files up to date is a challenge in this system. 

## Paradigm explanation

### Outline

1. Setup script best practices
   1. Idempotency
   1. Remote executability
   1. Dependency minimalism
   1. Unobstrusiveness
   1. Modularity
   1. Personalized
1. Observations on "using tools on machines"
   1. Prepare
   1. Setup
   1. Augment
   1. Bootstrap
1. The interleaving of steps
1. This implementation
   - Outstanding problems

### Setup script best practices

1. Idempotent

   This means you can run the script as many times as you want an you will always get the same result. This principle plays well with Unobstrusive.

1. Remote executability

   This means you can execute the script on any machine you can type into. This is achieved by, e.g., the full setup script being fully written to the machine and executed all via one `curl` request.

1. Dependency minimalism

   You shouldn't have to setup the machine to run the setup script. Debatably, this includes things like ensuring you have `git`, and cloning source code like a setup script repository, etc. This is achieved by, e.g., depending only on `zsh` and `curl`.

1. Unobstrusiveness

   A setup script shouldn't be opinionated about things guaranteed to change, like version numbers. To what degree a script is obtrusive or otherwise is up for debate, but, in general, don't get nit-picky about packages. You can do that kind of stuff after setup.

1. Modularity

   The composability of the setup script allows you and your environment to evolve over time, both of which will occur. Your favorite tool today might be deprecated in a few years. Lean in to this truth and plan for it. Being able to easily swap and move around tools is a hallmark of a flexible system.

1. Personalized

   This goes hand in hand with Modularity. I have my favorite tools, you have yours, and they might not play nice. Instead of including everything in some massive bloatware package, empower yourself with a custom setup. The risks of personalization must be noted! (1) if you don't maintain it, it'll die. (2) if it's not widely used, edge cases will slow you down. (3) Paradigm shifts are less likely to occur because a large community is not actively thinking about and working on it. I waver on this point myself...

### Observations on "using tools on machines"

In the most general terms, using a tool on a machine will involve none, some, or all of the following steps:

1. `prepare`
   - Preconditions are checked
   - Prerequisite software is downloaded and sometimes executed.
1. `setup`
1. `augment`
   - Settings are modified
1. `bootstrap`
   - Scripts, services, or processes are initiated

I hypothesize that for every tool I use, and across every machine I use, these four steps will successfully encapsulate the process of using a tool on a machine. The implication here is that if I want to install an arbitrary tool on an arbitrary machine, I can do so successfully within these four functions.

### The interleaving of steps

The complexities of machine setup come with the interplay between tools. One analogy would be that the OS is a blank canvas and each tool you want to use on your machine/OS is paint of a certain color. How you paint the canvas depends on the colors of paint you choose to use, but also on how you mix and match the colors to achieve the work of art that is your machine setup. Given two tools, `a` and `b`, it could be that `b` cannot be installed without `a` already being setup, but also, you have to `augment` your machine with `a` in a fashion that should occur after `b` has been set up and has augmented the machine. Such a scenario could be scripted as follows:

```/bin/zsh
a_install
a_setup
b_install
b_setup
b_augment
a_augment
```

A robust setup scripting solution will need to account for these possibilities.

### This implementation

The first aspect of this paradigm is that each tool will have an associated file, `tools/[tool_name].zsh`, with four functions for each phase of setup. The second aspect of this paradigm is that any arbitrary collection of tools will be able to self-sort by defining an `after` relation. This relation will define a well-orded list of functions, such that each function comes after those it stands in `after` relation to, if present.

With these aspects combined, you are then able to merely name the tools you wish to use in a setup script and the script will "just work". This will allow you to focus on the harder task of ensuring your tools have well written `after` relations, and well written phase functions.
