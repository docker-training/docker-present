# docker-present

A presentation engine for official Docker training

## Overview

**docker-present** is a custom engine that compiles/serves presentations using [RevealJS](https://github.com/hakimel/reveal.js/).

Provides:

- The option to split up the different sections of your presentation into 'modules' (instead of only using one file)
- Create a presentation outline file and specify which modules you want included in each presentation
- On launch, provides a prompt menu for selecting a presentation to serve
- After selecting a presentation. The engine compiles the presentation and serves it on the port specified
- The engine & presentations are bundled and distributed using Docker images

For instructions on how to create modules and presentations see the related Github repository: https://github.com/docker-training/presentations

## Usage

Pull the image:

```
kizbitz@docker:~$ docker pull training/docker-present
Using default tag: latest
latest: Pulling from training/docker-present
dbacfa057b30: Pull complete

--- removed ---

0df5b3ba9e25: Pull complete
Digest: sha256:168922341fcec9f2ec78ec8b1f62ca461b8218624c79501acfec80c49c2441bb
Status: Downloaded newer image for training/docker-present:latest
```

### Help

Launching a container from the image without any arguments will display the help (or use the `-h` flag):

```
kizbitz@docker:~$ docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock training/docker-present

docker-present

  A RevealJS Engine

  Available Options:

    -h    Display help
    -p    Specify port (required)

  Usage:

    docker run -ti --rm --name=docker-present -v /var/run/docker.sock:/var/run/docker.sock training/docker-present -p <port>
```

### Running a presentation:

**Note:** Mounting the Docker socket and specifying a port is required.

```
kizbitz@docker:~$ docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock training/docker-present -p 8000
```

Select a presentation to serve from the menu:

```
kizbitz@docker:~$ docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock training/docker-present -p 8000

Available Presentations:

1) presentation1
2) presentation2
3) presentation3

Enter selection: 2
Attempting to start presentation 'presentation2' on port: 8000 ...
bfaf705df7ea57419e5d9d33c9e50b72e183e81a34cc3a1d25a61f0fb0d72304
kizbitz@docker:~$
```

### Run a custom/one-off presentation

You can use a custom/one-off presentation file by:

- Creating a new temporary presentation file on your local host (See: https://github.com/docker-training/presentations)
- Launch a new container and pass in your file by mounting it to the path: `/full/host/path/to/<file>:/opt/revealjs/src/presentations/<filename>`

Example:

```
kizbitz@docker:~$ docker run -ti -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/custom:/opt/revealjs/src/presentations/custom training/docker-present -p 8000

Available Presentations:

1) custom
2) presentation1
3) presentation2
4) presentation3

Enter selection: 1
```

## Templates

To customize the theme modify the following files:

- The base index.html: https://github.com/docker-training/docker-present/blob/master/present/templates/index.html
  - Note: These lines must stay in the template. The engine replaces with the presentation section: https://github.com/docker-training/docker-present/blob/master/present/templates/index.html#L39-L43
- The primary css file: https://github.com/docker-training/docker-present/blob/master/present/css/docker.css
- The code syntax highlighting css file: https://github.com/docker-training/docker-present/blob/master/present/css/docker-code.css