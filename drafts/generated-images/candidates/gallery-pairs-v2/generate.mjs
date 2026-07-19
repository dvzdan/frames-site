// Gemini image generation pipeline for gallery concept pairs.
// Usage: node generate.mjs test | node generate.mjs all
// Requires env GEMINI_KEY.
import { writeFileSync, readFileSync, existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const DIR = dirname(fileURLToPath(import.meta.url));
const KEY = process.env.GEMINI_KEY;
if (!KEY) { console.error("Set GEMINI_KEY"); process.exit(1); }

const MODEL = process.env.MODEL || "gemini-3-pro-image";
const URL = `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`;

const STYLE = "Rich painterly illustration, soft brushwork, warm cinematic light, muted natural palette, storybook realism, fine detail, no text or lettering anywhere in the image. Portrait orientation.";

const PAIRS = [
  {
    slug: "01-rocket",
    cover: `A small vintage rocket standing quietly on a launch pad at dusk, gantry tower beside it, wisps of steam at its base, full moon and first stars in a purple-orange twilight sky. Mood: hushed anticipation, the second before everything happens. ${STYLE}`,
    reveal: `EDIT: Same rocket, same art style, moments later: now blasting upward through the night sky on a brilliant column of flame, stars streaking past, the curved blue horizon of Earth far below. Mood: triumphant release. Keep the exact same painterly style and palette as the input image.`
  },
  {
    slug: "02-iceberg",
    cover: `A small, modest tip of an iceberg breaking the surface of a calm polar sea, pale morning sun, single seabird, serene and unassuming. Mood: quiet understatement. ${STYLE}`,
    reveal: `EDIT: The same iceberg and same art style, but now seen from underwater: the vast, cathedral-sized hidden mass of the iceberg descending into deep blue darkness, shafts of light from the surface, tiny fish for scale, the familiar small tip just visible above the waterline. Mood: awe at what was hidden. Keep the exact same painterly style and palette as the input image.`
  },
  {
    slug: "03-magic",
    cover: `An upturned black magician's top hat resting on a small round table on a theatre stage, red velvet curtains, single spotlight, a white-tipped wand lying beside it, three faint golden sparkles above the hat. Mood: a promise about to be kept. ${STYLE}`,
    reveal: `EDIT: Same stage, same hat, same art style, one beat later: a delighted white rabbit has burst out of the hat, ears tall, paws on the brim, confetti and ribbons mid-air, the wand still spinning above. Mood: pure ta-da. Keep the exact same painterly style and palette as the input image.`
  },
  {
    slug: "04-map",
    cover: `An aged parchment treasure map spread on a dark wooden table: an island with mountains and palm trees, a dashed route winding to a bold red X, compass rose, worn folds and ink stains. Mood: the itch of adventure. ${STYLE}`,
    reveal: `EDIT: The place the map led to, in the same art style: inside a dim sea cave, an old wooden treasure chest thrown open, overflowing with gold coins, pearls and gems, warm golden light blazing from inside it, a shovel stuck in the sand nearby. Mood: found it. Keep the exact same painterly style and palette as the input image.`
  },
  {
    slug: "05-door",
    cover: `A weathered blue wooden door set in an old stone wall, iron bands and ring handle, a little potted plant beside it, warm golden light leaking out from under the door and through the keyhole. Mood: something wonderful is on the other side. ${STYLE}`,
    reveal: `EDIT: The same doorway and same art style, but the blue door now stands wide open: through the arch, a breathtaking sunset valley with mountains, a winding path leading from the doorstep into golden fields, birds in the sky. Mood: invitation to step through. Keep the exact same painterly style and palette as the input image.`
  }
];

async function generate(prompt, inputImagePath, outPath) {
  const parts = [];
  if (inputImagePath) {
    parts.push({ inline_data: { mime_type: "image/png", data: readFileSync(inputImagePath).toString("base64") } });
  }
  parts.push({ text: prompt });

  const body = {
    contents: [{ parts }],
    generationConfig: {
      responseModalities: ["IMAGE"],
      imageConfig: { aspectRatio: "3:4" }
    }
  };

  const res = await fetch(URL, {
    method: "POST",
    headers: { "Content-Type": "application/json", "x-goog-api-key": KEY },
    body: JSON.stringify(body)
  });
  const json = await res.json();
  if (!res.ok) {
    throw new Error(`HTTP ${res.status}: ${JSON.stringify(json).slice(0, 500)}`);
  }
  const cand = json.candidates && json.candidates[0];
  const imgPart = cand && cand.content && cand.content.parts && cand.content.parts.find(p => p.inlineData || p.inline_data);
  if (!imgPart) {
    throw new Error("No image in response: " + JSON.stringify(json).slice(0, 500));
  }
  const data = (imgPart.inlineData || imgPart.inline_data).data;
  writeFileSync(outPath, Buffer.from(data, "base64"));
  console.log("wrote", outPath, Buffer.from(data, "base64").length, "bytes");
}

const mode = process.argv[2] || "test";

if (mode === "test") {
  await generate(PAIRS[1].cover, null, join(DIR, "test-iceberg-cover.png"));
} else if (mode === "all") {
  for (const pair of PAIRS) {
    const coverPath = join(DIR, `${pair.slug}-cover.png`);
    const revealPath = join(DIR, `${pair.slug}-reveal.png`);
    if (!existsSync(coverPath)) {
      console.log(`generating ${pair.slug} cover...`);
      await generate(pair.cover, null, coverPath);
    }
    if (!existsSync(revealPath)) {
      console.log(`generating ${pair.slug} reveal (from cover)...`);
      await generate(pair.reveal, coverPath, revealPath);
    }
  }
} else if (mode === "one") {
  // node generate.mjs one <slug> <cover|reveal>
  const pair = PAIRS.find(p => p.slug === process.argv[3]);
  const which = process.argv[4];
  const coverPath = join(DIR, `${pair.slug}-cover.png`);
  if (which === "cover") await generate(pair.cover, null, coverPath);
  else await generate(pair.reveal, coverPath, join(DIR, `${pair.slug}-reveal.png`));
}
