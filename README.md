# comfyui-qwen-image-2512-workflow

ComfyUI workflow for Qwen-Image-2512 with optional Lightning 4-step LoRA. Dockerized via ComfyUI-wizard for Runpod Serverless.

## Build it yourself
```bash
docker build -t comfy-qwen-image-2512 .
docker run --rm --gpus all -p 8188:8188 comfy-qwen-image-2512
```

## Deploy on Runpod
1. Connect your repository at https://runpod.io/console/serverless
2. Create a new endpoint, select **Deploy from GitHub**
3. Pick this repo, branch `main`
4. Runpod's builder will build the Dockerfile and host the resulting image
5. Hit the endpoint with the API workflow JSON (`api-workflow.json` in this repo)

## Files
- `Dockerfile` — installs SageAttention, ComfyUI-TeaCache, and downloads the fp8 model, text encoder, VAE, and Lightning LoRA.
- `workflow.json` — the raw workflow, as you designed it in ComfyUI (usable in the web GUI).
- `api-workflow.json` — converted to ComfyUI's `/prompt` API shape (use this for serverless).
- `handler.py` — Runpod Serverless entry handler.
- `README.md` — this file
