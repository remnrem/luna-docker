# docker-luna
Build remnrem/luna docker container

![CI](https://github.com/remnrem/docker-luna/workflows/CI/badge.svg)

### Building luna docker for multiple platforms
```python
docker buildx build --platform=linux/arm64,linux/amd64 --push --tag remnrem/luna:latest .
```

### Building lunapi docker for multiple platforms
```python
docker buildx build -f Dockerfile.lunapi --platform=linux/arm64,linux/amd64 --push --tag remnrem/lunapi:latest
```
### Building lunalite docker for mutiple platforms
```python
docker buildx build -f Dockerfile.lite --platform=linux/arm64,linux/amd64 --push --tag remnrem/lunalite:latest
```
