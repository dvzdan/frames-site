function doGet(e) {
  if (e && e.parameter && e.parameter.page === "make5x7") {
    return HtmlService.createHtmlOutputFromFile('Make5x7')
      .setTitle('Make 5x7 - Double Take Frames');
  }

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
const CMS_SHEET_NAME = "Site CMS";
const INQUIRY_SHEET_NAME = "Inquiries";
const SOURCING_SHEET_NAME = "Sourcing";
const DOWNLOADS_FOLDER_NAME = "downloads";
const INQUIRY_NOTIFICATION_EMAIL = "friedman.zack@gmail.com";
const CMS_HEADERS = ["section", "type", "sort", "heading", "body", "enabled", "notes"];
const SOURCING_HEADERS = ["Active", "Order", "Item", "Product", "URL", "Quantity", "Note"];
const CMS_DEFAULT_ROWS = [
  ["how-it-works", "primary", 10, "", "Two printed images sit inside one physical frame - along with a tiny clock mechanism, a bit of thread, a trap door, and a falling weight. When the time is up, the frame reveals the hidden image.", true, "Main paragraph under How it works."],
  ["how-it-works", "detail", 20, "Wait, why?", "Halloween. April Fools. Baby reveals. Pet nonsense.\n\nFamily holiday cards. Promposals.\n\nSincere messages of hope and inspiration, if you must insist.\n\nImagine giving someone a framed photo, letting it sit quietly on a shelf, and then - days or weeks later - it suddenly becomes a different picture.", true, "Appears below the main How it works paragraph."],
  ["how-it-works", "detail", 21, "So it's both absurd and pointless. How do I get one?", "You build it! Download the ready-to-print files, print the parts, and put everything together. No modeling or design work required.\n\nIf you don't own a 3D printer, ask around - a friend, local library, or makerspace may have one. You can source the remaining hardware and materials yourself or get everything together in our Hardware Bundle.", true, "Offering bridge after Wait, why?"],
  ["how-it-works", "detail", 22, "This whole 3D-printing craze doesn't interest me.", "Fair enough. We'll print every plastic part and send it with the hardware and materials. You do the assembly. That's the Assembly Kit.", true, "Offering bridge after Wait, why?"],
  ["how-it-works", "detail", 23, "Take the hint. I want a fun prank gift, not a project.", "You're missing out! But if you insist, we'll sell you the Finished Gift - built, loaded, tested, and ready to give. It'll cost ya.", true, "Offering bridge after Wait, why?"],
  ["how-it-works", "detail", 24, "How exactly does it work?", "Simple: a clock winds a string, which pulls a zipper, which releases a latch, which drops a weight, which yoinks a photo, which reveals another.", true, ""],
  ["how-it-works", "detail", 25, "Will I enjoy putting this together?", "That depends almost entirely on what kind of project you enjoy.\n\nThis is a miniature machine disguised as a gift: part assembly project, part puzzle, and part experiment. If you enjoy examining unfamiliar parts, understanding how they interact, and making small adjustments until a mechanism comes to life, it is probably your kind of fun.\n\nNo individual step is especially difficult. But if you want a quick, strictly linear project that never asks you to stop and think, it may be more aggravating than enjoyable. The build rewards curiosity, patience, and a willingness to tinker.", true, "Moved from FAQ into How it works."],
  ["how-it-works", "detail", 40, "Is it fragile?", "Not especially. Once it is set up, the mechanism can handle normal jostling, packing, shipping, and being tilted around. It does not need to stay perfectly upright the whole time. Just return it upright before the timer finishes so gravity can do its job.", true, ""],
  ["how-it-works", "detail", 60, "Can I choose one of the image pairs in the gallery?", "Yes, but we would rather see what you come up with.", true, ""],
  ["how-it-works", "detail", 70, "Can I use any type of photo or paper stock?", "The reveal sheet requires the specified specialty paper.\n\nThe other image can use just about any roughly 5x7 photo or paper stock.", true, ""],
  ["how-it-works", "detail", 80, "Won't it seem weird to give someone a photo in this frame?", "Probably. A cover story helps. Try: \"My friend started 3D-printing frames and gave me one.\"", true, ""],
  ["how-it-works", "detail", 90, "Does it make noise?", "A little. The clock mechanism ticks softly, but unless your recipient is already inspecting the frame for tiny hidden machinery, they are unlikely to notice.\n\nThe reveal makes a small thud when the weight drops. A small piece of fabric or felt at the bottom helps muffle it.", true, ""],
  ["faq", "item", 20, "How do I reset the mechanism?", "Return to the assembly instructions and repeat the steps that set the mechanism in motion. You will need to redo some of the assembly process, but not all of it.", true, "FAQ item from docs/FAQ.docx."],
  ["faq", "item", 30, "Threading the string is a nuisance.", "It can be. Stiffen the end with a small drop of superglue, or glue the tiny metal wire included in the kit to the end of the string and use it as a threading needle.", true, "FAQ item from docs/FAQ.docx."],
  ["faq", "item", 40, "I'm worried I assembled it incorrectly and it won't work.", "The design and assembly instructions include multiple layers of redundancy. Most individual steps are not essential on their own; instead, they work together to reduce the overall likelihood of failure to below 1%. If you get one detail slightly wrong, the mechanism will usually still work - you have most likely increased the risk of failure only marginally.", true, "FAQ item from docs/FAQ.docx."],
  ["faq", "item", 50, "Can I build one entirely myself?", "Yes. The design files, image-formatting tool, assembly guide, and parts list are available on this site. If you want to avoid buying larger packs, rolls, or sheets for a single build, the kits gather the tested compatible pieces in one-frame quantities.", true, "Open-model FAQ item."],
  ["assembly", "intro", 10, "", "Before following the steps, it helps to understand the little chain reaction inside the frame. The instructions will walk you through the setup, but the mechanism is forgiving. Once you understand what each part is trying to do, you can use the steps as both a guide and a checklist.", true, "Appears above the assembly step viewer."],
  ["assembly", "sequence", 20, "How the mechanism works:", "Clock mechanism sits inside the frame.\nCapstan presses onto the clock mechanism.\nString ties to the capstan.\n  Then runs through the clock/string guide hole.\n  And through the top-left eyelet.\n  Then ties to the zipper anchor.\nZipper head supports the latch.\nLatch supports the weight.\nWeight is tethered to the sliding cover image.\nCover image sits over the reveal image.\nWhen the timer runs, the clock winds the string, pulls the zipper, releases the latch, drops the weight, slides the cover image up, and reveals the image underneath.", true, "Each line appears as a bulleted sequence item. Indent lines with spaces for nested bullets."],
  ["assembly", "checklist", 30, "Easy-to-miss checks:", "Tuck the stem of the weight inside the roller lip so it cannot fall out.\nFasten the trap-door latch with the C-clip.\nThread the string through both the boss guide and the top-left eyelet.\nPull any remaining slack above the string/clock guide.", true, "Each line appears as a checkbox."]
];
const CMS_DEFAULT_BODY_REPLACEMENTS = {
  "how-it-works|detail|25": {
    from: "That depends almost entirely on what kind of project you enjoy.\n\nIf you like examining unfamiliar parts, understanding how they interact, making small adjustments, and eventually watching a mechanism come to life, this is probably your kind of fun. It is a miniature machine disguised as a gift: part assembly project, part puzzle, and part experiment. The instructions will guide you, but much of the satisfaction comes from understanding what the mechanism is doing and getting it dialed in.\n\nIf you are looking for a quick, linear project where you follow each step once and never have to stop and work out the little details for yourself, this may be more aggravating than enjoyable. There is nothing unusually difficult about it, but it rewards curiosity, patience, and a willingness to tinker.",
    to: "That depends almost entirely on what kind of project you enjoy.\n\nThis is a miniature machine disguised as a gift: part assembly project, part puzzle, and part experiment. If you enjoy examining unfamiliar parts, understanding how they interact, and making small adjustments until a mechanism comes to life, it is probably your kind of fun.\n\nNo individual step is especially difficult. But if you want a quick, strictly linear project that never asks you to stop and think, it may be more aggravating than enjoyable. The build rewards curiosity, patience, and a willingness to tinker."
  },
  "how-it-works|detail|50": {
    from: "Yes. That is the point. Send us any two images and we will size and print them for the frame.",
    to: ""
  },
  "how-it-works|detail|70": {
    from: "For the reveal image, yes - just about any roughly 5x7 photo or paper stock should work.\n\nThe sliding cover image is fussier because it has a job to do, so use the recommended specialty media from the parts list or a kit.",
    alternates: [
      "For the reveal image, yes - just about any roughly 5x7 photo or paper stock should work.\n\nBut the sliding cover image is fussier. That one has a job to do, so it needs the specialty paper."
    ],
    to: "The reveal sheet requires the specified specialty paper.\n\nThe other image can use just about any roughly 5x7 photo or paper stock."
  }
};
const CMS_DEFAULT_ROW_REMOVALS = {
  "faq|item|10": {
    heading: "Will I enjoy putting this together?",
    body: "That depends almost entirely on what kind of project you enjoy.\n\nIf you like examining unfamiliar parts, understanding how they interact, making small adjustments, and eventually watching a mechanism come to life, this is probably your kind of fun. It is a miniature machine disguised as a gift: part assembly project, part puzzle, and part experiment. The instructions will guide you, but the real satisfaction comes from understanding what the mechanism is doing and getting it dialed in.\n\nIf you are looking for a quick, linear project where you follow each step once, never need to inspect or adjust anything, and can assume that every part will behave perfectly on the first try, this may be more aggravating than enjoyable. There is nothing unusually difficult about it, but it rewards curiosity, patience, and a willingness to tinker."
  },
  "how-it-works|detail|50": {
    heading: "Can I use my own images?",
    body: "Yes. That is the point. The image tool helps format a cover image and reveal image for the frame."
  },
  "faq|item|60": {
    heading: "Can I sell frames made from these files?",
    body: "The files are licensed CC BY-NC-SA 4.0: free for personal, noncommercial use, and remixing is encouraged as long as remixes carry the same license. If you want to use the design commercially, get in touch through the request form."
  }
};
const CMS_DEFAULT_ROW_HEADING_REPLACEMENTS = {
  "how-it-works|detail|70": {
    from: "Can I just use my own photos?",
    to: "Can I use any type of photo or paper stock?"
  }
};
const CMS_DEFAULT_SORT_REPLACEMENTS = {
  "how-it-works|detail|How exactly does it work?": {
    from: 30,
    to: 24
  }
};

function submitConcept(data) {
  validateSubmission(data);

  const folder = DriveApp.getFolderById(FOLDER_ID);

  const coverBlob = dataUrlToBlob(data.cover, "cover");
  const revealBlob = dataUrlToBlob(data.reveal, "reveal");

  const coverFile = folder.createFile(coverBlob);
  const revealFile = folder.createFile(revealBlob);

  coverFile.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
  revealFile.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);

  const sheet = getGallerySheet_();

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

function submitInquiry(data) {
  validateInquiry(data);

  const sheet = getOrCreateInquirySheet_();
  const timestamp = new Date();
  sheet.appendRow([
    timestamp,
    textOrEmpty(data.type),
    textOrEmpty(data.kit),
    textOrEmpty(data.name),
    textOrEmpty(data.email),
    textOrEmpty(data.timeline),
    textOrEmpty(data.message)
  ]);
  sendInquiryNotification_(data, timestamp);

  return "Submitted";
}

function sendInquiryNotification_(data, timestamp) {
  const type = textOrEmpty(data.type);
  const kit = textOrEmpty(data.kit);
  const name = textOrEmpty(data.name);
  const email = textOrEmpty(data.email);
  const timeline = textOrEmpty(data.timeline);
  const message = textOrEmpty(data.message);
  const body = [
    "New Double Take Frames request",
    "",
    "Submitted: " + timestamp,
    "Type: " + type,
    "Kit path: " + kit,
    "Name: " + name,
    "Email: " + email,
    "Timeline: " + timeline,
    "",
    "Message:",
    message
  ].join("\n");
  const options = {
    to: INQUIRY_NOTIFICATION_EMAIL,
    subject: "Double Take Frames: " + (type || "Website request"),
    body: body,
    name: "Double Take Frames"
  };

  if (email) options.replyTo = email;
  MailApp.sendEmail(options);
}

function validateInquiry(data) {
  if (!data) {
    throw new Error("Missing request data.");
  }

  if (!textOrEmpty(data.email).trim()) {
    throw new Error("Email is required.");
  }

  if (!textOrEmpty(data.message).trim()) {
    throw new Error("Message is required.");
  }
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
  const sheet = getGallerySheet_();
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
  const sheet = getGallerySheet_();
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

function getSiteCmsContentJson() {
  try {
    return JSON.stringify(getSiteCmsContent_()).replace(/<\//g, "<\\/");
  } catch (err) {
    console.warn("Site CMS error: " + (err && err.message ? err.message : err));
    return "{}";
  }
}

function getSiteCmsContent_() {
  const sheet = getOrCreateSiteCmsSheet_();
  const sourcingItems = getSourcingItems_();
  const rows = sheet.getDataRange().getValues();
  if (rows.length <= 1) {
    return sourcingItems.length ? { sections: { parts: { items: sourcingItems } } } : {};
  }

  const headers = rows.shift().map(function(header) {
    return String(header || "").trim().toLowerCase();
  });

  const index = {};
  headers.forEach(function(header, i) {
    index[header] = i;
  });

  const cmsRows = rows
    .map(function(row) {
      return {
        section: textOrEmpty(row[index.section]).trim(),
        type: textOrEmpty(row[index.type]).trim(),
        sort: Number(row[index.sort]) || 0,
        heading: textOrEmpty(row[index.heading]).trim(),
        body: textOrEmpty(row[index.body]).trim(),
        enabled: row[index.enabled]
      };
    })
    .filter(function(row) {
      return row.section && row.body && isCmsRowEnabled_(row.enabled);
    })
    .sort(function(a, b) {
      return a.sort - b.sort;
    });

  const howItWorksRows = cmsRows.filter(function(row) {
    return row.section === "how-it-works";
  });
  const assemblyRows = cmsRows.filter(function(row) {
    return row.section === "assembly";
  });
  const faqRows = cmsRows.filter(function(row) {
    return row.section === "faq";
  });

  const primary = howItWorksRows.find(function(row) {
    return row.type === "primary";
  });

  const detailGroups = howItWorksRows
    .filter(function(row) {
      return row.type === "detail";
    })
    .map(function(row) {
      return {
        heading: row.heading,
        body: row.body
      };
    });

  const content = { homepage: { productIntro: {} } };
  if (primary) content.homepage.productIntro.text = primary.body;
  if (detailGroups.length) content.homepage.productIntro.detailGroups = detailGroups;
  const assembly = buildAssemblyCmsContent_(assemblyRows);
  const faq = buildFaqCmsContent_(faqRows);
  if (assembly || faq || sourcingItems.length) content.sections = {};
  if (assembly) content.sections.assembly = assembly;
  if (faq) content.sections.faq = faq;
  if (sourcingItems.length) content.sections.parts = { items: sourcingItems };
  return content;
}

function buildFaqCmsContent_(rows) {
  const items = rows
    .filter(function(row) {
      return row.type === "item";
    })
    .map(function(row) {
      return {
        question: row.heading,
        answer: row.body
      };
    })
    .filter(function(item) {
      return item.question && item.answer;
    });

  if (!items.length) return null;

  return {
    heading: "FAQ",
    items: items
  };
}

function buildAssemblyCmsContent_(rows) {
  if (!rows.length) return null;

  const assembly = {};
  const intro = rows.find(function(row) {
    return row.type === "intro";
  });
  const sequence = rows.find(function(row) {
    return row.type === "sequence";
  });
  const checklist = rows.find(function(row) {
    return row.type === "checklist";
  });

  if (intro) assembly.intro = intro.body;
  if (sequence) {
    assembly.sequenceHeading = sequence.heading;
    assembly.sequenceItems = inferAssemblySequenceLevels_(splitCmsListItems_(sequence.body));
  }
  if (checklist) {
    assembly.checklistHeading = checklist.heading;
    assembly.checklistItems = splitCmsLines_(checklist.body);
  }

  return assembly;
}

function splitCmsLines_(value) {
  return textOrEmpty(value)
    .split(/\n+/)
    .map(function(line) {
      return line.trim().replace(/^[•*-]\s*/, "");
    })
    .filter(Boolean);
}

function splitCmsListItems_(value) {
  return textOrEmpty(value)
    .split(/\n+/)
    .map(function(line) {
      const leading = line.match(/^\s*/)[0].length;
      const text = line.trim().replace(/^[•*-]\s*/, "");
      return {
        text: text,
        level: leading > 0 ? 1 : 0
      };
    })
    .filter(function(item) {
      return item.text;
    });
}

function inferAssemblySequenceLevels_(items) {
  const hasNestedItems = items.some(function(item) {
    return item.level > 0;
  });
  if (hasNestedItems) return items;

  const nested = {
    "Then runs through the clock/string guide hole.": true,
    "And through the top-left eyelet.": true,
    "Then ties to the zipper anchor.": true
  };

  return items.map(function(item) {
    return {
      text: item.text,
      level: nested[item.text] ? 1 : 0
    };
  });
}

function getOrCreateSiteCmsSheet_() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  let sheet = ss.getSheetByName(CMS_SHEET_NAME);
  if (!sheet) {
    sheet = ss.insertSheet(CMS_SHEET_NAME);
  }

  if (sheet.getLastRow() === 0) {
    seedSiteCmsSheet_(sheet);
  } else {
    const firstRow = sheet.getRange(1, 1, 1, CMS_HEADERS.length).getValues()[0];
    const hasHeaders = firstRow.some(function(value) {
      return String(value || "").trim();
    });
    if (!hasHeaders) seedSiteCmsSheet_(sheet);
  }

  syncKnownCmsDefaultSortReplacements_(sheet);
  appendMissingCmsDefaultRows_(sheet);
  syncKnownCmsDefaultBodyReplacements_(sheet);
  return sheet;
}

function seedSiteCmsSheet_(sheet) {
  sheet.clear();
  sheet.getRange(1, 1, 1, CMS_HEADERS.length).setValues([CMS_HEADERS]);
  sheet.getRange(2, 1, CMS_DEFAULT_ROWS.length, CMS_HEADERS.length).setValues(CMS_DEFAULT_ROWS);
  sheet.setFrozenRows(1);
  sheet.autoResizeColumns(1, CMS_HEADERS.length);
}

function appendMissingCmsDefaultRows_(sheet) {
  const rows = sheet.getDataRange().getValues();
  const existingKeys = {};
  rows.slice(1).forEach(function(row) {
    existingKeys[[row[0], row[1], row[2]].join("|")] = true;
  });

  const missing = CMS_DEFAULT_ROWS.filter(function(row) {
    return !existingKeys[[row[0], row[1], row[2]].join("|")];
  });

  if (!missing.length) return;

  sheet.getRange(sheet.getLastRow() + 1, 1, missing.length, CMS_HEADERS.length).setValues(missing);
  sheet.autoResizeColumns(1, CMS_HEADERS.length);
}

function syncKnownCmsDefaultSortReplacements_(sheet) {
  const rows = sheet.getDataRange().getValues();
  if (rows.length <= 1) return;

  const headers = rows[0].map(function(header) {
    return String(header || "").trim().toLowerCase();
  });
  const sectionIndex = headers.indexOf("section");
  const typeIndex = headers.indexOf("type");
  const sortIndex = headers.indexOf("sort");
  const headingIndex = headers.indexOf("heading");
  if (sectionIndex < 0 || typeIndex < 0 || sortIndex < 0 || headingIndex < 0) return;

  for (let i = 1; i < rows.length; i += 1) {
    const row = rows[i];
    const key = [
      textOrEmpty(row[sectionIndex]).trim(),
      textOrEmpty(row[typeIndex]).trim(),
      textOrEmpty(row[headingIndex]).trim()
    ].join("|");
    const replacement = CMS_DEFAULT_SORT_REPLACEMENTS[key];
    if (replacement && Number(row[sortIndex]) === replacement.from) {
      sheet.getRange(i + 1, sortIndex + 1).setValue(replacement.to);
    }
  }
}

function syncKnownCmsDefaultBodyReplacements_(sheet) {
  const rows = sheet.getDataRange().getValues();
  if (rows.length <= 1) return;

  const headers = rows[0].map(function(header) {
    return String(header || "").trim().toLowerCase();
  });
  const sectionIndex = headers.indexOf("section");
  const typeIndex = headers.indexOf("type");
  const sortIndex = headers.indexOf("sort");
  const headingIndex = headers.indexOf("heading");
  const bodyIndex = headers.indexOf("body");
  if (sectionIndex < 0 || typeIndex < 0 || sortIndex < 0 || headingIndex < 0 || bodyIndex < 0) return;

  for (let i = rows.length - 1; i >= 1; i -= 1) {
    const row = rows[i];
    const key = [
      textOrEmpty(row[sectionIndex]).trim(),
      textOrEmpty(row[typeIndex]).trim(),
      Number(row[sortIndex]) || 0
    ].join("|");

    const removal = CMS_DEFAULT_ROW_REMOVALS[key];
    if (
      removal &&
      textOrEmpty(row[headingIndex]).trim() === removal.heading &&
      textOrEmpty(row[bodyIndex]).trim() === removal.body
    ) {
      sheet.deleteRow(i + 1);
      continue;
    }

    const headingReplacement = CMS_DEFAULT_ROW_HEADING_REPLACEMENTS[key];
    if (headingReplacement && textOrEmpty(row[headingIndex]).trim() === headingReplacement.from) {
      sheet.getRange(i + 1, headingIndex + 1).setValue(headingReplacement.to);
    }

    const replacement = CMS_DEFAULT_BODY_REPLACEMENTS[key];
    if (replacement && cmsBodyMatchesReplacement_(textOrEmpty(row[bodyIndex]).trim(), replacement)) {
      sheet.getRange(i + 1, bodyIndex + 1).setValue(replacement.to);
    }
  }
}

function cmsBodyMatchesReplacement_(body, replacement) {
  if (body === replacement.from) return true;
  return (replacement.alternates || []).some(function(alternate) {
    return body === alternate;
  });
}

function isCmsRowEnabled_(value) {
  const s = textOrEmpty(value).trim().toLowerCase();
  return s === "" || s === "true" || s === "yes" || s === "1";
}

function getSourcingItems_() {
  const sheet = getOrCreateSourcingSheet_();
  const rows = sheet.getDataRange().getValues();
  if (rows.length <= 1) return [];

  const headerRowIndex = rows.findIndex(function(row) {
    const normalized = row.map(function(value) {
      return String(value || "").trim().toLowerCase();
    });
    return SOURCING_HEADERS.every(function(header) {
      return normalized.indexOf(header.toLowerCase()) >= 0;
    });
  });
  if (headerRowIndex < 0) return [];

  const headers = rows[headerRowIndex].map(function(header) {
    return String(header || "").trim().toLowerCase();
  });
  const index = {};
  headers.forEach(function(header, i) {
    index[header] = i;
  });

  return rows.slice(headerRowIndex + 1)
    .map(function(row) {
      return {
        active: row[index.active],
        order: Number(row[index.order]) || 0,
        item: textOrEmpty(row[index.item]).trim(),
        product: textOrEmpty(row[index.product]).trim(),
        url: textOrEmpty(row[index.url]).trim(),
        quantity: textOrEmpty(row[index.quantity]).trim(),
        note: textOrEmpty(row[index.note]).trim()
      };
    })
    .filter(function(item) {
      return item.item && isCmsRowEnabled_(item.active);
    })
    .sort(function(a, b) {
      return a.order - b.order;
    })
    .map(function(item) {
      return {
        item: item.item,
        product: item.product,
        url: item.url,
        quantity: item.quantity,
        note: item.note
      };
    });
}

function getOrCreateSourcingSheet_() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  let sheet = ss.getSheetByName(SOURCING_SHEET_NAME);
  if (!sheet) {
    sheet = ss.insertSheet(SOURCING_SHEET_NAME);
  }

  if (sheet.getLastRow() === 0) {
    seedSourcingSheet_(sheet);
  } else {
    const firstRow = sheet.getRange(1, 1, 1, SOURCING_HEADERS.length).getValues()[0];
    const hasHeaders = firstRow.some(function(value) {
      return String(value || "").trim();
    });
    if (!hasHeaders) seedSourcingSheet_(sheet);
  }

  return sheet;
}

function seedSourcingSheet_(sheet) {
  sheet.clear();
  sheet.getRange(1, 1, 1, SOURCING_HEADERS.length).setValues([SOURCING_HEADERS]);
  sheet.setFrozenRows(1);
  sheet.autoResizeColumns(1, SOURCING_HEADERS.length);
}

function getGallerySheet_() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheets = ss.getSheets();
  return sheets.find(function(sheet) {
    const name = sheet.getName();
    return name !== CMS_SHEET_NAME && name !== INQUIRY_SHEET_NAME && name !== SOURCING_SHEET_NAME;
  }) || ss.getActiveSheet();
}

/* Design file downloads. Drop SCAD/STL/3MF files into the Drive folder
   "<gallery folder>/downloads" and they are listed on the site automatically. */
function getDownloadsFolder_() {
  const parent = DriveApp.getFolderById(FOLDER_ID);
  const existing = parent.getFoldersByName(DOWNLOADS_FOLDER_NAME);
  if (existing.hasNext()) return existing.next();
  return parent.createFolder(DOWNLOADS_FOLDER_NAME);
}

function listDownloadFiles_() {
  const folder = getDownloadsFolder_();
  const iterator = folder.getFiles();
  const files = [];

  while (iterator.hasNext()) {
    const file = iterator.next();
    try {
      file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
    } catch (err) {
      console.warn("Could not set sharing for " + file.getName() + ": " + err.message);
    }
    files.push({
      name: file.getName(),
      size: file.getSize(),
      updated: file.getLastUpdated(),
      id: file.getId()
    });
  }

  files.sort(function(a, b) {
    return a.name.localeCompare(b.name);
  });
  return files;
}

function formatFileSize_(bytes) {
  if (!bytes) return "";
  if (bytes < 1024) return bytes + " B";
  if (bytes < 1024 * 1024) return Math.round(bytes / 1024) + " KB";
  return (bytes / (1024 * 1024)).toFixed(1) + " MB";
}

function renderInitialDownloadsHtml() {
  try {
    const files = listDownloadFiles_();
    if (!files.length) {
      return '<div class="downloads-empty fine-print">Print files are being staged - check back shortly, or send a request below and I will email them to you directly.</div>';
    }

    return files.map(function(file) {
      const meta = [formatFileSize_(file.size),
        "Updated " + Utilities.formatDate(file.updated, Session.getScriptTimeZone(), "MMM d, yyyy")]
        .filter(Boolean).join(" · ");
      return '<a class="download-row" target="_blank" rel="noopener" href="https://drive.google.com/uc?export=download&id=' + file.id + '">' +
        '<span class="download-name">' + escapeHtmlServer(file.name) + '</span>' +
        '<span class="download-meta">' + escapeHtmlServer(meta) + '</span>' +
        '<span class="download-action" aria-hidden="true">Download</span>' +
        '</a>';
    }).join("");
  } catch (err) {
    return '<div class="downloads-empty fine-print">Download list error: ' + escapeHtmlServer(err.message || err) + '</div>';
  }
}

function getOrCreateInquirySheet_() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  let sheet = ss.getSheetByName(INQUIRY_SHEET_NAME);
  if (!sheet) {
    sheet = ss.insertSheet(INQUIRY_SHEET_NAME);
    sheet.getRange(1, 1, 1, 7).setValues([[
      "Timestamp",
      "Type",
      "Kit path",
      "Name",
      "Email",
      "Timeline",
      "Message"
    ]]);
    sheet.setFrozenRows(1);
    sheet.autoResizeColumns(1, 7);
  }
  return sheet;
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
