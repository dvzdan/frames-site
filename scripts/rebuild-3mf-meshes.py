"""Replace selected Bambu 3MF meshes with OpenSCAD ASCII-STL exports.

The existing projects retain their printer, process, support-enforcer, and
placement metadata. New meshes are centered on the model-space bounds of the
objects they replace; Bambu Studio performs the final project round-trip.
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


REPO_ROOT = Path(__file__).resolve().parents[1]

PROJECTS = {
    "everything": {
        "project": REPO_ROOT / "fabrication/canonical/3mf/everything-else-v2.0.0.project.3mf",
        "replacements": [
            {
                "entry": "3D/Objects/object_3.model",
                "mesh_object_id": "10",
                "settings_object_id": "11",
                "settings_part_id": "10",
                "stl": "capstans-v2.0.0-ascii.stl",
                "name": "Capstans v2.0.0.stl",
            },
            {
                "entry": "3D/Objects/object_4.model",
                "mesh_object_id": "6",
                "settings_object_id": "7",
                "settings_part_id": "6",
                "stl": "clock-string-guide-v2.0.0-ascii.stl",
                "name": "Clock String Guide v2.0.0.stl",
            },
        ],
    },
    "frame": {
        "project": REPO_ROOT / "fabrication/canonical/3mf/frame-and-stand-v2.0.0.project.3mf",
        "replacements": [
            {
                "entry": "3D/Objects/object_20.model",
                "mesh_object_id": "1",
                "settings_object_id": "6",
                "settings_part_id": "1",
                "stl": "main-frame-v2.0.0-dry-ascii.stl",
                "name": "Main Frame v2.0.0.stl",
            },
        ],
    },
}


def parse_ascii_stl(path: Path):
    vertices: list[tuple[float, float, float]] = []
    triangles: list[tuple[int, int, int]] = []
    indices: dict[tuple[float, float, float], int] = {}
    facet: list[int] = []

    with path.open("r", encoding="utf-8", errors="strict") as source:
        for raw_line in source:
            line = raw_line.strip()
            if not line.startswith("vertex "):
                continue
            values = tuple(float(value) for value in line.split()[1:4])
            normalized = tuple(0.0 if value == 0 else value for value in values)
            index = indices.get(normalized)
            if index is None:
                index = len(vertices)
                indices[normalized] = index
                vertices.append(normalized)
            facet.append(index)
            if len(facet) == 3:
                triangles.append(tuple(facet))
                facet = []

    if facet or not triangles:
        raise ValueError(f"Invalid or empty ASCII STL: {path}")
    return vertices, triangles


def bounds(vertices):
    return tuple(
        (min(vertex[axis] for vertex in vertices), max(vertex[axis] for vertex in vertices))
        for axis in range(3)
    )


def object_pattern(object_id: str):
    return re.compile(
        rf'(<object\b(?=[^>]*\bid="{re.escape(object_id)}"(?:\s|>))[^>]*>\s*)<mesh>.*?</mesh>',
        re.DOTALL,
    )


def existing_object_vertices(xml: str, object_id: str):
    match = object_pattern(object_id).search(xml)
    if not match:
        raise ValueError(f"Object {object_id} was not found")
    mesh_xml = match.group(0)
    values = re.findall(
        r'<vertex\s+x="([^"]+)"\s+y="([^"]+)"\s+z="([^"]+)"\s*/>',
        mesh_xml,
    )
    if not values:
        raise ValueError(f"Object {object_id} has no vertices")
    return [tuple(float(value) for value in vertex) for vertex in values]


def aligned_vertices(new_vertices, old_vertices):
    old_bounds = bounds(old_vertices)
    new_bounds = bounds(new_vertices)
    shift = tuple(
        (old_bounds[axis][0] + old_bounds[axis][1]) / 2
        - (new_bounds[axis][0] + new_bounds[axis][1]) / 2
        for axis in range(3)
    )
    return [
        tuple(vertex[axis] + shift[axis] for axis in range(3))
        for vertex in new_vertices
    ]


def number(value: float):
    if abs(value) < 5e-10:
        value = 0.0
    return format(value, ".9g")


def mesh_xml(vertices, triangles):
    vertex_lines = "\n".join(
        f'     <vertex x="{number(x)}" y="{number(y)}" z="{number(z)}"/>'
        for x, y, z in vertices
    )
    triangle_lines = "\n".join(
        f'     <triangle v1="{v1}" v2="{v2}" v3="{v3}"/>'
        for v1, v2, v3 in triangles
    )
    return (
        "<mesh>\n"
        "    <vertices>\n"
        f"{vertex_lines}\n"
        "    </vertices>\n"
        "    <triangles>\n"
        f"{triangle_lines}\n"
        "    </triangles>\n"
        "   </mesh>"
    )


def replace_mesh(xml: str, object_id: str, vertices, triangles):
    pattern = object_pattern(object_id)
    old_vertices = existing_object_vertices(xml, object_id)
    positioned = aligned_vertices(vertices, old_vertices)
    replacement = lambda match: match.group(1) + mesh_xml(positioned, triangles)
    updated, count = pattern.subn(replacement, xml, count=1)
    if count != 1:
        raise ValueError(f"Expected one object {object_id}, replaced {count}")
    return updated, positioned


def update_settings(xml_bytes: bytes, replacements_with_counts):
    root = ET.fromstring(xml_bytes)
    for replacement, face_count in replacements_with_counts:
        obj = root.find(f"./object[@id='{replacement['settings_object_id']}']")
        if obj is None:
            raise ValueError(f"Settings object {replacement['settings_object_id']} was not found")
        object_name = obj.find("./metadata[@key='name']")
        object_faces = obj.find("./metadata[@face_count]")
        part = obj.find(f"./part[@id='{replacement['settings_part_id']}']")
        if object_name is not None:
            object_name.set("value", replacement["name"])
        if object_faces is not None:
            object_faces.set("face_count", str(face_count))
        if part is None:
            raise ValueError(f"Settings part {replacement['settings_part_id']} was not found")
        for key in ("name", "source_file"):
            metadata = part.find(f"./metadata[@key='{key}']")
            if metadata is not None:
                metadata.set("value", replacement["name"])
        mesh_stat = part.find("./mesh_stat")
        if mesh_stat is not None:
            mesh_stat.set("face_count", str(face_count))
    return ET.tostring(root, encoding="utf-8", xml_declaration=True)


def rewrite_project(project: Path, build_root: Path, replacements):
    with zipfile.ZipFile(project, "r") as source:
        infos = source.infolist()
        contents = {info.filename: source.read(info.filename) for info in infos}

    counts = []
    for replacement in replacements:
        stl_path = build_root / replacement["stl"]
        new_vertices, triangles = parse_ascii_stl(stl_path)
        entry = replacement["entry"]
        xml = contents[entry].decode("utf-8")
        updated, positioned = replace_mesh(
            xml,
            replacement["mesh_object_id"],
            new_vertices,
            triangles,
        )
        contents[entry] = updated.encode("utf-8")
        counts.append((replacement, len(triangles)))
        new_bounds = bounds(positioned)
        print(
            f"{project.name}: {replacement['name']} — "
            f"{len(positioned)} vertices, {len(triangles)} triangles, bounds {new_bounds}"
        )

    settings_entry = "Metadata/model_settings.config"
    contents[settings_entry] = update_settings(contents[settings_entry], counts)

    fd, temp_name = tempfile.mkstemp(prefix=project.stem + "-", suffix=".3mf", dir=project.parent)
    os.close(fd)
    temp_path = Path(temp_name)
    try:
        with zipfile.ZipFile(temp_path, "w") as destination:
            for info in infos:
                cloned = copy.copy(info)
                destination.writestr(cloned, contents[info.filename])
        os.replace(temp_path, project)
    finally:
        if temp_path.exists():
            temp_path.unlink()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--build-root", required=True, type=Path)
    args = parser.parse_args()
    for spec in PROJECTS.values():
        rewrite_project(spec["project"], args.build_root, spec["replacements"])


if __name__ == "__main__":
    main()
