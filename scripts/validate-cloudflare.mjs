import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..", "dist");
const routes = ["", "build", "kits", "assembly", "make-5x7"];
const errors = [];
const files = [];

function walk(directory) {
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    const full = path.join(directory, entry.name);
    if (entry.isDirectory()) walk(full);
    else files.push(full);
  }
}

for (const route of routes) {
  const file = path.join(root, route, "index.html");
  if (!fs.existsSync(file)) errors.push(`Missing route output: /${route}`);
}
for (const file of ["404.html", "_headers", "_redirects", "styles.css"]) {
  if (!fs.existsSync(path.join(root, file))) errors.push(`Missing output file: ${file}`);
}

walk(root);
const textFiles = files.filter((file) => /\.(?:html|js|css)$|_(?:headers|redirects)$/.test(file));
for (const file of textFiles) {
  const source = fs.readFileSync(file, "utf8");
  const label = path.relative(root, file);
  if (/<\?[!=]?[\s\S]*?\?>/.test(source)) errors.push(`${label}: unresolved Apps Script template tag`);
  if (/google\.script\.run/.test(source)) errors.push(`${label}: google.script.run remains in deployable output`);
  if (/script\.google\.com\/macros/.test(source)) errors.push(`${label}: Apps Script deployment URL remains`);
  if (/\?page=(?:home|build|kits|assembly|make5x7)/.test(source)) errors.push(`${label}: legacy page query route remains`);
}

const home = fs.readFileSync(path.join(root, "index.html"), "utf8");
const build = fs.readFileSync(path.join(root, "build", "index.html"), "utf8");
const assembly = fs.readFileSync(path.join(root, "assembly", "index.html"), "utf8");
if (!home.includes('id="gallery-section"') || !home.includes('id="inquiryForm"')) errors.push("Home structure is incomplete");
if (!build.includes('id="downloadsList"') || !build.includes('/make-5x7/')) errors.push("Build route or Make 5x7 link is incomplete");
if (!assembly.includes('id="assemblyGuide"')) errors.push("Assembly guide mount is missing");

const forbiddenOutput = ["Code.js", ".clasp.json", "appsscript.json", "HANDOFF.md"];
for (const name of forbiddenOutput) {
  if (files.some((file) => path.basename(file) === name)) errors.push(`Server/source file leaked into dist: ${name}`);
}

if (errors.length) {
  console.error("Cloudflare validation failed:");
  errors.forEach((error) => console.error(`- ${error}`));
  process.exitCode = 1;
} else {
  console.log(`Cloudflare validation passed (${files.length} files).`);
}
