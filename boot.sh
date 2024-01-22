#Stop the background process
sudo hciconfig hci0 down
sudo systemctl daemon-reload
sudo /etc/init.d/bluetooth start
# Update  mac address
./updateMac.sh
#Update Name
./updateName.sh i-am-not-keyboard-and-mouse
#Get current Path
export C_PATH=$(pwd)

tmux kill-window -t npl:app >/dev/null 2>&1

[ ! -z "$(tmux has-session -t npl 2>&1)" ] && tmux new-session -s npl -n app -d
[ ! -z "$(tmux has-session -t npl:app 2>&1)" ] && {
    tmux new-window -t npl -n app
}
[ ! -z "$(tmux has-session -t npl:app.1 2>&1)" ] && tmux split-window -t npl:app -h
[ ! -z "$(tmux has-session -t npl:app.2 2>&1)" ] && tmux split-window -t npl:app.1 -v
tmux send-keys -t npl:app.0 'cd $C_PATH/server && sudo ./btk_server.py' C-m
tmux send-keys -t npl:app.1 'cd $C_PATH/mouse  && reset' C-m
tmux send-keys -t npl:app.2 'cd $C_PATH/keyboard  && reset' C-m

# run keyboard and mouse scripts
tmux send-keys -t npl:app.1 'python mouse_emulate.py' C-m
tmux send-keys -t npl:app.2 'python keyboard_emulate.py' C-m