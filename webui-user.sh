#!/bin/bash
#########################################################
# Uncomment and change the variables below to your need:#
#########################################################

# Change dir and setting for Casdao platform
models_dir="$HOME/fssd/models"
clip_models_path="$models_dir/CLIP"
vae_dir="$models_dir/VAE"
text_encoder_dir="$models_dir/text_encoder"

export GRADIO_TEMP_DIR="$HOME/fssd/tmp"
export HUGGINGFACE_HUB_CACHE="$HOME/fssd/HF_cache"
export HF_HOME="$HOME/fssd/HF"
export HF_HUB_ENABLE_HF_TRANSFER=1

# Copy files and models from folder of the scipts to the fssd for Casdao platform
if [ ! -d $models_dir ]
then
    mkdir -p $HOME/fssd/models
fi

echo "################################################################"
echo "Copy models folder from $HOME/stable-diffusion-webui to fssd ..."
time cp -r -n $HOME/stable-diffusion-webui/models $HOME/fssd
echo "################################################################"
echo "Copy text encoder models for flux from fshare/models/comfyanonymous/flux_text_encoders to $text_encoder_dir"
time cp -n -v $HOME/fshare/models/comfyanonymous/flux_text_encoders/t5xxl_fp16.safetensors $text_encoder_dir

echo "################################################################"
echo "Copy Flux-dev to $models_dir/Stable-diffusion"
total_memory=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)
if [ $total_memory -gt 25000 ]
then
    time cp -n -v $HOME/fshare/models/black-forest-labs/FLUX.1-dev/flux1-dev.safetensors $models_dir/Stable-diffusion
else
    time cp -n -v $HOME/fshare/models/Comfy-Org/flux1-dev/flux1-dev-fp8.safetensors $models_dir/Stable-diffusion
fi

echo "################################################################"
echo "Copy Flux-dev LoRAs to $models_dir/Lora"
x_flux_lora="$HOME/fshare/models/XLabs-AI/flux-lora-collection"
cp -n -v $x_flux_lora/anime_lora.safetensors $models_dir/Lora
cp -n -v $x_flux_lora/art_lora.safetensors $models_dir/Lora
cp -n -v $x_flux_lora/disney_lora.safetensors $models_dir/Lora
cp -n -v $x_flux_lora/furry_lora.safetensors $models_dir/Lora
cp -n -v $x_flux_lora/mjv6_lora.safetensors $models_dir/Lora
cp -n -v $x_flux_lora/realism_lora.safetensors $models_dir/Lora
cp -n -v $x_flux_lora/scenery_lora.safetensors $models_dir/Lora

echo "################################################################"

# Install directory without trailing slash
#install_dir="/home/$(whoami)"

# Name of the subdirectory
#clone_dir="stable-diffusion-webui"

# Commandline arguments for webui.py, for example: export COMMANDLINE_ARGS="--medvram --opt-split-attention"
export COMMANDLINE_ARGS="--cuda-malloc --listen --xformers --skip-python-version-check --skip-torch-cuda-test --skip-prepare-environment --models-dir $models_dir --clip-models-path $clip_models_path --text-encoder-dir $text_encoder_dir --vae-dir $vae_dir --enable-insecure-extension-access"

# python3 executable
#python_cmd="python3"

# git executable
#export GIT="git"

# python3 venv without trailing slash (defaults to ${install_dir}/${clone_dir}/venv)
venv_dir="-"

# script to launch to start the app
export LAUNCH_SCRIPT="launch.py"

# install command for torch
#export TORCH_COMMAND="pip install torch==1.12.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113"

# Requirements file to use for stable-diffusion-webui
#export REQS_FILE="requirements_versions.txt"

# Fixed git repos
#export K_DIFFUSION_PACKAGE=""
#export GFPGAN_PACKAGE=""

# Fixed git commits
#export STABLE_DIFFUSION_COMMIT_HASH=""
#export CODEFORMER_COMMIT_HASH=""
#export BLIP_COMMIT_HASH=""

# Uncomment to enable accelerated launch
export ACCELERATE="True"

# Uncomment to disable TCMalloc
export NO_TCMALLOC="True"

###########################################
