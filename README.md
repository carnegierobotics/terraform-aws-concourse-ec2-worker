# terraform-aws-concourse-ecs-worker
This code is a modified version of the `ecs-worker` submodule, which is part of the [terraform-concourse](https://github.com/skyscrapers/terraform-concourse/) module by Skyscrapers.

## Changes
The module was extracted into its own repository to be better compliant with the [CloudPosse](https://github.com/cloudposse) tooling. Additionally, some resource names were changed. Where applicable, resources were labelled with the [terraform-null-label](https://github.com/cloudposse/terraform-null-label) module.
