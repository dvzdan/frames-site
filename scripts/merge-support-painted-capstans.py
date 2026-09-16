"""Transfer the approved painted-support capstan meshes into Everything Else.

The target project keeps its established plate, process, non-capstan objects,
and object placement. Only the two capstan meshes and their identifying
metadata are replaced. The minute and hour meshes come directly from the
retained Bambu component project so triangle-level support painting survives.
"""

from __future__ import annotations

import argparse
import copy
import os
from pathlib import Path
import re
import tempfile
import xml.etree.ElementTree as ET
import zipfile


SOURCE_MODELS = {
    "3D/Objects/object_2.model": {
        "target_entry": "3D/Objects/object_11.model",
        "settings_object_id": "11",
        "name": "Minute Capstan v2.0.4",
    },
    "3D/Objects/object_3.model": {
        "target_entry": "3D/Objects/object_15.model",
        "settings_object_id": "13",
        "name": "Hour Capstan v2.0.4",
    },
}


def mesh_fragment(xml: str) -> str:
    match = re.search(r"<mesh>.*?</mesh>", xml, re.DOTALL)
    if not match:
        raise ValueError("3MF object has no mesh")
    return match.group(0)


def triangle_count(mesh: str) -> int:
    return len(re.findall(r"<triangle\b", mesh))


def painted_triangle_count(mesh: str) -> int:
    return len(re.findall(r"\bpaint_supports=", mesh))


def replace_mesh(target_xml: str, source_mesh: str) -> str:
    updated, count = re.subn(
        r"<mesh>.*?</mesh>",
        lambda _match: source_mesh,
        target_xml,
        count=1,
        flags=re.DOTALL,
    )
    if count != 1:
        raise ValueError(f"Expected exactly one target mesh; replaced {count}")
    return updated


def metadata(object_element: ET.Element, key: str):
    return object_element.find(f"./metadata[@key='{key}']")


def update_model_settings(xml_bytes: bytes, replacements):
    root = ET.fromstring(xml_bytes)
    for replacement in replacements:
        obj = root.find(f"./object[@id='{replacement['settings_object_id']}']")
        if obj is None:
            raise ValueError(
                f"Settings object {replacement['settings_object_id']} was not found"
            )
        count = replacement["face_count"]
        object_name = metadata(obj, "name")
        if object_name is not None:
            object_name.set("value", replacement["name"])
        object_faces = obj.find("./metadata[@face_count]")
        if object_faces is not None:
            object_faces.set("face_count", str(count))
        part = obj.find("./part")
        if part is None:
            raise ValueError(f"Settings object {replacement['settings_object_id']} has no part")
        for key in ("name", "source_file"):
            item = metadata(part, key)
            if item is not None:
                item.set(
                    "value",
                    replacement["name"]
                    if key == "name"
                    else "capstans-v2.0.4.3mf",
                )
        mesh_stat = part.find("./mesh_stat")
        if mesh_stat is not None:
            mesh_stat.set("face_count", str(count))

    # The new hour capstan is 7.2 mm tall instead of 7.0 mm. Raise its object
    # center by 0.1 mm so the bed-facing flange remains exactly on the bed.
    assemble_item = root.find("./assemble/assemble_item[@object_id='13'][@instance_id='0']")
    if assemble_item is None:
        raise ValueError("Hour-capstan assemble transform was not found")
    values = assemble_item.get("transform", "").split()
    if not values:
        raise ValueError("Hour-capstan assemble transform is empty")
    values[-1] = "3.6"
    assemble_item.set("transform", " ".join(values))
    return ET.tostring(root, encoding="utf-8", xml_declaration=True)


def update_build_height(xml_bytes: bytes):
    xml = xml_bytes.decode("utf-8")
    pattern = re.compile(r'(<item\s+objectid="13"[^>]*\btransform=")([^"]+)(")')

    def replacement(match):
        values = match.group(2).split()
        values[-1] = "3.6"
        return match.group(1) + " ".join(values) + match.group(3)

    updated, count = pattern.subn(replacement, xml, count=1)
    if count != 1:
        raise ValueError("Hour-capstan build transform was not found")
    return updated.encode("utf-8")


def merge(target: Path, source: Path):
    with zipfile.ZipFile(target, "r") as archive:
        target_infos = archive.infolist()
        contents = {info.filename: archive.read(info.filename) for info in target_infos}
    with zipfile.ZipFile(source, "r") as archive:
        source_contents = {info.filename: archive.read(info.filename) for info in archive.infolist()}

    replacements = []
    for source_entry, spec in SOURCE_MODELS.items():
        source_xml = source_contents[source_entry].decode("utf-8")
        mesh = mesh_fragment(source_xml)
        faces = triangle_count(mesh)
        painted = painted_triangle_count(mesh)
        if painted == 0:
            raise ValueError(f"{source_entry} has no painted-support triangles")
        target_entry = spec["target_entry"]
        target_xml = contents[target_entry].decode("utf-8")
        contents[target_entry] = replace_mesh(target_xml, mesh).encode("utf-8")
        replacements.append({**spec, "face_count": faces, "painted_count": painted})

    contents["Metadata/model_settings.config"] = update_model_settings(
        contents["Metadata/model_settings.config"], replacements
    )
    contents["3D/3dmodel.model"] = update_build_height(contents["3D/3dmodel.model"])

    fd, temp_name = tempfile.mkstemp(prefix=target.stem + "-", suffix=".3mf", dir=target.parent)
    os.close(fd)
    temp_path = Path(temp_name)
    try:
        with zipfile.ZipFile(temp_path, "w") as destination:
            for info in target_infos:
                destination.writestr(copy.copy(info), contents[info.filename])
        os.replace(temp_path, target)
    finally:
        if temp_path.exists():
            temp_path.unlink()

    for replacement in replacements:
        print(
            f"{replacement['name']}: {replacement['face_count']} triangles, "
            f"{replacement['painted_count']} painted-support triangles"
        )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", required=True, type=Path)
    parser.add_argument("--source", required=True, type=Path)
    args = parser.parse_args()
    merge(args.target, args.source)


if __name__ == "__main__":
    main()
