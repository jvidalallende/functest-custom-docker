FROM opnfv/functest:latest

MAINTAINER juan.vidal.allende@ericsson.com

RUN apt-get update && apt-get install -y vim-nox ctags git-review python-flake8 python-jedi

# Haste binary, stdout to haste to automatically upload text snippets
RUN wget https://raw.githubusercontent.com/jvidalallende/Hastebin-client/master/haste.bash -O /bin/haste \
    && chmod +x /bin/haste

# Git completion
RUN wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash \
    -O /home/opnfv/.git-completion.bash

# Configuration files
RUN mkdir /home/opnfv/GIT \
    && git clone https://github.com/jvidalallende/config-files.git /home/opnfv/GIT/config-files \
    && git clone https://github.com/drmad/tmux-git /home/opnfv/GIT/tmux-git \
    && mv /home/opnfv/.vimrc /home/opnfv/.vimrc.bak \
    && ln -s /home/opnfv/GIT/config-files/vimrc /home/opnfv/.vimrc \
    && ln -s /home/opnfv/GIT/config-files/vim /home/opnfv/.vim \
    && ln -s /home/opnfv/GIT/config-files/tmux.conf /home/opnfv/.tmux.conf \
    && ln -s /home/opnfv/GIT/config-files/bash_aliases /home/opnfv/.bash_aliases \
    && mv /home/opnfv/.gitconfig /home/opnfv/.gitconfig.bak \
    && ln -s /home/opnfv/GIT/config-files/gitconfig /home/opnfv/.gitconfig\
    && ln -s /home/opnfv/GIT/config-files/gitignore_global /home/opnfv/.gitignore_global\
    && echo '. /home/opnfv/GIT/config-files/bashrc' >> /home/opnfv/.bashrc \
    && echo '. /home/opnfv/.bashrc' >> /home/opnfv/.bash_profile \

# Git configuration
# http.sslverify is a default in functest container, so do not override it
RUN git config --global user.name "Juan Vidal" \
    && git config --global user.email "juan.vidal.allende@ericsson.com" \
    && git config --global gerrit.user "JuanVidal" \
    && git config --global http.sslverify false

# Generate SSH Keys
RUN ssh-keygen -trsa -f /root/.ssh/id_rsa -N '' \
    && echo "" \
    && echo "Your public SSH key is:" \
    && echo "=========================================================" \
    && cat /root/.ssh/id_rsa.pub \
    && echo "=========================================================" \
    && echo ""
