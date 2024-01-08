# BlinkLink CLI

The BlinkLink CLI is a useful if you want to explore our API from the command line terminal.

This CLI tool works with an environment file called `~/.ssh/bl_env`. This file will be
generated with the login.sh script. It contains our API endpoints and your credentials
for interaction with our API. Do not share this file with others because it contains sensitive
information.

Further, this repository contains scripts to perform various tasks with our API. All scripts rely on the
environment file mentioned earlier. To get started execute `./login.sh`.
