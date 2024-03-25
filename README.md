# docker-luna
Build remnrem/luna docker container

![CI](https://github.com/remnrem/docker-luna/workflows/CI/badge.svg)

### Building luna docker For multiple platforms
```python
docker buildx build --platform=linux/arm64,linux/amd64 --push --tag remnrem/luna:latest .
```

### Building lunaapi docker For multiple platforms
```python
docker buildx build -f Dockerfile.lunapi --platform=linux/arm64,linux/amd64 --push --tag remnrem/lunapi:latest
```
