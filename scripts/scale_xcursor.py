#!/usr/bin/env python3
"""Scale an XCursor theme to a requested nominal cursor size.

The source theme is copied into a new directory. Each XCursor image chunk is
nearest-neighbour scaled, preserving the cursor hotspot and animation delay.
"""

from __future__ import annotations

import argparse
import shutil
import struct
from pathlib import Path

MAGIC = b"Xcur"
IMAGE_TYPE = 0xFFFD0002


def read_cursor_images(data: bytes) -> list[tuple[int, int, int, int, int, int, list[int]]]:
    if len(data) < 16 or data[:4] != MAGIC:
        raise ValueError("not an XCursor file")
    _, _, toc_count = struct.unpack_from("<3I", data, 4)
    images: list[tuple[int, int, int, int, int, int, list[int]]] = []
    for index in range(toc_count):
        toc_offset = 16 + index * 12
        if toc_offset + 12 > len(data):
            raise ValueError("truncated XCursor table of contents")
        chunk_type, _, chunk_offset = struct.unpack_from("<3I", data, toc_offset)
        if chunk_type != IMAGE_TYPE:
            continue
        if chunk_offset + 36 > len(data):
            raise ValueError("truncated XCursor image header")
        header, image_type, image_size, _, width, height, xhot, yhot, delay = struct.unpack_from("<9I", data, chunk_offset)
        if header < 36 or image_type != IMAGE_TYPE:
            raise ValueError("invalid XCursor image header")
        pixel_offset = chunk_offset + header
        pixel_count = width * height
        if pixel_offset + pixel_count * 4 > len(data):
            raise ValueError("truncated XCursor image pixels")
        pixels = list(struct.unpack_from(f"<{pixel_count}I", data, pixel_offset))
        images.append((image_size, width, height, xhot, yhot, delay, pixels))
    if not images:
        raise ValueError("XCursor file has no image chunks")
    return images


def resize_nearest(pixels: list[int], width: int, height: int, factor: int) -> list[int]:
    resized: list[int] = []
    for y in range(height):
        row = pixels[y * width:(y + 1) * width]
        expanded_row = [pixel for pixel in row for _ in range(factor)]
        for _ in range(factor):
            resized.extend(expanded_row)
    return resized


def scale_cursor_file(source: Path, target: Path, target_size: int) -> None:
    images = read_cursor_images(source.read_bytes())
    source_size = max(image_size for image_size, *_ in images)
    if source_size <= 0 or target_size <= 0:
        raise ValueError("cursor sizes must be positive")
    if target_size % source_size:
        raise ValueError(f"{target_size} is not an integer multiple of source size {source_size}")
    factor = target_size // source_size

    chunks: list[bytes] = []
    for _, width, height, xhot, yhot, delay, pixels in images:
        scaled_pixels = resize_nearest(pixels, width, height, factor)
        scaled_width = width * factor
        scaled_height = height * factor
        chunks.append(
            struct.pack(
                "<9I", 36, IMAGE_TYPE, target_size, 1, scaled_width, scaled_height, xhot * factor, yhot * factor, delay
            ) + struct.pack(f"<{len(scaled_pixels)}I", *scaled_pixels)
        )

    table_offset = 16
    cursor_offset = table_offset + 12 * len(chunks)
    table = bytearray()
    body = bytearray()
    for chunk in chunks:
        table.extend(struct.pack("<3I", IMAGE_TYPE, target_size, cursor_offset + len(body)))
        body.extend(chunk)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(MAGIC + struct.pack("<3I", 16, 1, len(chunks)) + table + body)


def scale_theme(source_theme: Path, target_theme: Path, target_size: int) -> None:
    source_cursors = source_theme / "cursors"
    if not (source_theme / "index.theme").is_file() or not source_cursors.is_dir():
        raise ValueError(f"{source_theme} is not a complete XCursor theme")
    if target_theme.exists():
        shutil.rmtree(target_theme)
    (target_theme / "cursors").mkdir(parents=True)
    shutil.copy2(source_theme / "index.theme", target_theme / "index.theme")
    for source_cursor in source_cursors.iterdir():
        if source_cursor.is_file():
            scale_cursor_file(source_cursor, target_theme / "cursors" / source_cursor.name, target_size)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source_theme", type=Path)
    parser.add_argument("target_theme", type=Path)
    parser.add_argument("target_size", type=int)
    args = parser.parse_args()
    scale_theme(args.source_theme, args.target_theme, args.target_size)


if __name__ == "__main__":
    main()
