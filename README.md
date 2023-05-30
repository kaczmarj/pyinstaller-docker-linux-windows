# Dockerized PyInstaller to build apps for Linux and Windows

# Example

Build the Docker image:

```bash
docker build -t kaczmarj/pyinstaller-docker linux/
```

Build a PyInstaller app:

```bash
docker run --rm -it -u $(id -u):$(id -g) \
    -v /path/to/code:/work kaczmarj/pyinstaller-docker --onefile --clean --name myapp script.py
```
