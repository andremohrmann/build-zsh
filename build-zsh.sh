#!/bin/bash
# Build zsh from http://zsh.sourceforge.net/Arc/git.html and sources INSTALL file on debian 
# Purge previous versions (from packages) before installing from source!

# Make exits on error
set -e

# Install needed packages
sudo apt-get install -y git-core gcc make autoconf yodl libncursesw5-dev texinfo checkinstall

# Clone zsh repo and change into it
git clone git://git.code.sf.net/p/zsh/code zsh
cd zsh

# Get lastest stable version
BRANCH=$(git describe --abbrev=0 --tags)
# Get version number, and revision/commit id when this is available
ZSH_VERSION=$(echo $BRANCH | cut -d '-' -f2,3,4)
# Checkout desired branch
git checkout $BRANCH

# Build configure script
./Util/preconfig

# Options from debian jessie zsh package rules file
./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --bindir=/bin \
            --infodir=/usr/share/info \
            --enable-maildir-support \
            --enable-max-jobtable-size=256 \
            --enable-etcdir=/etc/zsh \
            --enable-function-subdirs \
            --enable-site-fndir=/usr/local/share/zsh/site-functions \
            --enable-fndir=/usr/share/zsh/functions \
            --with-tcsetpgrp \
            --with-term-lib="ncursesw tinfo" \
            --enable-cap \
            --enable-pcre \
            --enable-readnullcmd=pager \
            --enable-custom-patchlevel=Debian \
            --enable-additional-fpath=/usr/share/zsh/vendor-functions,/usr/share/zsh/vendor-completions \
            --disable-ansi2knr
            LDFLAGS="-Wl,--as-needed -g -Wl,-Bsymbolic-functions -Wl,-z,relro"



# Compile, test and install
make
make check
make install

# Add zsh to available shells
sudo sh -c "echo /bin/zsh >> /etc/shells"

# Change default shell to zsh
chsh -s $(which zsh)
