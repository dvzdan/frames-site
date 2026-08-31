import { link, lstat, mkdir, readdir, readFile, unlink } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const registry = JSON.parse(
  await readFile(path.join(repoRoot, "project-state", "assets.json"), "utf8"),
);

if (process.platform !== "win32") {
  console.log("User-workspace sync skipped outside Windows.");
  process.exit(0);
}

function windowsPath(value) {
  return path.win32.normalize(value.replaceAll("/", "\\"));
}

const workspace = windowsPath(registry.userWorkspace);
const problems = [];
let linked = 0;

for (const folder of registry.workspaceFolders ?? []) {
  if (folder.view !== "hardlink-mirror") continue;

  const local = path.win32.join(workspace, ...folder.local.split("/"));
  const target = path.join(repoRoot, ...folder.target.split("/"));
  await mkdir(local, { recursive: true });

  const localStats = await lstat(local);
  if (localStats.isSymbolicLink()) {
    problems.push(`${folder.local} is still a directory link; convert it before syncing`);
    continue;
  }

  const [localEntries, targetEntries] = await Promise.all([
    readdir(local, { withFileTypes: true }),
    readdir(target, { withFileTypes: true }),
  ]);
  const localFiles = new Set(localEntries.filter((entry) => entry.isFile()).map((entry) => entry.name));
  const targetFiles = new Set(targetEntries.filter((entry) => entry.isFile()).map((entry) => entry.name));

  for (const name of targetFiles) {
    const localFile = path.win32.join(local, name);
    const targetFile = path.join(target, name);
    if (!localFiles.has(name)) {
      await link(targetFile, localFile);
      linked += 1;
      continue;
    }

    const [localFileStats, targetFileStats] = await Promise.all([lstat(localFile), lstat(targetFile)]);
    if (localFileStats.dev === targetFileStats.dev && localFileStats.ino === targetFileStats.ino) continue;

    const [localBytes, targetBytes] = await Promise.all([readFile(localFile), readFile(targetFile)]);
    if (!localBytes.equals(targetBytes)) {
      problems.push(`${folder.local}/${name} differs; refusing to replace it`);
      continue;
    }
    await unlink(localFile);
    await link(targetFile, localFile);
    linked += 1;
  }

  for (const name of localFiles) {
    if (!targetFiles.has(name)) {
      problems.push(`${folder.local}/${name} has no authoritative counterpart; left untouched`);
    }
  }
}

if (problems.length) {
  console.error("User-workspace sync needs attention:");
  for (const problem of problems) console.error(`- ${problem}`);
  process.exitCode = 1;
} else {
  console.log(`SCAD workspace sync complete (${linked} file links refreshed).`);
}
