import { realpath, readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const registry = JSON.parse(
  await readFile(path.join(repoRoot, "project-state", "assets.json"), "utf8"),
);

if (process.platform !== "win32") {
  console.log("User-workspace check skipped outside Windows.");
  process.exit(0);
}

function windowsPath(value) {
  return path.win32.normalize(value.replaceAll("/", "\\"));
}

function comparable(value) {
  return windowsPath(value).toLowerCase();
}

const workspace = windowsPath(registry.userWorkspace);
const problems = [];

for (const folder of registry.workspaceFolders ?? []) {
  const local = path.win32.join(workspace, ...folder.local.split("/"));
  const target = folder.external
    ? windowsPath(folder.target)
    : path.join(repoRoot, ...folder.target.split("/"));
  try {
    const [actualLocal, actualTarget] = await Promise.all([realpath(local), realpath(target)]);
    if (comparable(actualLocal) !== comparable(actualTarget)) {
      problems.push(`${folder.local} points to ${actualLocal}, expected ${actualTarget}`);
    }
  } catch (error) {
    problems.push(`${folder.local} is unavailable: ${error.message}`);
  }
}

for (const asset of registry.assets ?? []) {
  if (!asset.localAccess) continue;
  try {
    const [localBytes, canonicalBytes] = await Promise.all([
      readFile(windowsPath(asset.localAccess)),
      readFile(path.join(repoRoot, ...asset.canonical.split("/"))),
    ]);
    if (!localBytes.equals(canonicalBytes)) {
      problems.push(`${asset.id} local-access file differs from its registered source`);
    }
  } catch (error) {
    problems.push(`${asset.id} local-access file is unavailable: ${error.message}`);
  }
}

if (problems.length) {
  console.error("User-workspace check failed:");
  for (const problem of problems) console.error(`- ${problem}`);
  process.exitCode = 1;
} else {
  console.log(`Verified ${registry.workspaceFolders.length} user folders and all registered local-access files.`);
}
