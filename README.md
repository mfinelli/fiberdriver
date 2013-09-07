fiberdriver
===========
Fiberdriver is a way to easily manage your server without changing configuration files.

Goals
-----
- Lightweight
- Secure
- Modular
- Mobile friendly

Fiberdriver will be centered around *tasks* instead of *software*.

Fiberdriver will install a webserver automatically. The default is nginx but it will be possible to choose apache and possibly others during install.

Install
------
Installation of fiberdriver is easy! Just `git clone --recursive https://github.com/mfinelli/fiberdriver.git`, `cd` into the directory and `sudo ./install.sh`.

To update just `git pull` and run `sudo ./install.sh` again

Contribute
----------
To contribute you can fork the repository on github, do all of your work in a feature branch and open a [pull request](https://help.github.com/articles/using-pull-requests).


If you're working on web files, you can pass `--deploy-only` (`-D`) to `install.sh` to not have to go through the entire install process, which should make development faster and easier.

If you don't want to update the css files pass `--no-sass` (`-C`) to `install.sh` and the script will skip `compass compile`.

License
------
Fiberdriver is licensed under the GPLv3 (<https://gnu.org/licenses/gpl.txt>)