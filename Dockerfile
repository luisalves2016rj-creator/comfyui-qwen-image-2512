# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# build-time tokens for gated downloads — never baked into final image.
ARG HF_TOKEN=""

# Install SageAttention and TeaCache custom nodes
RUN comfy node install --exit-on-fail https://github.com/welltop-cn/ComfyUI-TeaCache.git --mode remote
RUN pip install sageattention

# Download Qwen-Image-2512 Models into comfyui directories
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do \
    HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors' --relative-path models/vae --filename 'qwen_image_vae.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "VAE download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && sleep $SLEEP; done

RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do \
    HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors' --relative-path models/text_encoders --filename 'qwen_2.5_vl_7b_fp8_scaled.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "Text Encoder download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && sleep $SLEEP; done

RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do \
    HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_2512_fp8_e4m3fn.safetensors' --relative-path models/diffusion_models --filename 'qwen_image_2512_fp8_e4m3fn.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "Diffusion Model download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && sleep $SLEEP; done

RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do \
    HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/lightx2v/Qwen-Image-2512-Lightning/resolve/main/Qwen-Image-2512-Lightning-4steps-V1.0-fp32.safetensors' --relative-path models/loras --filename 'Qwen-Image-2512-Lightning-4steps-V1.0-fp32.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "LoRA download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && sleep $SLEEP; done
