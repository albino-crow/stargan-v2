FROM python:3.13-slim

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
CMD ["python", "app.py"]