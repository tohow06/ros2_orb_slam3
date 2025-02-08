#!/bin/bash

# Create a new tmux session
tmux new-session -d -s orb_slam

# Split the window horizontally
tmux split-window -h

# Setup and run C++ node in the first pane
tmux send-keys -t 0 "conda activate lac" C-m
tmux send-keys -t 0 "source /mnt/mydata/ASU_Lunar_Explorers/LunarAutonomyChallenge/ros_ws/install/setup.bash" C-m
tmux send-keys -t 0 "ros2 run ros2_orb_slam3 mono_node_cpp --ros-args \
    -p node_name_arg:=\"mono_slam_cpp\" \
    -p voc_file_arg:=\"/mnt/mydata/ASU_Lunar_Explorers/LunarAutonomyChallenge/ros_ws/src/ros2_orb_slam3/orb_slam3/Vocabulary/ORBvoc.txt.bin\" \
    -p settings_file_path_arg:=\"/mnt/mydata/ASU_Lunar_Explorers/LunarAutonomyChallenge/ros_ws/src/ros2_orb_slam3/orb_slam3/config/Monocular/\"" C-m

# Wait a moment for the C++ node to initialize
sleep 2

# Setup and run Python node in the second pane
tmux send-keys -t 1 "conda activate lac" C-m
tmux send-keys -t 1 "source /mnt/mydata/ASU_Lunar_Explorers/LunarAutonomyChallenge/ros_ws/install/setup.bash" C-m
tmux send-keys -t 1 "ros2 run ros2_orb_slam3 mono_driver_node.py --ros-args \
    -p settings_name:=EuRoC \
    -p image_seq:=sample_euroc_MH05 \
    -p dataset_path:=/mnt/mydata/ASU_Lunar_Explorers/LunarAutonomyChallenge/ros_ws/src/ros2_orb_slam3/TEST_DATASET" C-m

# Attach to the tmux session
tmux attach-session -t orb_slam