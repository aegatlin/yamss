# Yamss

Yet Another Machine Setup Script.

Copy and paste the line below to run the yamss setup script.

```sh
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/aegatlin/setup/master/dist/yamss.sh)"
```

See the `setup_*` functions in `lib/lib.sh` to see which tools are being used 
on which machines. Tools are configured in `lib/tools/[tool_name].sh`. A few 
config files are in `lib/configs/*`.

For more information on the motivation and ideas behind yamss, see 
`philosophy.md`. 

## Dev Notes

Run `make` to test and build. See `makefile` for more information.

Run `update_configs` to update `lib/configs/*` files.

