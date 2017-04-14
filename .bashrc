# .bashrc
if [ -f ~/.profile ]; then
    source ~/.profile
fi

# Google Cloud SDK
if [ -d $GOOGLE_CLOUD_SDK ]; then
    source $GOOGLE_CLOUD_SDK/completion.bash.inc
fi

