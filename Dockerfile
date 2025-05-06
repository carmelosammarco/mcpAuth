FROM python:alpine

# Install miniconda
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add conda to path
ENV PATH=/opt/conda/bin:$PATH

# Copy environment.yml
COPY environment.yml /app/environment.yml

# Create conda environment
RUN conda env create -f /app/environment.yml

# Set up conda environment activation
SHELL ["/bin/bash", "-c"]
RUN echo "source activate mcp-authentication" > ~/.bashrc
ENV PATH=/opt/conda/envs/mcp-authentication/bin:$PATH

# Set working directory
WORKDIR /app

# Copy application code
COPY src/ /app/src/
# COPY .env /app/.env

# Set Python path
ENV PYTHONPATH="/app/src"

# Make sure pip dependencies are installed explicitly for the Docker env
RUN /opt/conda/envs/mcp-authentication/bin/pip install mcp mcp[cli] starlette uvicorn requests

# Expose port
EXPOSE 3005

# Run the application
CMD ["conda", "run", "--no-capture-output", "-n", "mcp-authentication", "python", "/app/src/server.py"] 