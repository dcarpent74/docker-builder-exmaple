Building the centos7 builder container:

```docker build --progress plain -t mybuilder .```

Running a default dynamic library build with the builder:

```docker run -it --mount type=bind,source=$(pwd)/source,target=/src --rm mybuilder```

Running a static build with the builder:

```docker run -it --mount type=bind,source=$(pwd)/source,target=/src --rm mybuilder "make clean ; make install-static"```

Building the hello container:

```docker build --progress plain -t hello -f Dockerfile.hello source```
