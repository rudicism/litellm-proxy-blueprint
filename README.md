# LiteLLM Proxy Blueprint (one-click deploy)

This folder is the **deploy blueprint** the Proxy Setup wizard's *"Deploy to a host — no terminal"* button points at. It lets a non-technical consultant stand up a client's cost-tracking proxy with clicks only — no terminal, no Docker install.

## ⚠️ One-time activation (Scott does this once)

The wizard button links to `https://render.com/deploy?repo=<THIS REPO>`. For that to work, these files must live in a **public GitHub repo of their own**:

1. Create a new public repo named **`litellm-proxy-blueprint`** under the `rudicism` account.
2. Copy the four files in this folder (`Dockerfile`, `litellm-config.yaml`, `render.yaml`, `README.md`) into the root of that repo and push.
3. If you use a different repo name/owner, update `BLUEPRINT_REPO` at the top of `ai-cost-suite/src/tools/SetupWizard.jsx` to match.
4. Do a **test deploy** (this is a rehearsal step in `FIELD_TEST_PLAN.md`) and confirm the items under "Verify" below.

## What a deploy does
- Render reads `render.yaml`, builds the `Dockerfile` (LiteLLM + this config), and runs it as an HTTPS web service.
- The provider keys and `LITELLM_MASTER_KEY` are entered in Render's UI (marked `sync: false`, so they're never in the repo).
- The app then points at `https://<service>.onrender.com/v1` and calls models by alias (`budget` / `balanced` / `top`).

## Verify (in the rehearsal — this is a beta path)
- [ ] The service reaches **Live** in Render (no build/port errors).
- [ ] `https://<service>.onrender.com/health` (or the LiteLLM UI at `/ui`) responds.
- [ ] A test chat completion against alias `balanced` returns a reply.
- [ ] If the port is wrong, adjust `PORT` in `render.yaml` / the `--port` in the `Dockerfile` so they match what Render routes to.

## Notes
- **Tracing/Langfuse is not bundled in the hosted blueprint** (self-hosting Langfuse + a database on Render is heavier). For hosted deploys, the simplest trace path is **Langfuse Cloud's free tier** — add its `LANGFUSE_PUBLIC_KEY` / `LANGFUSE_SECRET_KEY` / `LANGFUSE_HOST` as env vars and `success_callback: ["langfuse"]` to the config. Hardening this is a follow-up.
- The model list here is a sensible Anthropic default; edit it (or add OpenAI/Gemini aliases) to match the client.
