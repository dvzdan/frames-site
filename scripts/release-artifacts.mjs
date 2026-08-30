import { createHash } from "node:crypto";
import { spawnSync } from "node:child_process";
import { copyFile, readFile, readdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const releasePath = path.join(repoRoot, "release", "current.json");
const manifestPath = path.join(repoRoot, "release", "artifact-manifest.json");
const release = JSON.parse(await readFile(releasePath, "utf8"));
const semverPattern = /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[A-Za-z-][0-9A-Za-z-]*)(?:\.(?:0|[1-9]\d*|\d*[A-Za-z-][0-9A-Za-z-]*))*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?$/;

function absolute(relativePath) {
  return path.join(repoRoot, ...relativePath.split("/"));
}

function hash(buffer) {
  return createHash("sha256").update(buffer).digest("hex");
}

async function entriesFromSources() {
  const artifacts = await Promise.all(release.artifacts.map(async (artifact) => ({
    id: artifact.id,
    type: artifact.type,
    source: artifact.source,
    public: artifact.public,
    sha256: hash(await readFile(absolute(artifact.source))),
  })));
  const notes = {
    id: "release-notes",
    type: "release-notes",
    source: release.releaseNotesSource,
    public: release.releaseNotesPublic,
    sha256: hash(await readFile(absolute(release.releaseNotesSource))),
  };
  return [...artifacts, notes];
}

async function sync() {
  const entries = await entriesFromSources();
  for (const entry of entries) {
    await copyFile(absolute(entry.source), absolute(entry.public));
  }
  const manifest = {
    schemaVersion: 1,
    version: release.version,
    versionStandard: release.versionStandard,
    files: entries,
  };
  await writeFile(manifestPath, JSON.stringify(manifest, null, 2) + "\n", "utf8");
  console.log("Synchronized " + entries.length + " files for design release " + release.version + ".");
}

async function check() {
  const problems = [];
  if (release.versionStandard !== "Semantic Versioning 2.0.0") {
    problems.push("release standard is not Semantic Versioning 2.0.0");
  }
  if (!semverPattern.test(release.version)) problems.push("invalid Semantic Version: " + release.version);

  const versionFile = (await readFile(path.join(repoRoot, "VERSION"), "utf8")).trim();
  if (versionFile !== release.version) problems.push("VERSION differs from release/current.json");

  const history = await readFile(path.join(repoRoot, "release", "RELEASE_NOTES.md"), "utf8");
  if (!history.includes("## " + release.version + " - " + release.releaseDate)) {
    problems.push("release history lacks the current version/date heading");
  }

  const expected = await entriesFromSources();
  for (const artifact of release.artifacts) {
    if (!path.basename(artifact.public).includes("v" + release.version)) {
      problems.push(artifact.id + " public filename does not contain v" + release.version);
    }
    if (artifact.type === "3mf-project" && !artifact.public.endsWith(".project.3mf")) {
      problems.push(artifact.id + " does not use the standard .project.3mf suffix");
    }
    if (artifact.type === "scad") {
      const sourceText = await readFile(absolute(artifact.source), "utf8");
      if (!sourceText.includes("// DTF_RELEASE: " + release.version)) {
        problems.push(artifact.id + " SCAD header lacks the current release marker");
      }
    }
  }

  for (const entry of expected) {
    try {
      const publicHash = hash(await readFile(absolute(entry.public)));
      if (publicHash !== entry.sha256) problems.push(entry.public + " differs from " + entry.source);
    } catch {
      problems.push("public release file is missing: " + entry.public);
    }
  }

  try {
    const manifest = JSON.parse(await readFile(manifestPath, "utf8"));
    const expectedManifest = {
      schemaVersion: 1,
      version: release.version,
      versionStandard: release.versionStandard,
      files: expected,
    };
    if (JSON.stringify(manifest) !== JSON.stringify(expectedManifest)) {
      problems.push("release artifact manifest is stale");
    }
  } catch {
    problems.push("release artifact manifest is missing or invalid");
  }

  const allowed = new Set(expected.map((entry) => path.basename(entry.public).toLowerCase()));
  const publicFiles = await readdir(path.join(repoRoot, "assets", "downloads"));
  for (const filename of publicFiles) {
    if (/\.(scad|3mf)$/i.test(filename) && !allowed.has(filename.toLowerCase())) {
      problems.push("unregistered old public design file remains: assets/downloads/" + filename);
    }
  }

  if (process.platform === "win32") {
    const metadataCheck = spawnSync(
      "powershell.exe",
      ["-NoProfile", "-ExecutionPolicy", "Bypass", "-File", path.join(repoRoot, "scripts", "stamp-3mf-release.ps1"), "-CheckOnly"],
      { encoding: "utf8" },
    );
    if (metadataCheck.status !== 0) {
      problems.push("embedded 3MF metadata check failed: " + (metadataCheck.stderr || metadataCheck.stdout).trim());
    }
  }

  if (problems.length) {
    console.error("Design release check failed:");
    for (const problem of problems) console.error("- " + problem);
    console.error("Run npm run release:prepare after correcting the release record.");
    process.exitCode = 1;
  } else {
    console.log("Verified immutable design release " + release.version + " (" + expected.length + " public files).");
  }
}

const command = process.argv[2];
if (command === "sync") await sync();
else if (command === "check") await check();
else {
  console.error("Usage: node scripts/release-artifacts.mjs <sync|check>");
  process.exitCode = 2;
}
