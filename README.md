# Setup

```zsh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/setup_scripts/mac.zsh)"
```

<!-- ```zsh
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/remote_ubuntu.zsh)"
``` -->

## Paradigm explanation

### Outline

1. The bundled good principles, practices, and pardigms
   - Remotely executable
   - Modular
   - Personal
   - Unobstrusive
   - Idempotent
1. Observations on "using tools on machines"
   - The universal 4 steps
      - Prepare
      - Setup
      - Augment
      - Bootstrap
   - The interleaving of steps
1. This implementation
   - Outstanding problems

## Outdated Notes Below

Everything below this line will be cleaned up to adhere to the outline specified above.

## Using a tool on a machine

In the most general terms, using a tool on a machine will involve none, some, or all of the following steps:

1. `prepare`
   - Preconditions are checked
   - Prerequisite software is downloaded and sometimes executed.
1. `setup`
1. `augment`
   - Settings are modified
1. `initiate`
   - Scripts, services, or processes are initiated

I hypothesize that for every tool I use, and across every machine I use, these four steps will successfully encapsulate the process of using a tool on my machine. The implication here is that if I want to install an arbitrary tool on a machine, I can do so within these four functions.

The first aspect of this setup script paradigm is that each tool will have a shell script, `[tool_name].zsh`, and that each of these shell scripts will make available none, some, or all of the above listed functions. Consider these to be the tool's "public functions"

## Interleaving steps

The complexities of machine setup come with the interplay between tools. One analogy would be that the OS is a blank canvas and each tool you want to use on your machine/OS is paint of a certain color. How you paint the canvas depends on the colors of paint you choose, but also on how you mix and match the colors to achieve the work of art that is your machine setup. Given two tools, `a` and `b`, it could be that `b` cannot be installed without `a` already being setup, but also, you have to `augment` your machine with `a` in a fashion that should occur after `b` has been set up and has augmented the machine. Such a scenario could be scripted as follows:

```/bin/zsh
a_install
a_setup
b_install
b_setup
b_augment
a_augment
```

The second aspect of this setup script paradigm is that each setup script has the authority to arrange the public functions of their tools as they see fit and appropriate.

## Principles

The following scripting principles are also incorporated into this methodology. You can consider these principles as the third aspect of this setup script paradigm.

- Remote

  Got curl? Got zsh? Get setup.

- Modular and Personal

- Unobtrusive

  No auto-updates to package managers, no auto-upgrades to libraries. That said, **these scripts will destroy and recreate your .zshrc (etc.) file each time**.

- Idempotent

  Running twice is the same as running once.
