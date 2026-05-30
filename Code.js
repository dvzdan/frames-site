function doGet() {
  return HtmlService.createTemplateFromFile('Index')
    .evaluate()
    .setTitle('Living Frames');
}

function include(filename) {
  return HtmlService.createHtmlOutputFromFile(filename).getContent();
}

const SHEET_ID = "1nS6mq8u5N3WhBiwoFTnbXBvKDUki-iM37vc5CQ-W7pM";
const FOLDER_ID = "16s11FtG5CEIorTk1kxXL6iTQwNLPqxIO";
const INLINE_GALLERY_IMAGE_ROWS = 3;
const SERVER_GALLERY_IMAGE_ROWS = 3;
const GALLERY_INLINE_IMAGE_WIDTH = 720;

function submitConcept(data) {
  validateSubmission(data);

  const folder = DriveApp.getFolderById(FOLDER_ID);

  const coverBlob = dataUrlToBlob(data.cover, "cover.png");
  const revealBlob = dataUrlToBlob(data.reveal, "reveal.png");

  const coverFile = folder.createFile(coverBlob);
  const revealFile = folder.createFile(revealBlob);

  coverFile.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
  revealFile.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);

  const sheet = SpreadsheetApp.openById(SHEET_ID).getActiveSheet();

  sheet.appendRow([
    new Date(),
    textOrEmpty(data.title),
    textOrEmpty(data.revealTitle),
    textOrEmpty(data.description),
"https://drive.google.com/thumbnail?id=" + coverFile.getId() + "&sz=w800",
"https://drive.google.com/thumbnail?id=" + revealFile.getId() + "&sz=w800"
  ]);

  return "Submitted";
}

function validateSubmission(data) {
  if (!data) {
    throw new Error("Missing submission data.");
  }

  validateImageDataUrl(data.cover, "cover");
  validateImageDataUrl(data.reveal, "reveal");
}

function validateImageDataUrl(value, label) {
  const s = String(value || "");
  if (!/^data:image\/[a-zA-Z0-9.+-]+;base64,/.test(s)) {
    throw new Error("Invalid " + label + " image data.");
  }
}

function dataUrlToBlob(dataUrl, filename) {
  const parts = String(dataUrl).split(",");
  if (parts.length < 2) {
    throw new Error("Invalid image data.");
  }

  const mimeMatch = parts[0].match(/:(.*?);/);
  if (!mimeMatch) {
    throw new Error("Invalid image type.");
  }

  const mime = mimeMatch[1];
  const bytes = Utilities.base64Decode(parts[1]);
  return Utilities.newBlob(bytes, mime, filename);
}

function getGallery() {
  const sheet = SpreadsheetApp.openById(SHEET_ID).getActiveSheet();
  const rows = sheet.getDataRange().getValues();

  if (rows.length <= 1) return [];

  rows.shift();

  return rows.map((row, index) => rowToGalleryItem(row, index))
    .filter(x => x && x.cover && x.reveal);
}

function renderInitialGalleryHtml() {
  try {
    const items = getInitialGalleryItems(SERVER_GALLERY_IMAGE_ROWS);
    if (!items.length) {
      return '<div class="card fine-print">No gallery submissions yet.</div>';
    }

    return items.map(renderInitialGalleryCard).join("");
  } catch (err) {
    return '<div class="card fine-print">Gallery error: ' + escapeHtmlServer(err.message || err) + '</div>';
  }
}

function getInitialGalleryItems(limit) {
  const sheet = SpreadsheetApp.openById(SHEET_ID).getActiveSheet();
  const rows = sheet.getDataRange().getValues();
  if (rows.length <= 1) return [];

  rows.shift();

  return rows.reverse()
    .map(rowToServerGalleryItem)
    .filter(x => x && x.cover && x.reveal)
    .slice(0, limit || SERVER_GALLERY_IMAGE_ROWS);
}

function rowToServerGalleryItem(r) {
  try {
    const coverId = extractDriveId(r[4]);
    const revealId = extractDriveId(r[5]);

    return {
      title: textOrEmpty(r[1]),
      revealTitle: textOrEmpty(r[2]),
      description: textOrEmpty(r[3]),
      cover: driveThumbnailUrl(coverId, 1000),
      reveal: driveThumbnailUrl(revealId, 1000)
    };
  } catch (err) {
    console.warn("Skipping initial gallery row: " + err.message);
    return null;
  }
}

function renderInitialGalleryCard(item) {
  const title = escapeHtmlServer(item.title || "Untitled");
  const revealTitle = escapeHtmlServer(item.revealTitle || "Reveal image");
  const description = escapeHtmlServer(item.description || "");

  return '<div class="card">' +
    '<div class="top-title"><strong>' + title + '</strong></div>' +
    '<div class="gallery-frame-button server-gallery-toggle" role="button" tabindex="0">' +
      '<span class="gallery-shadowbox-frame">' +
        '<span class="gallery-frame-art">' +
          '<img class="cover-img" src="' + item.cover + '" alt="' + title + '">' +
          '<img class="reveal-img" src="' + item.reveal + '" alt="' + revealTitle + '" style="display:none">' +
        '</span>' +
        '<span class="gallery-acrylic-glare"></span>' +
      '</span>' +
    '</div>' +
    '<div class="bottom-title">' + revealTitle + '</div>' +
    (description ? '<div class="reveal-description">' + description + '</div>' : '') +
  '</div>';
}

function rowToGalleryItem(r, index) {
  try {
    const coverId = extractDriveId(r[4]);
    const revealId = extractDriveId(r[5]);
    const inlineImages = index < INLINE_GALLERY_IMAGE_ROWS;

    return {
      title: textOrEmpty(r[1]),
      revealTitle: textOrEmpty(r[2]),
      description: textOrEmpty(r[3]),
      cover: inlineImages ? driveImageToDataUrl(coverId, GALLERY_INLINE_IMAGE_WIDTH) : driveThumbnailUrl(coverId, 1000),
      reveal: inlineImages ? driveImageToDataUrl(revealId, GALLERY_INLINE_IMAGE_WIDTH) : driveThumbnailUrl(revealId, 1000)
    };
  } catch (err) {
    console.warn("Skipping gallery row: " + err.message);
    return null;
  }
}

function normalizeDriveThumbnailUrl(url, size) {
  return driveThumbnailUrl(extractDriveId(url), size);
}

function driveThumbnailUrl(id, size) {
  return "https://drive.google.com/thumbnail?id=" +
    encodeURIComponent(id) +
    "&sz=w" +
    String(size || 1000);
}

function getGalleryImageDataUrl(url) {
  return driveImageToDataUrl(url, GALLERY_INLINE_IMAGE_WIDTH);
}

function getTierIllustrationAssets() {
  const content = HtmlService.createHtmlOutputFromFile("Assets").getContent();
  const assets = {};
  const pattern = /(maker|builder|setup|gift)\s*:\s*"([^"]+)"/g;
  let match;

  while ((match = pattern.exec(content)) !== null) {
    assets[match[1]] = match[2];
  }

  return assets;
}

function getTierIllustrationAsset(key) {
  return getTierIllustrationAssets()[key] || "";
}

function driveImageToDataUrl(url, maxWidth) {
  const id = extractDriveId(url);
  const file = DriveApp.getFileById(id);
  let blob = file.getBlob();

  if (maxWidth) {
    const image = ImagesService.openImage(blob);
    const width = image.getWidth();
    const height = image.getHeight();
    if (width > maxWidth) {
      const resizedHeight = Math.max(1, Math.round(height * (maxWidth / width)));
      blob = image.resize(maxWidth, resizedHeight).getBlob();
    }
  }

  return "data:" + blob.getContentType() + ";base64," +
    Utilities.base64Encode(blob.getBytes());
}

function extractDriveId(url) {
  const s = String(url);

  const thumbMatch = s.match(/[?&]id=([^&]+)/);
  if (thumbMatch) return thumbMatch[1];

  const fileMatch = s.match(/\/d\/([^/]+)/);
  if (fileMatch) return fileMatch[1];

  return s;
}

function textOrEmpty(value) {
  return value == null ? "" : String(value);
}

function escapeHtmlServer(value) {
  return textOrEmpty(value).replace(/[&<>'"]/g, function(c) {
    switch (c) {
      case "&": return "&amp;";
      case "<": return "&lt;";
      case ">": return "&gt;";
      case "'": return "&#39;";
      case '"': return "&quot;";
      default: return c;
    }
  });
}

function authorizeMe() {
  SpreadsheetApp.openById(SHEET_ID).getName();
  DriveApp.getFolderById(FOLDER_ID).getName();
}
