#!/bin/bash

FILE_PATH=$(/bin/realpath "${BASH_SOURCE:-$0}")
CWD=$(dirname "$FILE_PATH")
PRJ_PATH=$(dirname "$CWD")
echo "Project path: $PRJ_PATH"

GLOBAL_PYTHON='/usr/local/bin/python3'

if [ ! -f $GLOBAL_PYTHON ]; then
    GLOBAL_PYTHON='/usr/bin/python3'
fi

if [ ! -f $GLOBAL_PYTHON ]; then
    echo "Python3 is not installed"
    exit 1
fi

echo "Using global python: $GLOBAL_PYTHON"

VENV_DIR=$CWD"/venv"
ACTIVATE=$VENV_DIR"/bin/activate"

if [ ! -d $VENV_DIR ]; then
    # Take action if $VENV_DIR exists. #
    mkdir $VENV_DIR
    $GLOBAL_PYTHON -m venv $VENV_DIR

    source $VENV_DIR/bin/activate
    pip install --upgrade pip
    pip install -r requirements_linux.txt
else
    echo "Virtual environment folder already exists"
fi

if grep -Faq "$VENV_DIR" $ACTIVATE; then
    # code if found
    echo "Virtual environment is ready to use"
else
    # code if not found
    echo "Virtual environment is incorrect, recreating..."

    rm -rf $VENV_DIR

    # Take action if $VENV_DIR exists. #
    mkdir $VENV_DIR
    $GLOBAL_PYTHON -m venv $VENV_DIR

    source $VENV_DIR/bin/activate
    pip install --upgrade pip
    pip install -r requirements_linux.txt
fi

. $VENV_DIR/bin/activate

# run
echo "Running script..."

export 'PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:4096'
python ./kohya_gui.py --listen 0.0.0.0 --server_port 7960 --headless
