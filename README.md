# unibench-build-all
Build unibench targets with different compilers and optimization levels.

```bash
docker pull zjuchenyuan/base
docker run -dit --name unibench-build zjuchenyuan/base
docker cp build_all.sh /root/
docker exec -it unibench-build bash
# in docker container unibench-build
bash ~/build_all.sh
```


