# General Workflow Idea for Releasing

Start Action Release(type : [Release, Prerelease, Dev]) ->  
if version is stable -> abort
if type == Release:
  bump version to stable
  if version != flatpak metadata version -> abort
  commit
  push


build artifacts:
  local flatpak
  wine version
  docker build (no push)
  pypi-test release

  (any error -> abort)

if type != Dev:
  remote call flathub (automerge if type == Release)
  docker build (push) // Tags stable, X.Y.Z, X.Y, X if type == Release, Tags: ci-$commithash always
  pypi (Pre-)release
  make local forgejo (Pre-)release
  make remote codeberg (Pre-)release
  make remote github (Pre-)release 
