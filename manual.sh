# Chrome: On Startup -> continue when you left  (checked)

#MANUAL

# https://askubuntu.com/questions/539243/how-to-change-visudo-editor-from-nano-to-vim
# sudo update-alternatives --config editor #change nano editor to vim
# sudo visudo
# !env_reset
# to keep env variables in sudo
# https://unixhealthcheck.com/blog?id=363
# secure_path extend with echo $PATH

#protobuf
if ! grep -qF "protobuf" ~/.bashrc; then
    #https://developers.google.com/protocol-buffers/docs/gotutorial
    wget https://github.com/protocolbuffers/protobuf/releases/download/v3.20.1/protoc-3.20.1-linux-x86_64.zip && \
    sudo unzip protoc-3.20.1-linux-x86_64.zip -d /usr/local/protobuf &&
    echo 'export PATH=$PATH:/usr/local/protobuf/bin' >> ~/.bashrc && source ~/.bashrc
    # protoc -I=. --go_out=./internal/twitter ./internal/twitter/example.proto
    # for go installation: export PATH=$PATH:/usr/local/go/bin:/home/max/go/bin
    # go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
fi