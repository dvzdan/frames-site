function doGet() {
  return HtmlService.createTemplateFromFile('Index')
    .evaluate()
    .setTitle('Double Take Frames');
}

function include(filename) {
  return HtmlService.createHtmlOutputFromFile(filename).getContent();
}

function tierSectionIcon(name) {
  const icons = {
    packageCheck: '<svg viewBox="0 0 24 24"><path d="m16 16 2 2 4-4"/><path d="M21 10V8a2 2 0 0 0-1-1.7l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.7l7 4a2 2 0 0 0 2 0l2-1.1"/><path d="m7.5 4.3 9 5.1"/><polyline points="3.3 7 12 12 20.7 7"/><line x1="12" y1="22" x2="12" y2="12"/></svg>',
    wrench: '<svg viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.8-3.8a6 6 0 0 1-7.9 7.9l-6.9 6.9a2.1 2.1 0 0 1-3-3l6.9-6.9a6 6 0 0 1 7.9-7.9z"/></svg>'
  };
  return icons[name] || "";
}

const SHEET_ID = "1nS6mq8u5N3WhBiwoFTnbXBvKDUki-iM37vc5CQ-W7pM";
const FOLDER_ID = "16s11FtG5CEIorTk1kxXL6iTQwNLPqxIO";
const GALLERY_INLINE_IMAGE_WIDTH = 720;

function submitConcept(data) {
  validateSubmission(data);

  const folder = DriveApp.getFolderById(FOLDER_ID);

  const coverBlob = dataUrlToBlob(data.cover, "cover");
  const revealBlob = dataUrlToBlob(data.reveal, "reveal");

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
  if (!/^data:image\/(?:png|jpeg);base64,/i.test(s)) {
    throw new Error("Invalid " + label + " image. Upload a PNG or JPEG file.");
  }
}

function dataUrlToBlob(dataUrl, basename) {
  const parts = String(dataUrl).split(",");
  if (parts.length < 2) {
    throw new Error("Invalid image data.");
  }

  const mimeMatch = parts[0].match(/:(.*?);/);
  if (!mimeMatch) {
    throw new Error("Invalid image type.");
  }

  const mime = mimeMatch[1];
  const extension = mime === "image/png" ? ".png" : ".jpg";
  const bytes = Utilities.base64Decode(parts[1]);
  return Utilities.newBlob(bytes, mime, basename + extension);
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
    const items = getInitialGalleryItems();
    if (!items.length) {
      return '<div class="card fine-print">No gallery submissions yet.</div>';
    }

    return items.map(renderInitialGalleryCard).join("");
  } catch (err) {
    return '<div class="card fine-print">Gallery error: ' + escapeHtmlServer(err.message || err) + '</div>';
  }
}

function getInitialGalleryJson() {
  try {
    return JSON.stringify(getInitialGalleryItems(8)).replace(/<\//g, "<\\/");
  } catch (err) {
    return "[]";
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
    .slice(0, typeof limit === "number" ? limit : undefined);
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

function renderInitialGalleryCard(item, index) {
  const title = escapeHtmlServer(item.title || "Untitled");
  const revealTitle = escapeHtmlServer(item.revealTitle || "Reveal image");
  const description = escapeHtmlServer(item.description || "");
  const frameColor = "frame-color-" + (index % 6);

  return '<div class="card">' +
    '<div class="top-title"><strong>' + title + '</strong></div>' +
    '<div class="gallery-frame-button server-gallery-toggle" role="button" tabindex="0">' +
      '<span class="gallery-shadowbox-frame ' + frameColor + '">' +
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

function rowToGalleryItem(r) {
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
