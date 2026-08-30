import { access, readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const registryPath = path.join(repoRoot, "project-state", "assets.json");
const registry = JSON.parse(await readFile(registryPath, "utf8"));
const problems = [];

if (registry.schemaVersion !== 1) problems.push("asset registry schemaVersion is not 1");
if (!Array.isArray(registry.assets) || registry.assets.length === 0) {
  problems.push("asset registry has no assets");
}

const ids = new Set();
const allowedTiers = new Set(["canonical", "pending-canon", "experimental"]);
for (const asset of registry.assets ?? []) {
  if (!asset.id || ids.has(asset.id)) problems.push(`missing or duplicate asset id: ${asset.id ?? "(missing)"}`);
  ids.add(asset.id);
  if (!allowedTiers.has(asset.tier)) problems.push(`${asset.id} has invalid tier: ${asset.tier ?? "(missing)"}`);
  if (!asset.canonical) {
    problems.push(`${asset.id} has no canonical path`);
    continue;
  }
  try {
    await access(path.join(repoRoot, ...asset.canonical.split("/")));
  } catch {
    problems.push(`${asset.id} canonical file is missing: ${asset.canonical}`);
  }
  for (const publicCopy of asset.publicCopies ?? []) {
    try {
      await access(path.join(repoRoot, ...publicCopy.split("/")));
    } catch {
      problems.push(`${asset.id} public copy is missing: ${publicCopy}`);
    }
  }
}

try {
  await access(path.join(repoRoot, "PROJECT_STATE.md"));
} catch {
  problems.push("PROJECT_STATE.md is missing");
}

if (problems.length) {
  console.error("Project-state check failed:");
  for (const problem of problems) console.error(`- ${problem}`);
  process.exitCode = 1;
} else {
  console.log(`Verified project briefing and ${registry.assets.length} registered assets.`);
}
