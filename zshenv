export HASTHEENV=1

export PATH=~/config/util:$PATH
export PATH=~/local/bin:$PATH
export PATH=~/.local/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export LD_LIBRARY_PATH=~/local/lib/:~/.local/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=~/local/lib/:~/.local/lib:$LIBRARY_PATH
#TODO LIBRARY_PATH must not end with :
export DVORAK=1

#TODO ending with : is BAD
export CPATH=/home/bjorn/.local/include:$CPATH
export PATH=/usr/share/git/diff-highlight/:$PATH

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

if [[ -e ~/.zshenv_local ]]; then
    source ~/.zshenv_local;
fi

if which python &> /dev/null; then
    export PATH=`python ~/config2/util/pathclean.py`
fi
