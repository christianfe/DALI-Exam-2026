#!/bin/bash

# Enable debugging
# set -x  # Start debugging

#clear  # Clear the terminal

# Save the current directory to a variable
current_dir=$(pwd)

# Print the current directory
echo "The current directory is: $current_dir"

# Test if tmux is installed
if command -v tmux &> /dev/null; then
    echo "tmux is installed."
    tmux -V  # Display tmux version
else
    echo "TMUX is a requirement in Unix-like OS to run DALI"
    echo "tmux is not installed."
    echo "Check installation instructions at https://github.com/tmux/tmux/wiki/Installing"
    exit -1
fi

# Create or attach to the tmux session
# tmux new-session -d -s DALI_session top

# Define paths and variables
#SICSTUS_HOME=/usr/local/sicstus4.6.0
MAIN_HOME=../..
DALI_HOME=src
CONF_DIR=conf
PROLOG="sicstus"
WAIT="sleep 2.5"
INSTANCES_HOME=mas_linux/instances
TYPES_HOME=mas_linux/types
BUILD_HOME=build

# Check if SICStus Prolog exists and is executable
if [[ -x "$PROLOG" ]]; then
  printf "SICStus Prolog found at %s\n" "$PROLOG"
else
  printf "Error: SICStus Prolog not found at %s or is not executable.\n" "$PROLOG" >&2
#   exit 1
fi

# Clean directories
rm -rf tmp/*
rm -rf build/*
rm -f work/*  # Remove agent history
rm -rf conf/mas/*

# Build agents based on instances
for instance_filename in $INSTANCES_HOME/*.txt; do
    type=$(<$instance_filename)  # Agent type name is the content of the instance file
    type_filename="$TYPES_HOME/$type.txt"
    echo "Instance: " $instance_filename " of type: " $type_filename
    instance_base="${instance_filename##*/}"  # Extract instance base name
    cat "$type_filename" >> "$BUILD_HOME/$instance_base"
done

ls $BUILD_HOME
cp $BUILD_HOME/*.txt work

# Start the LINDA server in a new console
srvcmd="$PROLOG --noinfo -l $DALI_HOME/active_server_wi.pl --goal go(3010,'server.txt')."
echo "server: " $srvcmd

tmux kill-session -t DALI_session 2>/dev/null || true
tmux new-session -d -s DALI_session $srvcmd


echo "Server ready. Starting the MAS..."
$WAIT > /dev/null  # Wait for a while

# Start user agent in another vertical split
tmux split-window -v -t DALI_session:0 "$PROLOG --noinfo -l $DALI_HOME/active_user_wi.pl --goal utente."
echo "Launching agents instances..."
$WAIT > /dev/null  # Wait for a while

# --- ONE WINDOW with all agents as panes (max 12) ---
tmux new-window -t DALI_session -n agents
tmux rename-window -t DALI_session:agents "agents"
tmux set-window-option -t DALI_session:agents automatic-rename off
tmux set-window-option -t DALI_session:agents allow-rename off

tmux set-option -t DALI_session -g pane-border-status top
tmux set-option -t DALI_session -g pane-border-format "#T"


pane_count=0

# helper: choose the largest pane to split (reduces "no space for new pane")
largest_pane() {
  tmux list-panes -t DALI_session:agents -F "#{pane_id} #{pane_width} #{pane_height}" \
  | awk '{print $1, $2*$3}' \
  | sort -nr -k2 \
  | head -n 1 \
  | awk '{print $1}'
}

for agent_filename in $BUILD_HOME/*; do
    agent_base="${agent_filename##*/}"
    echo "Agent: $agent_base"

    # Create the agent configuration
    $current_dir/conf/makeconf.sh $agent_base $DALI_HOME

    if [ "$pane_count" -eq 0 ]; then
        # first agent runs in pane 0
        tmux send-keys -t DALI_session:agents.0 \
          "$current_dir/conf/startagent.sh $agent_base $PROLOG $DALI_HOME" C-m
        tmux select-pane -t DALI_session:agents.0 -T "$agent_base"
        pane_count=1
        tmux select-layout -t DALI_session:agents tiled
        $WAIT > /dev/null
        continue
    fi


    # split the largest pane (best chance to avoid 'no space')
    tgt="$(largest_pane)"

    # decide split direction: if wide, split horizontally; else vertically
    dims=$(tmux display-message -p -t "$tgt" "#{pane_width} #{pane_height}")
    w=$(echo "$dims" | awk '{print $1}')
    h=$(echo "$dims" | awk '{print $2}')

    if [ "$w" -gt "$h" ]; then
      tmux split-window -h -t "$tgt" \
        "$current_dir/conf/startagent.sh $agent_base $PROLOG $DALI_HOME"
    else
      tmux split-window -v -t "$tgt" \
        "$current_dir/conf/startagent.sh $agent_base $PROLOG $DALI_HOME"
    fi

    # set title on the *new* active pane
    tmux select-pane -T "$agent_base"

    pane_count=$((pane_count + 1))
    tmux select-layout -t DALI_session:agents tiled

    $WAIT > /dev/null
done


echo "MAS started."



# Select an even layout to properly display the panes
# tmux select-layout -t DALI_session tiled
tmux select-layout -t DALI_session:agents tiled


# Attach to the session so you can see everything
tmux attach -t DALI_session

echo "Press Enter to shutdown the MAS"
read

# Clean up processes
killall sicstus