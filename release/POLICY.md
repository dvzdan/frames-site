# Design release versioning policy

Double Take Frames uses Semantic Versioning 2.0.0 (https://semver.org/) for
the complete public design-file set. The public compatibility interface is the
fit, mating geometry, assembly relationship, and documented behavior of the
printed parts and specified hardware.

The release number is MAJOR.MINOR.PATCH:

- MAJOR: an incompatible change requiring users to replace, reprint, or
  rematch parts that previously worked together.
- MINOR: a backward-compatible new part, feature, option, or substantial
  improvement.
- PATCH: a backward-compatible correction to geometry, tolerance,
  documentation, metadata, or packaging.

Canonical files all share one release number. A modification to any released
file creates a new release number for the complete set; released contents are
never silently replaced. Pending Canon may use a SemVer pre-release such as
1.1.0-rc.1. Experimental work has no release number.

The repository privately retains every release using an annotated Git tag named
design-vMAJOR.MINOR.PATCH. The public website exposes only the current release,
but its release notes retain a human-readable change history.

Every public release requires:

1. VERSION, release/current.json, filenames, SCAD headers, 3MF metadata,
   release notes, and the website label to agree.
2. npm run release:prepare and npm test to pass.
3. A commit followed by the matching annotated Git tag.
4. Old public download files to be removed after the replacement set verifies.
