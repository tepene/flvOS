# [f]etchez [l]a [v]ache OS

A custom CentOS minimal image built for tiny home labs etc.

> **Warning**
> This project is "work in progress" and not ready for production.

## Features

- Based on a minnimal CentOS Stream 10
- K3s lightweight Kubernetes

## Justfile Documentation

The `Justfile` contains various commands and configurations for building and managing container images and virtual machine images using Podman and other utilities.
To use it, you must have installed [just](https://just.systems/man/en/introduction.html) from your package manager or manually. It is available by default on all Universal Blue images.

### Environment Variables

- `image_name`: The name of the image (default: "image-template").
- `default_tag`: The default tag for the image (default: "latest").
- `bib_image`: The Bootc Image Builder (BIB) image (default: "quay.io/centos-bootc/bootc-image-builder:latest").

### Building The Image

#### `just build`

Builds a container image using Podman.

```bash
just build $target_image $tag
```

Arguments:

- `$target_image`: The tag you want to apply to the image (default: `$image_name`).
- `$tag`: The tag for the image (default: `$default_tag`).

### Building and Running Virtual Machines and ISOs

The below commands all build QCOW2 images. To produce or use a different type of image, substitute in the command with that type in the place of `qcow2`. The available types are `qcow2`, `iso`, and `raw`.

#### `just build-qcow2`

Builds a QCOW2 virtual machine image.

```bash
just build-qcow2 $target_image $tag
```

#### `just rebuild-qcow2`

Rebuilds a QCOW2 virtual machine image.

```bash
just rebuild-vm $target_image $tag
```

#### `just run-vm-qcow2`

Runs a virtual machine from a QCOW2 image.

```bash
just run-vm-qcow2 $target_image $tag
```

#### `just spawn-vm`

Runs a virtual machine using systemd-vmspawn.

```bash
just spawn-vm rebuild="0" type="qcow2" ram="6G"
```

### File Management

#### `just check`

Checks the syntax of all `.just` files and the `Justfile`.

#### `just fix`

Fixes the syntax of all `.just` files and the `Justfile`.

#### `just clean`

Cleans the repository by removing build artifacts.

#### `just lint`

Runs shell check on all Bash scripts.

#### `just format`

Runs shfmt on all Bash scripts.

## Acknowledgments

This project is based on the [Universal Blue image template](https://github.com/ublue-os/image-template) though it's been added to significantly.
