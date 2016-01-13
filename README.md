# dotvim

The intention of this repository is to store my vim configuration for all
platforms and vim usages in one place and with a single unified configuration.
Hopefully it will all work out.  I'm starting with my cygwin config and trying
to extend it to my regular Windows, Git bash, and eventually Solaris and Linux.

# Installation:

    git clone git://github.com/racosta/dotvim.git ~/.vim

## Create symlinks:

    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc

## Switch to the `~/.vim` directory, and fetch submodules:

    cd ~/.vim
    git submodule init
    git submodule update
