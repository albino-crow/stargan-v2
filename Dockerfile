FROM python:3.12-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy pyproject.toml first for better layer caching
COPY pyproject.toml uv.lock* ./

# Install dependencies only (not the package itself)
RUN uv sync --frozen --no-install-project

# Copy the rest of the application
COPY . .

# Install the package itself
RUN uv pip install -e .

RUN pip install gdown && \
    gdown 1hT1pSRmmXilfK3bLKW_iuKjQWHoO61eD && \
    tar -xf dataset_96.zip

EXPOSE 8000
CMD ["uv", "run", "python", "main.py", "--img_size", "96", "--mode", "train", "--num_domains", "2", "--train_img_dir", "celeba_hq_96/celeba_hq/train", "--val_img_dir", "celeba_hq_96/celeba_hq/val", "--sample_dir", "expr/samples", "--resume_iter", "0", "--w_hpf", "0", "--lr", "0.0001", "--lambda_reg", "1", "--lambda_cyc", "1", "--lambda_sty", "1", "--lambda_ds", "1", "--batch_size", "8", "--total_iters", "100000"]
