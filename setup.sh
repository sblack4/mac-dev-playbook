#!/bin/bash


echo '--- disable press and hold ---'
defaults write -g ApplePressAndHoldEnabled -bool false

echo '--- installing pyenv ---'
if [ ! $SKIP_PACKAGES ] ; then
    brew install pyenv pyenv-virtualenv
    brew upgrade pyenv pyenv-virtualenv
fi

if ! grep -q "### BEGIN pyenv" ~/.zshrc ; then
    cat << __END__ >> ~/.zshrc
### BEGIN pyenv
export PYENV_ROOT="\$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:\$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "\$(pyenv init -)"
fi
### END pyenv
__END__
fi

if ! grep -q "### BEGIN pyenv" ~/.bash_profile ; then
    cat << __END__ >> ~/.bash_profile
### BEGIN pyenv
export PYENV_ROOT="\$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:\$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "\$(pyenv init -)"
fi
### END pyenv
__END__
fi

echo '--- configuring python with pyenv ---'
pyenv install
cat .python-version | pyenv global

echo '--- installing pip ---'
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py

echo '--- installing ansible ---'
pip install ansible

echo '--- downloading required ansible roles ---'
ansible-galaxy install -r requirements.yml

echo ''
echo 'you have completed the trials and are ready to run ansible-playbook main.yml -i inventory -K'