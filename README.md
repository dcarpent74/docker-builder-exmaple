Building the centos7 builder container:

```docker build --progress plain -t mybuilder .```

Running a default dynamic library build with the builder:

```docker run -it --mount type=bind,source=$(pwd)/source,target=/src --rm mybuilder```

Running a static build with the builder:

```docker run -it --mount type=bind,source=$(pwd)/source,target=/src --rm mybuilder "make clean ; make install-static"```

Building the hello container:

```docker build --progress plain -t hello -f Dockerfile.hello source```

The intent is to demonstrate a Docker nuild environment container.
First I start with an arbitrary build container base.  Depending
on what I am building, I would likely select a container reflecting
my target platform.  For something like this example it does not
really matter, but for certain kinds of products you need to be
more careful about the platform selection, or you need to make sure
your toolchains are properly configured for the target systems.
Usually that means a bit of both when you are building kernel modules
and O/S middleware products.

Here this means: gcc make glibc-static

gcc and make are really all that is required to build a helo-world,
but in this case my other intent was to demonstrate a scratch
container with nothing in it but a single static binray.  The
glibc-static package was required to accomplish a proper static
compile.

I've also added sudo and a user configuration to the container.
This would maintain the discipline of building code not as root
as much as possible (i.e. I don't want to encourage builds that
require building as root if I can avoid it even though arguably
container build environments are a way to try to make such builds
safer.  Safety first, we will still wait to allow risky builds
until it is absolutely warranted.

So why sudo? We will consider this a build environment still
under construction.  I may want to exec into this container to
debug my builds.  For a true production environment, I might
build my container in such a way as to discourage any such
debugging in service of a more secure pipeline.  In such a case,
I might define a multi-stage docker build stripped down
to just my toolchain dependencies and then have another path
defining the builder's debug container, and yet another potential
path defining a developer's build container with additional
devloper tools built in or simply defined to be extensible as
appropriate for the product's development needs.

Thus, I am a fan of picking a minimal O/S installation as close to
my target as possible (usually an older install which implies my
minimum supported target O/S level) and then I would define a
build environment for my product such that the additional software
installed reflects as closely as possible the build requirements
for my code.

The build protocol for this container is that it will automatically
run the following sewuence of build commands:
make clean
make
make install

All of these occur in the container under the /src directory
(owned by the unprivledged build user).  Make and make clean and
make are inteded to only run usr /src (though that should be
considered arbitrary here, just dont assume anything about
the directories above the top level Makefile).  And "make install"
will install into a installation root subdirectory in the same
local file tree.

Since our target container is a scratch container our linkage
between the C build and the container build container is the
inst-root sub-directory the contents of inst-root will be
what represents the root filesystem in the target container.

I have also included a rudimentary script to determine runtime
dependencies (using ldd) and copy those into the target container
for non static builds.  However, as built this is only suitable
for build outputs with a single binary output (in this case "hello").
