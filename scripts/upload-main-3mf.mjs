import { readFile } from "node:fs/promises";
import { basename, join } from "node:path";
import { homedir } from "node:os";

const sourcePath = process.argv[2] ||
  join(homedir(), "Documents", "codex-scad-experiment", "canonical files", "main.3mf");
const fileName = process.argv[3] || basename(sourcePath);

const parentFolderId = "16s11FtG5CEIorTk1kxXL6iTQwNLPqxIO";
const downloadsFolderName = "downloads";

async function getAccessToken() {
  const claspPath = join(homedir(), ".clasprc.json");
  const clasp = JSON.parse(await readFile(claspPath, "utf8"));
  const creds = clasp.tokens.default;
  const params = new URLSearchParams({
    client_id: creds.client_id,
    client_secret: creds.client_secret,
    refresh_token: creds.refresh_token,
    grant_type: "refresh_token"
  });

  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    body: params
  });
  if (!response.ok) throw new Error(await response.text());
  return (await response.json()).access_token;
}

async function driveJson(token, url, options = {}) {
  const response = await fetch(url, {
    ...options,
    headers: {
      Authorization: `Bearer ${token}`,
      ...(options.headers || {})
    }
  });
  if (!response.ok) throw new Error(await response.text());
  return response.status === 204 ? null : response.json();
}

async function findFile(token, query, fields = "files(id,name,modifiedTime,size)") {
  const params = new URLSearchParams({
    q: query,
    fields,
    supportsAllDrives: "true"
  });
  const result = await driveJson(token, `https://www.googleapis.com/drive/v3/files?${params}`);
  return result.files?.[0] || null;
}

async function createFolder(token, name, parentId) {
  return driveJson(token, "https://www.googleapis.com/drive/v3/files?supportsAllDrives=true&fields=id,name", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      name,
      mimeType: "application/vnd.google-apps.folder",
      parents: [parentId]
    })
  });
}

async function createFile(token, folderId, name, bytes) {
  const boundary = `upload_boundary_${crypto.randomUUID().replaceAll("-", "")}`;
  const metadata = JSON.stringify({
    name,
    parents: [folderId],
    mimeType: "model/3mf"
  });
  const encoder = new TextEncoder();
  const body = new Blob([
    encoder.encode(`--${boundary}\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n${metadata}\r\n`),
    encoder.encode(`--${boundary}\r\nContent-Type: model/3mf\r\n\r\n`),
    bytes,
    encoder.encode(`\r\n--${boundary}--\r\n`)
  ]);

  return driveJson(token, "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart&supportsAllDrives=true&fields=id,name,modifiedTime,size", {
    method: "POST",
    headers: { "Content-Type": `multipart/related; boundary=${boundary}` },
    body
  });
}

async function updateFile(token, fileId, bytes) {
  return driveJson(token, `https://www.googleapis.com/upload/drive/v3/files/${fileId}?uploadType=media&supportsAllDrives=true&fields=id,name,modifiedTime,size`, {
    method: "PATCH",
    headers: { "Content-Type": "model/3mf" },
    body: bytes
  });
}

async function makePublic(token, fileId) {
  try {
    await driveJson(token, `https://www.googleapis.com/drive/v3/files/${fileId}/permissions?supportsAllDrives=true`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ role: "reader", type: "anyone" })
    });
  } catch (error) {
    if (!String(error.message).includes("already exists")) throw error;
  }
}

const token = await getAccessToken();
const downloadsFolder =
  await findFile(
    token,
    `'${parentFolderId}' in parents and name = '${downloadsFolderName}' and mimeType = 'application/vnd.google-apps.folder' and trashed = false`,
    "files(id,name)"
  ) || await createFolder(token, downloadsFolderName, parentFolderId);

const bytes = await readFile(sourcePath);
const existing = await findFile(
  token,
  `'${downloadsFolder.id}' in parents and name = '${fileName}' and trashed = false`
);

const file = existing
  ? await updateFile(token, existing.id, bytes)
  : await createFile(token, downloadsFolder.id, fileName, bytes);
await makePublic(token, file.id);

console.log(JSON.stringify({
  action: existing ? "updated" : "created",
  name: file.name,
  fileId: file.id,
  size: file.size,
  modifiedTime: file.modifiedTime,
  downloadUrl: `https://drive.google.com/uc?export=download&id=${file.id}`
}, null, 2));
