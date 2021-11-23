# project-demo

demo the use with project object

see documentation in: https://docs.mlrun.org/en/latest/projects/overview.html

## Load & Run using MLRun SDK

When our project is already created and stored in a git archive we can quickly load and use it with the 
`mlrun.load_project()` method. `load_project` will use a local context directory (with initialized `git`) 
or clone a remote repo into the local dir and return a project object.

Users need to provide the path to the `context` dir and the git/zip/tar archive `url`, the `name` can be specified or taken 
from the project object, they can also specify `secrets` (repo credentials), `init_git` flag (to initialize git in the context dir), 
`clone` flag (indicating we must clone and ignore/remove local copy), and `user_project` flag (indicate the project name is unique to the user).

example, load a project from git and run the `main` workflow:

```python
project = mlrun.load_project("./", "git://github.com/mlrun/project-demo.git")
project.run("main", arguments={'data': data_url})
```

## Load & run using MLRun CLI

Loading a project from `git` into `./project` :

```
mlrun project -n myproj -u "git://github.com/mlrun/project-demo.git" ./project
```

Running a specific workflow (`main`) from the project stored in `.` (current dir):

```
mlrun project -r main -w ./project
```

