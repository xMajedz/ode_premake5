# Premake5 script for building Open Dynamics Engine.
this is adapted from the original premake4.lua in the ode repository, and adjusted for premake5.
# Usage
generate project files
```
premake5 gmake --ode-path=ode --with-demos --with-tests
```
building
```
make -C ode/build config=release_doublestatic
```
