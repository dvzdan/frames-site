import { HttpError, cleanText } from "./api-helpers.js";

export const CASSETTE_COLORS = {
  bone: { name: "Bone", finish: "matte" },
  blush: { name: "Dusty Blush", finish: "matte" },
  sage: { name: "Muted Sage", finish: "matte" }
};

export const STAND_COLORS = {
  navy: { name: "Midnight Navy", finish: "glossy" },
  oxblood: { name: "Oxblood", finish: "glossy" },
  forest: { name: "Dark Forest", finish: "glossy" }
};

export const CURATED_PAIRINGS = {
  original: { name: "Original", cassetteColorId: "bone", standColorId: "navy" },
  rose: { name: "Rose", cassetteColorId: "blush", standColorId: "oxblood" },
  grove: { name: "Grove", cassetteColorId: "sage", standColorId: "forest" }
};

function colorSummary(cassetteColorId, standColorId) {
  const cassette = CASSETTE_COLORS[cassetteColorId];
  const stand = STAND_COLORS[standColorId];
  return `Matte ${cassette.name} cassette + glossy ${stand.name} stand`;
}

export function emptyColorSelection() {
  return {
    colorMode: "",
    pairingId: "",
    cassetteColorId: "",
    standColorId: "",
    customColorNotes: "",
    colorSummary: ""
  };
}

export function validateColorSelection(data, { required = false, allowCustom = false } = {}) {
  const colorMode = cleanText(data && data.colorMode, 24, "Color choice");
  const customColorNotes = cleanText(data && data.customColorNotes, 500, "Custom color notes");

  if (!colorMode) {
    if (required) throw new HttpError(400, "Choose a color combination.");
    return emptyColorSelection();
  }

  if (colorMode === "curated") {
    const pairingId = cleanText(data && data.pairingId, 24, "Color pairing", true);
    const pairing = CURATED_PAIRINGS[pairingId];
    if (!pairing) throw new HttpError(400, "Choose a valid color combination.");
    return {
      colorMode,
      pairingId,
      cassetteColorId: pairing.cassetteColorId,
      standColorId: pairing.standColorId,
      customColorNotes: "",
      colorSummary: `${pairing.name} — ${colorSummary(pairing.cassetteColorId, pairing.standColorId)}`
    };
  }

  if (colorMode === "mixed") {
    const cassetteColorId = cleanText(data && data.cassetteColorId, 24, "Cassette color", true);
    const standColorId = cleanText(data && data.standColorId, 24, "Stand color", true);
    if (!CASSETTE_COLORS[cassetteColorId] || !STAND_COLORS[standColorId]) {
      throw new HttpError(400, "Choose valid stocked cassette and stand colors.");
    }
    return {
      colorMode,
      pairingId: "",
      cassetteColorId,
      standColorId,
      customColorNotes: "",
      colorSummary: `Mix & match — ${colorSummary(cassetteColorId, standColorId)}`
    };
  }

  if (colorMode === "custom" && allowCustom) {
    if (!customColorNotes) throw new HttpError(400, "Describe the custom colors you have in mind.");
    return {
      colorMode,
      pairingId: "",
      cassetteColorId: "",
      standColorId: "",
      customColorNotes,
      colorSummary: `Custom color request — ${customColorNotes}`
    };
  }

  throw new HttpError(400, allowCustom ? "Choose a valid color option." : "Custom colors require a quote before checkout.");
}
